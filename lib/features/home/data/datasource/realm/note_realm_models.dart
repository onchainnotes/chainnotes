import 'package:realm/realm.dart';

part 'note_realm_models.realm.dart';

@RealmModel()
class _NoteRealm {
  @PrimaryKey()
  late String id;

  late String title;
  late String content;
  late int updatedAt;
  int? createdAt;

  String imageUrlsJson = '[]';

  late bool onChain;
  late int type; // NoteType index
  String? blockchainHash;

  late int chainId;

  int? aggregatedWalletId;

  String? contentHash;

  String? author;
}
