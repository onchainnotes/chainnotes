// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_realm_models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class NoteRealm extends _NoteRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  NoteRealm(
    String id,
    String title,
    String content,
    int updatedAt,
    bool onChain,
    int type,
    int chainId, {
    int? createdAt,
    String imageUrlsJson = '[]',
    String? blockchainHash,
    int? aggregatedWalletId,
    String? contentHash,
    String? author,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<NoteRealm>({
        'imageUrlsJson': '[]',
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'imageUrlsJson', imageUrlsJson);
    RealmObjectBase.set(this, 'onChain', onChain);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'blockchainHash', blockchainHash);
    RealmObjectBase.set(this, 'chainId', chainId);
    RealmObjectBase.set(this, 'aggregatedWalletId', aggregatedWalletId);
    RealmObjectBase.set(this, 'contentHash', contentHash);
    RealmObjectBase.set(this, 'author', author);
  }

  NoteRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  int get updatedAt => RealmObjectBase.get<int>(this, 'updatedAt') as int;
  @override
  set updatedAt(int value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int? get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int?;
  @override
  set createdAt(int? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String get imageUrlsJson =>
      RealmObjectBase.get<String>(this, 'imageUrlsJson') as String;
  @override
  set imageUrlsJson(String value) =>
      RealmObjectBase.set(this, 'imageUrlsJson', value);

  @override
  bool get onChain => RealmObjectBase.get<bool>(this, 'onChain') as bool;
  @override
  set onChain(bool value) => RealmObjectBase.set(this, 'onChain', value);

  @override
  int get type => RealmObjectBase.get<int>(this, 'type') as int;
  @override
  set type(int value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get blockchainHash =>
      RealmObjectBase.get<String>(this, 'blockchainHash') as String?;
  @override
  set blockchainHash(String? value) =>
      RealmObjectBase.set(this, 'blockchainHash', value);

  @override
  int get chainId => RealmObjectBase.get<int>(this, 'chainId') as int;
  @override
  set chainId(int value) => RealmObjectBase.set(this, 'chainId', value);

  @override
  int? get aggregatedWalletId =>
      RealmObjectBase.get<int>(this, 'aggregatedWalletId') as int?;
  @override
  set aggregatedWalletId(int? value) =>
      RealmObjectBase.set(this, 'aggregatedWalletId', value);

  @override
  String? get contentHash =>
      RealmObjectBase.get<String>(this, 'contentHash') as String?;
  @override
  set contentHash(String? value) =>
      RealmObjectBase.set(this, 'contentHash', value);

  @override
  String? get author => RealmObjectBase.get<String>(this, 'author') as String?;
  @override
  set author(String? value) => RealmObjectBase.set(this, 'author', value);

  @override
  Stream<RealmObjectChanges<NoteRealm>> get changes =>
      RealmObjectBase.getChanges<NoteRealm>(this);

  @override
  Stream<RealmObjectChanges<NoteRealm>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<NoteRealm>(this, keyPaths);

  @override
  NoteRealm freeze() => RealmObjectBase.freezeObject<NoteRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'content': content.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'createdAt': createdAt.toEJson(),
      'imageUrlsJson': imageUrlsJson.toEJson(),
      'onChain': onChain.toEJson(),
      'type': type.toEJson(),
      'blockchainHash': blockchainHash.toEJson(),
      'chainId': chainId.toEJson(),
      'aggregatedWalletId': aggregatedWalletId.toEJson(),
      'contentHash': contentHash.toEJson(),
      'author': author.toEJson(),
    };
  }

  static EJsonValue _toEJson(NoteRealm value) => value.toEJson();
  static NoteRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'content': EJsonValue content,
        'updatedAt': EJsonValue updatedAt,
        'onChain': EJsonValue onChain,
        'type': EJsonValue type,
        'chainId': EJsonValue chainId,
      } =>
        NoteRealm(
          fromEJson(id),
          fromEJson(title),
          fromEJson(content),
          fromEJson(updatedAt),
          fromEJson(onChain),
          fromEJson(type),
          fromEJson(chainId),
          createdAt: fromEJson(ejson['createdAt']),
          imageUrlsJson: fromEJson(ejson['imageUrlsJson'], defaultValue: '[]'),
          blockchainHash: fromEJson(ejson['blockchainHash']),
          aggregatedWalletId: fromEJson(ejson['aggregatedWalletId']),
          contentHash: fromEJson(ejson['contentHash']),
          author: fromEJson(ejson['author']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(NoteRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, NoteRealm, 'NoteRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('updatedAt', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.int, optional: true),
      SchemaProperty('imageUrlsJson', RealmPropertyType.string),
      SchemaProperty('onChain', RealmPropertyType.bool),
      SchemaProperty('type', RealmPropertyType.int),
      SchemaProperty(
        'blockchainHash',
        RealmPropertyType.string,
        optional: true,
      ),
      SchemaProperty('chainId', RealmPropertyType.int),
      SchemaProperty(
        'aggregatedWalletId',
        RealmPropertyType.int,
        optional: true,
      ),
      SchemaProperty('contentHash', RealmPropertyType.string, optional: true),
      SchemaProperty('author', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
