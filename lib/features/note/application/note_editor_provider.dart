import 'dart:async';
import 'dart:io';

import 'package:chain_notes/features/home/data/service/gas_speed.dart';
import 'package:chain_notes/features/note/application/note_on_chain_confirm_provider.dart';
import 'package:chain_notes/features/home/domain/entity/note.dart';
import 'package:chain_notes/features/note/data/service/ipfs_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_editor_provider.g.dart';

class NoteEditorState {
  const NoteEditorState({
    required this.noteId,
    required this.title,
    required this.content,
    required this.imageUrls,
    this.isSaving = false,
    this.isUploading = false,
    this.isPublishing = false,
  });

  final String noteId;
  final String title;
  final String content;
  final List<String> imageUrls;
  final bool isSaving;
  final bool isUploading;
  final bool isPublishing;

  factory NoteEditorState.initial(Note note) => NoteEditorState(
        noteId: note.id,
        title: note.title,
        content: note.content,
        imageUrls: List<String>.from(note.imageUrls),
      );

  bool get canSave => title.trim().isNotEmpty && content.trim().isNotEmpty;
  bool get isNewNote => noteId.startsWith('new_');

  NoteEditorState copyWith({
    String? title,
    String? content,
    List<String>? imageUrls,
    bool? isSaving,
    bool? isUploading,
    bool? isPublishing,
  }) {
    return NoteEditorState(
      noteId: noteId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      isSaving: isSaving ?? this.isSaving,
      isUploading: isUploading ?? this.isUploading,
      isPublishing: isPublishing ?? this.isPublishing,
    );
  }
}

@riverpod
class NoteEditor extends _$NoteEditor {
  Timer? _saveTimer;

  @override
  NoteEditorState build(Note note) {
    ref.onDispose(() {
      _saveTimer?.cancel();
    });
    return NoteEditorState.initial(note);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setContent(String content) {
    state = state.copyWith(content: content);
  }

  void setImageUrls(List<String> urls) {
    state = state.copyWith(imageUrls: List<String>.from(urls));
  }

  void addImage(String pathOrUrl) {
    state = state.copyWith(
      imageUrls: [...state.imageUrls, pathOrUrl],
    );
  }

  void removeImage(int index) {
    final urls = List<String>.from(state.imageUrls);
    if (index >= 0 && index < urls.length) {
      urls.removeAt(index);
      state = state.copyWith(imageUrls: urls);
    }
  }

  void setUploading(bool value) {
    state = state.copyWith(isUploading: value);
  }

  void scheduleSave({
    required Note originalNote,
    required void Function(String id, Map<String, dynamic> updates) onUpdateNote,
  }) {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () {
      final s = state;
      if (_hasChanges(s, originalNote)) {
        onUpdateNote(s.noteId, {
          'title': s.title,
          'content': s.content,
          'imageUrls': s.imageUrls,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  bool _hasChanges(NoteEditorState s, Note original) {
    if (s.title != original.title) return true;
    if (s.content != original.content) return true;
    if (s.imageUrls.length != original.imageUrls.length) return true;
    for (var i = 0; i < s.imageUrls.length; i++) {
      if (s.imageUrls[i] != original.imageUrls[i]) return true;
    }
    return false;
  }

  Future<void> save({
    required void Function(String id, Map<String, dynamic> updates) onUpdateNote,
    NoteType? type,
    bool? onChain,
    bool uploadToIpfs = false,
  }) async {
    _saveTimer?.cancel();
    if (!state.canSave) return;
    state = state.copyWith(isSaving: true);

    var content = state.content.trim();
    var imageUrls = List<String>.from(state.imageUrls);

    if (uploadToIpfs) {
      try {
        final (newContent, newImageUrls) = await _uploadLocalImages(content, imageUrls);
        content = newContent;
        imageUrls = newImageUrls;
        state = state.copyWith(content: content, imageUrls: imageUrls);
      } catch (_) {
        state = state.copyWith(isSaving: false);
        rethrow;
      }
    }

    final updates = <String, dynamic>{
      'title': state.title.trim(),
      'content': content,
      'imageUrls': imageUrls,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    if (type != null) updates['type'] = type;
    if (onChain != null) updates['onChain'] = onChain;
    onUpdateNote(state.noteId, updates);
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(isSaving: false);
  }

  static final RegExp _imagePattern = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

  static bool stateRequiresIpfsUpload(NoteEditorState state) {
    for (final m in _imagePattern.allMatches(state.content)) {
      final url = m.group(2) ?? '';
      if (_isLocalPath(url)) return true;
    }
    for (final url in state.imageUrls) {
      if (_isLocalPath(url)) return true;
    }
    return false;
  }

  static bool _isLocalPath(String url) {
    if (url.isEmpty) return false;
    if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('ipfs://')) {
      return false;
    }
    return true;
  }

  static String _toFilePath(String url) {
    if (url.startsWith('file://')) return url.substring(7);
    return url;
  }

  Future<(String content, List<String> imageUrls)> _uploadLocalImages(
    String content,
    List<String> imageUrls,
  ) async {
    final pathToUrl = <String, String>{};

    for (final m in _imagePattern.allMatches(content)) {
      final url = m.group(2) ?? '';
      if (_isLocalPath(url)) {
        final path = _toFilePath(url);
        if (!pathToUrl.containsKey(path)) {
          try {
            final ipfsUrl = await IpfsService.instance.uploadFile(file: File(path));
            pathToUrl[path] = ipfsUrl;
          } catch (_) {
            rethrow;
          }
        }
      }
    }

    for (var i = 0; i < imageUrls.length; i++) {
      final url = imageUrls[i];
      if (_isLocalPath(url)) {
        final path = _toFilePath(url);
        if (!pathToUrl.containsKey(path)) {
          try {
            final ipfsUrl = await IpfsService.instance.uploadFile(file: File(path));
            pathToUrl[path] = ipfsUrl;
          } catch (_) {
            rethrow;
          }
        }
        imageUrls[i] = pathToUrl[path]!;
      }
    }

    var newContent = content;
    for (final e in pathToUrl.entries) {
      final path = e.key;
      final ipfsUrl = e.value;
      final orig = path.startsWith('file://') ? path : path;
      newContent = newContent.replaceAll(']( $orig )', ']($ipfsUrl)');
      newContent = newContent.replaceAll(']($path)', ']($ipfsUrl)');
      if (!path.startsWith('file://')) {
        newContent = newContent.replaceAll('](file://$path)', ']($ipfsUrl)');
      }
    }

    return (newContent, imageUrls);
  }

  Future<bool> publish({
    required Future<NotePublishResult> Function(
      String id,
      GasSpeed gasSpeed, {
      String? verifiedMasterKeyBase64,
      bool suppressSuccessNavigation,
    }) onPublishToBlockchain,
    required GasSpeed gasSpeed,
  }) async {
    if (!state.canSave) return false;
    state = state.copyWith(isPublishing: true);
    try {
      final r = await onPublishToBlockchain(state.noteId, gasSpeed);
      return r.ok;
    } finally {
      state = state.copyWith(isPublishing: false);
    }
  }
}
