import 'package:lib_uikit/lib_uikit.dart' show NoteType;

export 'package:lib_uikit/lib_uikit.dart' show NoteType;

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.createdAt,
    this.imageUrls = const [],
    this.onChain = false,
    this.type = NoteType.local,
    this.blockchainHash,
    this.chainId,
    this.aggregatedWalletId,
    this.contentHash,
    this.author,
    this.tokenUri,
    this.contentUri,
  });

  final String id;
  final String title;
  final String content;
  final int updatedAt;

  final int? createdAt;
  final List<String> imageUrls;
  final bool onChain;
  final NoteType type;

  final String? blockchainHash;

  final int? chainId;

  final int? aggregatedWalletId;

  final String? contentHash;

  final String? author;

  final String? tokenUri;

  final String? contentUri;

  int get createdAtOrUpdated => createdAt ?? updatedAt;

  Note copyWith({
    String? id,
    String? title,
    String? content,
    int? updatedAt,
    int? createdAt,
    List<String>? imageUrls,
    bool? onChain,
    NoteType? type,
    String? blockchainHash,
    int? chainId,
    int? aggregatedWalletId,
    String? contentHash,
    String? author,
    String? tokenUri,
    String? contentUri,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      onChain: onChain ?? this.onChain,
      type: type ?? this.type,
      blockchainHash: blockchainHash ?? this.blockchainHash,
      chainId: chainId ?? this.chainId,
      aggregatedWalletId: aggregatedWalletId ?? this.aggregatedWalletId,
      contentHash: contentHash ?? this.contentHash,
      author: author ?? this.author,
      tokenUri: tokenUri ?? this.tokenUri,
      contentUri: contentUri ?? this.contentUri,
    );
  }
}
