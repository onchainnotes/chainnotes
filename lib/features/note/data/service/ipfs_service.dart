import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';

class IpfsFileUploadException implements Exception {
  IpfsFileUploadException(this.cause);
  final Object cause;
}

String describeIpfsUploadCause(Object cause) {
  if (cause is DioException) {
    final code = cause.response?.statusCode;
    final msg = (cause.message ?? '').trim();
    final data = cause.response?.data;
    final tail = data == null
        ? ''
        : (data is Map
            ? (data['error']?.toString() ?? jsonEncode(data))
            : data.toString());
    final parts = <String>[
      if (code != null) 'HTTP $code',
      if (msg.isNotEmpty) msg,
      if (tail.isNotEmpty && tail != msg) tail,
    ];
    var s = parts.join(' · ');
    if (s.isEmpty) s = cause.type.name;
    return s.length > 240 ? '${s.substring(0, 237)}…' : s;
  }
  final s = cause.toString();
  return s.length > 240 ? '${s.substring(0, 237)}…' : s;
}

/// IPFS Service (Pinata)

class IpfsService {
  IpfsService._();

  static final IpfsService instance = IpfsService._();
  static final RegExp _contentImagePattern = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

  /// Pinata JWT

  static const String _jwt = "{sensitive information}";

  /// Pinata API
  static const String _baseUrl = "https://api.pinata.cloud";

  /// Pinata Gateway
  static const String _gateway = "https://gateway.pinata.cloud/ipfs/";

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        "Authorization": "Bearer $_jwt",
      },
    ),
  );

  Future<String> uploadFile({
    required File file,
    String? fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName ?? file.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        "/pinning/pinFileToIPFS",
        data: formData,
      );

      final hash = response.data["IpfsHash"];
      final uri = _buildIpfsUri(hash);
      debugPrint('[IPFS] 文件上传成功: $uri');
      return uri;
    } catch (e) {
      debugPrint('[IPFS] 文件上传失败: $e');
      throw IpfsFileUploadException(e);
    }
  }

  Future<String> uploadMetadata({
    required Map<String, dynamic> metadata,
    String? name,
  }) async {
    try {
      final body = {
        "pinataMetadata": {
          "name": name ?? "nft-metadata",
        },
        "pinataContent": metadata,
      };

      final response = await _dio.post(
        "/pinning/pinJSONToIPFS",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      final hash = response.data["IpfsHash"];
      final uri = _buildIpfsUri(hash);
      debugPrint('[IPFS] JSON 上传成功: $uri');
      return uri;
    } catch (e) {
      throw Exception("IPFS metadata upload failed: $e");
    }
  }

  /// {
  ///   "title": "...",
  ///   "content": "...",
  ///   "images": ["ipfs://Qm...", ...],
  ///   "author": "0x...",

  /// }
  Map<String, dynamic> buildNoteContentJson({
    required String title,
    required String content,
    required List<String> imageIpfsUrls,
    required String author,
    required int createdAtMs,
  }) {
    final createdAt = (createdAtMs / 1000).floor();
    return {
      "title": title,
      "content": content,
      "images": List<String>.from(imageIpfsUrls),
      "author": author,
      "createdAt": createdAt,
    };
  }

  /// {
  ///   "name": "Note #1",
  ///   "description": "OnChain Note",
  ///   "image": "ipfs://QmImageCID",
  ///   "contentURI": "ipfs://QmNoteCID"
  /// }
  Map<String, dynamic> buildNoteNftMetadata({
    required String name,
    required String description,
    required String contentIpfs,
    String? imageIpfs,
  }) {
    return {
      "name": name,
      "description": description,
      if (imageIpfs != null && imageIpfs.isNotEmpty) "image": imageIpfs,
      "contentURI": contentIpfs,
    };
  }

  Future<List<String>> resolveImagesToIpfs(List<String> imageUrls) async {
    final ipfsUrls = <String>[];
    for (final pathOrUrl in imageUrls) {
      if (pathOrUrl.startsWith('ipfs://')) {
        ipfsUrls.add(pathOrUrl);
      } else if (!pathOrUrl.startsWith('http://') &&
          !pathOrUrl.startsWith('https://')) {
        final file = File(pathOrUrl);
        if (await file.exists()) {
          final uri = await uploadFile(file: file);
          ipfsUrls.add(uri);
        }
      }
    }
    return ipfsUrls;
  }

  String replaceContentImageUrlsWithIpfs({
    required String content,
    required List<String> originalImageUrls,
    required List<String> imageIpfsUrls,
  }) {
    if (content.isEmpty ||
        originalImageUrls.isEmpty ||
        imageIpfsUrls.isEmpty) {
      return content;
    }
    var replaced = content;
    final n = originalImageUrls.length < imageIpfsUrls.length
        ? originalImageUrls.length
        : imageIpfsUrls.length;
    for (var i = 0; i < n; i++) {
      final from = originalImageUrls[i];
      final to = imageIpfsUrls[i];
      if (from.isEmpty || to.isEmpty || from == to) continue;
      replaced = replaced.replaceAll(from, to);
    }

    if (replaced.contains('![') && imageIpfsUrls.isNotEmpty) {
      int idx = 0;
      replaced = replaced.replaceAllMapped(_contentImagePattern, (m) {
        final alt = m.group(1) ?? '';
        final oldUrl = m.group(2) ?? '';
        if (idx >= imageIpfsUrls.length) return m.group(0) ?? '';
        final nextIpfs = imageIpfsUrls[idx++];
        if (oldUrl.startsWith('ipfs://')) return m.group(0) ?? '';
        return '![$alt]($nextIpfs)';
      });
    }
    return replaced;
  }

  int countReplacedImageRefsInContent({
    required String content,
    required List<String> originalImageUrls,
    required List<String> imageIpfsUrls,
  }) {
    if (content.isEmpty ||
        originalImageUrls.isEmpty ||
        imageIpfsUrls.isEmpty) {
      return 0;
    }
    var count = 0;
    final n = originalImageUrls.length < imageIpfsUrls.length
        ? originalImageUrls.length
        : imageIpfsUrls.length;
    for (var i = 0; i < n; i++) {
      final from = originalImageUrls[i];
      final to = imageIpfsUrls[i];
      if (from.isEmpty || to.isEmpty || from == to) continue;
      if (content.contains(from)) count++;
    }
    return count;
  }

  String computeNoteContentHash({
    required String title,
    required String content,
    required List<String> imageIpfsUrls,
    required String author,
    required int createdAtMs,
  }) {
    final noteContent = buildNoteContentJson(
      title: title,
      content: content,
      imageIpfsUrls: imageIpfsUrls,
      author: author,
      createdAtMs: createdAtMs,
    );
    final jsonStr = jsonEncode(noteContent);
    final digest = sha256.convert(utf8.encode(jsonStr));
    return '0x${digest.bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('')}';
  }

  Future<({
    String tokenUri,
    String contentUri,
    String contentHash,
    List<String> imageIpfsUrls,
    String contentWithIpfsImages
  })>
      uploadNoteAsNftTokenUri({
    required Note note,
    required String authorAddress,
  }) async {
    final originalImageUrls = List<String>.from(note.imageUrls);
    final imageIpfsUrls = await resolveImagesToIpfs(originalImageUrls);
    final replacedBefore = countReplacedImageRefsInContent(
      content: note.content,
      originalImageUrls: originalImageUrls,
      imageIpfsUrls: imageIpfsUrls,
    );
    final contentWithIpfsImages = replaceContentImageUrlsWithIpfs(
      content: note.content,
      originalImageUrls: originalImageUrls,
      imageIpfsUrls: imageIpfsUrls,
    );
    final replacedAfter = countReplacedImageRefsInContent(
      content: contentWithIpfsImages,
      originalImageUrls: originalImageUrls,
      imageIpfsUrls: imageIpfsUrls,
    );
    debugPrint(
      '[IPFS] 笔记正文图片链接替换: beforeHits=$replacedBefore '
      'afterHits=$replacedAfter replaced=${replacedBefore - replacedAfter}',
    );

    final noteContent = buildNoteContentJson(
      title: note.title,
      content: contentWithIpfsImages,
      imageIpfsUrls: imageIpfsUrls,
      author: authorAddress,
      createdAtMs: note.createdAtOrUpdated,
    );

    final contentHash = computeNoteContentHash(
      title: note.title,
      content: contentWithIpfsImages,
      imageIpfsUrls: imageIpfsUrls,
      author: authorAddress,
      createdAtMs: note.createdAtOrUpdated,
    );

    final contentIpfs = await uploadMetadata(
      metadata: noteContent,
      name: 'note-${note.id}',
    );

    final nftMetadata = buildNoteNftMetadata(
      name: note.title,
      description: 'OnChain Note',
      contentIpfs: contentIpfs,
      imageIpfs: imageIpfsUrls.isNotEmpty ? imageIpfsUrls.first : null,
    );

    final tokenUri = await uploadMetadata(
      metadata: nftMetadata,
      name: 'nft-${note.id}',
    );

    return (
      tokenUri: tokenUri,
      contentUri: contentIpfs,
      contentHash: contentHash,
      imageIpfsUrls: imageIpfsUrls,
      contentWithIpfsImages: contentWithIpfsImages
    );
  }

  String ipfsToHttp(String ipfsUri) {
    final hash = ipfsUri.replaceFirst("ipfs://", "");
    return "$_gateway$hash";
  }

  Future<Map<String, dynamic>?> fetchJsonFromUri(String uri) async {
    try {
      String url;
      if (uri.startsWith('ipfs://')) {
        url = ipfsToHttp(uri);
      } else if (uri.startsWith('http://') || uri.startsWith('https://')) {
        url = uri;
      } else {
        return null;
      }
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      final response = await dio.get<String>(url);
      if (response.data == null) return null;
      final decoded = jsonDecode(response.data!) as Map<String, dynamic>?;
      return decoded;
    } catch (_) {
      return null;
    }
  }

  String _buildIpfsUri(String hash) => "ipfs://$hash";
}
