// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'オンチェーンノート';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabNotes => 'ノート';

  @override
  String get tabProfile => 'マイページ';

  @override
  String get myNotes => 'マイノート';

  @override
  String notesCount(int count) {
    return 'ノート $count 件';
  }

  @override
  String get createNote => 'ノートを作成';

  @override
  String get selectNetwork => 'ネットワークを選択';

  @override
  String get selectNetworkSubtitle => '使用するブロックチェーンネットワークを選択してください';

  @override
  String get chainSelectorMainnetTab => 'メインネット';

  @override
  String get chainSelectorTestnetTab => 'テストネット';

  @override
  String get chainSelectorFooterHint =>
      'ネットワークを切り替えると、ノートは対応するブロックチェーン上に保存されます。';

  @override
  String get chainSelectorTestnetNoticeTitle => 'テストネットについて';

  @override
  String get chainSelectorTestnetNoticeBody =>
      'テストネットは開発・検証用です。トークンに実体価値はありません。';

  @override
  String get chainSelectorAllChainsTitle => 'すべてのチェーン';

  @override
  String get chainSelectorAllChainsSubtitle => 'すべてのチェーンのノートを表示';

  @override
  String chainSelectorChainIdLabel(int chainId) {
    return 'チェーン ID: $chainId';
  }

  @override
  String get chainSelectorCurrentBadge => '現在';

  @override
  String chainSelectorGasLabel(String cost) {
    return 'Gas: $cost';
  }

  @override
  String get chainGasCostLevelMedium => '標準';

  @override
  String get chainSelectorTestnetChainWarning => 'テストネット · 実価値なし';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get aboutUs => 'アプリについて';

  @override
  String get aboutPageTagline => '永久保存 · 改ざん不可 · 完全にあなたの手に';

  @override
  String splashVersionLabel(String version) {
    return 'バージョン $version';
  }

  @override
  String get aboutPageVersionSection => 'バージョン情報';

  @override
  String get aboutPageCurrentVersion => '現在のバージョン';

  @override
  String get photosPermissionDeniedSnack =>
      'フォトライブラリへのアクセスが必要です。設定で有効にしてから再試行してください。';

  @override
  String get pressBackAgainToExitApp => 'もう一度押すと終了します';

  @override
  String noteEditorOnChainTypeConfirmedSnack(String publishAction) {
    return 'チェーン上の保存を確認しました。ノートを保存するか「$publishAction」をタップして続行してください。';
  }

  @override
  String get actionShow => '表示';

  @override
  String get actionHide => '非表示';

  @override
  String get actionSaveToFile => 'ファイルに保存';

  @override
  String get mnemonicExportSecurityConfirmTitle => '安全確認';

  @override
  String get mnemonicExportAckSaved => 'リカバリーフレーズを安全な場所に保管しました';

  @override
  String get mnemonicExportAckUnderstandLoss =>
      'リカバリーフレーズを紛失するとノートアカウントを復元できないことを理解しています';

  @override
  String get mnemonicExportAckNoShare => 'リカバリーフレーズを誰にも共有しないことを約束します';

  @override
  String get mnemonicExportSafetyTipsTitle => '安全のヒント';

  @override
  String get mnemonicExportSafetyTipPaper => 'リカバリーフレーズを紙に書き、安全な場所に保管してください';

  @override
  String get mnemonicExportSafetyTipNoScreenshot =>
      'スクリーンショットやインターネット接続デバイスへの保存は避けてください';

  @override
  String get mnemonicExportSafetyTipCheckBackup => '定期的にバックアップが正しいか確認してください';

  @override
  String get mnemonicExportFinishCta => '安全にバックアップしました';

  @override
  String get aboutPageReleaseDate => 'リリース日';

  @override
  String get aboutPageBuildNumber => 'ビルド番号';

  @override
  String get aboutPageCoreFeatures => '主な特徴';

  @override
  String get aboutFeatureOnChainTitle => 'オンチェーン保存';

  @override
  String get aboutFeatureOnChainDesc => 'SHA-256 ハッシュをオンチェーンに。恒久的に改ざん不可。';

  @override
  String get aboutFeatureSecureTitle => 'データの安全';

  @override
  String get aboutFeatureSecureDesc => 'エンドツーエンド暗号化。鍵はあなたが管理。';

  @override
  String get aboutFeatureSyncTitle => '即時同期';

  @override
  String get aboutFeatureSyncDesc => '複数端末でリアルタイム同期。どこからでもアクセス。';

  @override
  String get aboutFeatureControlTitle => '完全なコントロール';

  @override
  String get aboutFeatureControlDesc => '分散型アーキテクチャ。データはあなたのもの。';

  @override
  String get aboutPageTechStack => '技術スタック';

  @override
  String get aboutPageContactUs => 'お問い合わせ';

  @override
  String get aboutPageOfficialWebsite => '公式サイト';

  @override
  String get aboutPageContactEmail => '連絡先メール';

  @override
  String get aboutPageOpenSource => 'オープンソース';

  @override
  String get aboutPageCreditsMadeWith => 'Made with ';

  @override
  String aboutPageCopyrightNotice(String yearBrand) {
    return '© $yearBrand。無断複写・転載を禁じます。';
  }

  @override
  String get walletManagement => 'ノートアカウント管理';

  @override
  String get walletCannotDeleteSwitchFirst =>
      '使用中のノートアカウントは削除できません。先に別のノートアカウントに切り替えてください。';

  @override
  String get walletViewMnemonicCompleteBackupFirst =>
      'リカバリーフレーズまたはセキュリティキーを表示する前に、リカバリーフレーズのバックアップ手順を完了してください。';

  @override
  String get walletDemoPrimaryName => 'メインノートアカウント';

  @override
  String get walletAddressListTitle => 'ノートアカウントアドレス一覧';

  @override
  String get copyAddressButton => 'アドレスをコピー';

  @override
  String get labelCopied => 'コピー済み';

  @override
  String get walletManagementDeleteIrreversible =>
      'この操作は取り消せません。リカバリーフレーズまたはセキュリティキーをバックアップ済みか確認してください。';

  @override
  String get walletManagementDeleteWarningTitle => '警告：削除後は復元できません';

  @override
  String get walletManagementDeleteAssetsLoss =>
      'リカバリーフレーズまたはセキュリティキーを保管していない場合、ノートへアクセスできなくなる可能性があります。';

  @override
  String get walletCreateSystemDescription =>
      '新しいノートアカウントアドレスとリカバリーフレーズが生成されます';

  @override
  String get walletCreateBackupReminderBody =>
      '作成後すぐにリカバリーフレーズをバックアップしてください。ノートアカウントを復元できるのはこれだけです。';

  @override
  String get walletCreateGenerateSubtitle => '新しいノートアカウントを生成';

  @override
  String get walletAddressCopied => 'アドレスをコピーしました';

  @override
  String get walletNameRequired => 'ノートアカウント名を入力してください';

  @override
  String get walletNameUpdated => 'ノートアカウント名を更新しました';

  @override
  String get walletKeepAtLeastOne => 'ノートアカウントは1つ以上保持してください';

  @override
  String get walletCannotDeleteCurrent => '使用中のノートアカウントは削除できません';

  @override
  String get walletDeleted => 'ノートアカウントを削除しました';

  @override
  String get walletCreated => 'ノートアカウントを作成しました';

  @override
  String get walletImportMnemonicOrKeyRequired => 'シードフレーズまたはセキュリティキーを入力してください';

  @override
  String get walletImportSuccess => 'ノートアカウントを復元しました';

  @override
  String get walletImportedCannotViewMnemonic => '復元したノートアカウントのシードフレーズは表示できません';

  @override
  String get walletMarkedBackedUp => 'バックアップ済みとしてマークしました';

  @override
  String get walletSwitched => 'ノートアカウントを切り替えました';

  @override
  String get viewMnemonic => 'シードフレーズを表示';

  @override
  String get viewPrivateKey => 'セキュリティキーを表示';

  @override
  String get privateKeyExportSelectNetworkHint => '表示するネットワークを選択';

  @override
  String get privateKeyExportKeepKeySafeHint => 'セキュリティキーは安全に保管してください';

  @override
  String get privateKeyExportSecurityWarningTitle => 'セキュリティ警告';

  @override
  String get privateKeyExportWarnBullet1 => 'セキュリティキーはノートを管理する最高権限の認証情報です';

  @override
  String get privateKeyExportWarnBullet2 => 'セキュリティキーを入手した者はノートを完全に管理できます';

  @override
  String get privateKeyExportWarnBullet3 => '周囲が安全で、誰も見ていないことを確認してください';

  @override
  String get privateKeyExportWarnBullet4 => 'スクリーンショット・撮影・ネットワーク送信は絶対にしないでください';

  @override
  String get privateKeyExportSupportedNetworksTitle => '対応ネットワーク';

  @override
  String privateKeyExportNetworkCount(int count) {
    return '$count ネットワーク';
  }

  @override
  String get privateKeyExportViewSafetyTitle => 'セキュリティキーの安全ヒント';

  @override
  String get privateKeyExportViewBullet1 => '周囲が安全で、画面を覗き見されていないことを確認してください';

  @override
  String get privateKeyExportViewBullet2 => '公共の場所や信頼できないネットワークでは表示しないでください';

  @override
  String get privateKeyExportViewBullet3 => '確認が終わったらできるだけ早くこのページを閉じてください';

  @override
  String get privateKeyExportKeySectionTitle => 'セキュリティキー';

  @override
  String get privateKeyExportBip44Hint =>
      'BIP44 イーサリアムパスで派生したセキュリティキーは EVM 各メインネットで同一です。ネットワーク名のみ異なります。';

  @override
  String get privateKeyExportMaskedPlaceholder =>
      '0x•••••••••••••••••••••••••••••••••';

  @override
  String get privateKeyExportDoNotShareInline =>
      'セキュリティキーを誰にも教えたり、ネットワークで送信したりしないでください';

  @override
  String privateKeyExportNetworkAddressLabel(String networkName) {
    return '$networkName ネットワークアドレス';
  }

  @override
  String get privateKeyExportImportantReminderTitle => '重要なお知らせ';

  @override
  String get privateKeyExportReminderBullet1 =>
      'セキュリティキーを持つ = そのアドレスのノートを完全に管理できる';

  @override
  String get privateKeyExportReminderBullet2 => '漏洩するとノートは永久に失われ、復元できません';

  @override
  String get privateKeyExportReminderBullet3 => '公式チームがセキュリティキーの提供を求めることはありません';

  @override
  String get privateKeyExportReminderBullet4 =>
      'セキュリティキーのエクスポートよりリカバリーフレーズでのバックアップを推奨します';

  @override
  String get privateKeyExportBackToList => '一覧に戻る';

  @override
  String get privateKeyExportCopySecurityKey => 'セキュリティキーをコピー';

  @override
  String get mnemonicManagePageTitle => 'シードフレーズ';

  @override
  String get mnemonicManagePageSubtitle => 'シードフレーズは安全に保管し、他人に見せないでください';

  @override
  String get mnemonicBackupFlowTitle => 'シードフレーズをバックアップ';

  @override
  String mnemonicBackupFlowStepProgress(int step, int total) {
    return 'ステップ $step / $total';
  }

  @override
  String get mnemonicBackupFlowLoadFailed => '読み込みに失敗しました';

  @override
  String get mnemonicBackupFlowCTAUnderstoodStart => '理解しました。バックアップを開始';

  @override
  String get mnemonicBackupFlowCTACopiedContinue => '書き写しました。検証へ';

  @override
  String get mnemonicBackupFlowCTAVerifiedContinue => '検証済み。続行';

  @override
  String get mnemonicBackupFlowCTAPleaseVerify => '先に検証を完了してください';

  @override
  String get mnemonicBackupFlowCTAFinish => 'バックアップを完了';

  @override
  String get mnemonicBackupFlowCTANext => '次へ';

  @override
  String get mnemonicBackupFlowFooterCopyHint => 'すべての単語を正しく書き写してから続行してください';

  @override
  String get mnemonicBackupFlowStep1Heading => '開始する前に';

  @override
  String get mnemonicBackupFlowStep1Subheading => '次のセキュリティ上の注意をよくお読みください';

  @override
  String get mnemonicBackupFlowSecurityTipsTitle => '重要な注意事項';

  @override
  String get mnemonicBackupFlowSecurityTip1 => 'シードフレーズはこのノートアカウントを復元する唯一の方法です';

  @override
  String get mnemonicBackupFlowSecurityTip2 =>
      'リカバリーフレーズを知られると、ノートを管理される可能性があります';

  @override
  String get mnemonicBackupFlowSecurityTip3 =>
      'シードフレーズを紛失すると、ノートアカウントは二度と復元できません';

  @override
  String get mnemonicBackupFlowBackupAdviceTitle => '安全なバックアップのしかた';

  @override
  String get mnemonicBackupFlowBackupAdvice1 => '紙に書き、安全な場所に保管してください';

  @override
  String get mnemonicBackupFlowBackupAdvice2 => 'スクリーンショットやネット接続端末への保存は避けてください';

  @override
  String get mnemonicBackupFlowBackupAdvice3 => 'ネット越しに送信したり、誰かと共有したりしないでください';

  @override
  String get mnemonicBackupFlowBackupAdvice4 => '複数箇所に分散して保管することをおすすめします';

  @override
  String get mnemonicBackupFlowProcessTitle => 'バックアップの流れ';

  @override
  String get mnemonicBackupFlowProcess1 => 'シードフレーズを確認し、書き写す';

  @override
  String get mnemonicBackupFlowProcess2 => '検証でバックアップが正しいことを確認する';

  @override
  String get mnemonicBackupFlowProcess3 => 'バックアップを完了し、ノートを守る';

  @override
  String get mnemonicBackupFlowYourMnemonicTitle => 'あなたのシードフレーズ';

  @override
  String get mnemonicBackupFlowYourMnemonicSubtitle => '順番どおりに書き写し、大切に保管してください';

  @override
  String mnemonicBackupFlowWordCount(int count) {
    return '$count 語';
  }

  @override
  String get mnemonicBackupFlowPleaseNoteTitle => 'ご注意';

  @override
  String get mnemonicBackupFlowStep2NoteBody =>
      'スクリーンショットやコピーではなく、紙への書き写しをおすすめします。目のアイコンで表示・非表示を切り替えられます。';

  @override
  String get mnemonicBackupFlowVerifyTitle => 'シードフレーズの確認';

  @override
  String get mnemonicBackupFlowVerifySubtitle =>
      '正しい単語を選び、バックアップが合っていることを確認してください';

  @override
  String mnemonicBackupFlowVerifyWordQuestion(int position) {
    return '$position 番目の単語はどれですか？';
  }

  @override
  String get mnemonicBackupFlowVerifySuccessTitle => '検証に成功しました';

  @override
  String get mnemonicBackupFlowVerifySuccessBody => 'シードフレーズを正しくバックアップできました';

  @override
  String get mnemonicBackupFlowDoneTitle => 'バックアップ完了';

  @override
  String get mnemonicBackupFlowDoneSubtitle => 'シードフレーズは安全にバックアップされています';

  @override
  String get mnemonicBackupFlowDoneSectionTitle => '完了した項目';

  @override
  String get mnemonicBackupFlowDoneCheck1 => 'シードフレーズを確認して書き写した';

  @override
  String get mnemonicBackupFlowDoneCheck2 => '検証テストに合格した';

  @override
  String get mnemonicBackupFlowDoneCheck3 => 'シードフレーズを安全に保管した';

  @override
  String get mnemonicBackupFlowDoneSecurityTitle => 'セキュリティのリマインダー';

  @override
  String get mnemonicBackupFlowDoneSecurity1 => 'シードフレーズは安全な物理的な場所に保管してください';

  @override
  String get mnemonicBackupFlowDoneSecurity2 => '誰にもシードフレーズを開示しないでください';

  @override
  String get mnemonicBackupFlowDoneSecurity3 => '公式がシードフレーズを求めることはありません';

  @override
  String get mnemonicBackupFlowDoneSecurity4 => '定期的にバックアップが読めるか確認してください';

  @override
  String get mnemonicBackupFlowFinalEncouragementTitle =>
      'ノートアカウントを安心してお使いいただけます';

  @override
  String get mnemonicBackupFlowFinalEncouragementBody =>
      'あなたのノートはリカバリーフレーズによって保護されています';

  @override
  String get switchWallet => '切り替え';

  @override
  String get viewAddresses => 'アドレスを表示';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String get createWallet => 'ノートアカウントを作成';

  @override
  String get importWallet => 'ノートアカウントを復元';

  @override
  String get mnemonicOrPrivateKey => 'シードフレーズまたはセキュリティキー';

  @override
  String get close => '閉じる';

  @override
  String get copy => 'コピー';

  @override
  String get mnemonicCopied => 'シードフレーズをコピーしました';

  @override
  String get privateKeyCopied => 'セキュリティキーをコピーしました';

  @override
  String get backedUp => 'バックアップ済み';

  @override
  String get editWalletName => 'ノートアカウント名を編集';

  @override
  String get deleteWallet => 'ノートアカウントを削除';

  @override
  String get confirmDeleteWallet => 'ノートアカウントの削除を確認';

  @override
  String get newWalletCreated => '新しいノートアカウントを作成しました';

  @override
  String get cannotDeleteCurrentWallet => '使用中のノートアカウントは削除できません';

  @override
  String get edit => '編集';

  @override
  String get createNewWallet => '新しいノートアカウントを作成';

  @override
  String get editWalletNameTitle => 'ノートアカウント名を変更';

  @override
  String get noteNotFoundBack => 'ノートが見つかりません。戻ってください';

  @override
  String get createNoteNotImplemented => 'ノート作成（未実装）';

  @override
  String get newWalletCreateSuccess => '新しいノートアカウントの作成に成功しました！';

  @override
  String restoringFromProvider(String provider) {
    return '$provider からノートアカウントを復元中...';
  }

  @override
  String restoredFromProvider(String provider) {
    return '$provider からノートアカウントを復元しました！';
  }

  @override
  String noBackupFoundProvider(String provider) {
    return '$provider のバックアップが見つかりません。別の方法をお試しください';
  }

  @override
  String get walletAddressCopiedShort => 'ノートアカウントアドレスをコピーしました';

  @override
  String switchedToChain(String chain) {
    return '$chain に切り替えました';
  }

  @override
  String get fillAllFields => 'すべての項目を入力してください';

  @override
  String get passwordMismatch => '新しいパスワードが一致しません';

  @override
  String get passwordMinLength => 'パスワードは6文字以上にしてください';

  @override
  String get passwordChangeSuccess => 'パスワードを変更しました';

  @override
  String get enterValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get verificationCodeSent => '認証コードを送信しました';

  @override
  String get enterSixDigitCode => '6桁の認証コードを入力してください';

  @override
  String get emailBindSuccess => 'メールを紐付けました';

  @override
  String get emailUnbound => 'メールの紐付けを解除しました';

  @override
  String get logoutNotConnected => 'ログアウト（未接続）';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get confirm => '確認';

  @override
  String get bindEmail => 'メールを紐付け';

  @override
  String get editNoteOpenByRoute => 'ルートから編集ページを開いてください';

  @override
  String get imageUploadNotConnected => '画像アップロードはストレージ未接続です';

  @override
  String get imageRemoved => '画像を削除しました';

  @override
  String get titleContentRequired => 'タイトルと内容を入力してください';

  @override
  String get submittedToChain => 'チェーンに送信しました';

  @override
  String get onChainNoteCannotChangeType => 'オンチェーンのノートは種類を変更できません';

  @override
  String get setToLocalNote => 'ローカルノートに設定しました（チェーンに載りません）';

  @override
  String get setToDraft => '下書きに設定しました';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get noteDetailEditDisabledOnChain => 'オンチェーンのノートは編集できません';

  @override
  String get noteTypeDraft => '下書き';

  @override
  String get noteTypeLocal => 'ローカル';

  @override
  String get noteTypeOnChain => 'オンチェーン';

  @override
  String get blockchainVerify => 'ブロックチェーンで検証';

  @override
  String get blockchainVerifyTitle => 'ブロックチェーン検証';

  @override
  String getGas(String symbol) {
    return '$symbol のガスを取得';
  }

  @override
  String get addressCopied => 'アドレスをコピーしました';

  @override
  String get redirectingToFaucet => 'フォーセットサイトに移動します...';

  @override
  String get noFaucetForNetwork => 'このネットワークにはフォーセットがありません';

  @override
  String get loginNotImplemented => 'ログイン機能は未実装です';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get forgotPasswordNotImplemented => 'パスワード再設定は未実装です';

  @override
  String get noAccountYet => 'ノートアカウントをお持ちでないですか？';

  @override
  String get registerNotImplemented => '登録機能は未実装です';

  @override
  String get registerNow => '今すぐ登録';

  @override
  String get mnemonicVerifySuccess => 'シードフレーズの検証に成功しました。復元は外部で処理されます';

  @override
  String get privateKeyVerifySuccess => 'セキュリティキーの検証に成功しました。復元は外部で処理されます';

  @override
  String get importSuccess => '復元に成功しました！';

  @override
  String get cleared => 'クリアしました';

  @override
  String get back => '戻る';

  @override
  String get current => '現在';

  @override
  String get imported => '復元済み';

  @override
  String get defaultBadge => 'デフォルト';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get searchNotesHint => 'ノートを検索...';

  @override
  String get noMatchNotes => '一致するノートがありません';

  @override
  String get noOnChainNotes => 'オンチェーンのノートはまだありません';

  @override
  String get noOffChainNotes => 'オフチェーンのノートはまだありません';

  @override
  String get noNotes => 'ノートはまだありません';

  @override
  String get tryOtherSearch => '別のキーワードをお試しください';

  @override
  String get startCreateFirstNote => '最初のノートを作成しましょう';

  @override
  String get profileNotConnected => '未接続';

  @override
  String get profileSectionAccount => 'ノートアカウント';

  @override
  String get profileNetworkSettingsSubtitle => 'RPC とノードの設定';

  @override
  String get profileSectionSecurity => 'セキュリティ';

  @override
  String get profileChangePasswordSubtitle => 'ノートアカウントを保護';

  @override
  String get profileBindEmailNotBound => '未連携';

  @override
  String get profileBindEmailBadgeBound => '連携済み';

  @override
  String get profileSectionPreferences => '環境設定';

  @override
  String get profileNotifications => '通知';

  @override
  String get profileDarkMode => 'ダークモード';

  @override
  String get profileLanguage => '言語';

  @override
  String get profileSectionMore => 'その他';

  @override
  String get profileTestPage => 'テストページ';

  @override
  String get profileTestPageSubtitle => '機能テスト';

  @override
  String get profileTerms => '利用規約';

  @override
  String get profilePrivacy => 'プライバシーポリシー';

  @override
  String get profileRateUs => '評価する';

  @override
  String get profileShare => '友達に共有';

  @override
  String profileShareMessage(String url) {
    return 'オンチェーンノートアプリを使っています。ぜひ試してください：\n$url';
  }

  @override
  String get profileLogoutLabel => 'ログアウト';

  @override
  String get profileLogoutPending => 'ログアウト（準備中）';

  @override
  String profilePageFooter(String appTitle, String version, String year) {
    return '$appTitle v$version\n© $year 無断転載を禁じます。';
  }

  @override
  String get profileAvatarFallback => 'ME';

  @override
  String get profileDefaultWalletName => 'マイノートアカウント';

  @override
  String get profileUserActive => 'アクティブユーザー';

  @override
  String get profileUserNormal => '一般ユーザー';

  @override
  String get profileStatNotes => 'ノート数';

  @override
  String get profileStatOnChain => 'オンチェーン';

  @override
  String get profileStatDays => '日数';

  @override
  String get profileBindEmailDialogSubtitle => 'メールアドレスと認証コードを入力してください。';

  @override
  String get profileBindEmailFieldEmail => 'メールアドレス';

  @override
  String get profileBindEmailFieldCode => '認証コード';

  @override
  String get profileSendVerificationCode => 'コードを送信';

  @override
  String profileResendCodeInSeconds(int seconds) {
    return '再送信まで $seconds 秒';
  }

  @override
  String get profileUnbindEmail => 'メール連携を解除';

  @override
  String get languageSelectTitle => '言語';

  @override
  String get languageSelectSubtitle => '表示言語を選択';

  @override
  String get languageNoticeHint => '注：';

  @override
  String get languageNoticeBody => '簡体中国語・繁体中国語・英語・日本語・韓国語に対応。その他の言語は順次対応予定です。';

  @override
  String get languageCurrentBadge => '現在';

  @override
  String get languageSnackbarComingSoon => '近日公開';

  @override
  String languageSwitchedTo(String name) {
    return '$name に切り替えました';
  }

  @override
  String get languageFooterMore => 'さらに多くの言語に対応予定';

  @override
  String get changePasswordSameAsOld => '新しいパスワードは現在のパスワードと同じにできません';

  @override
  String get changePasswordLength632 => '新しいパスワードは 6〜32 文字にしてください';

  @override
  String get walletNoSavedKey => '保存された鍵が見つかりません。先にノートアカウントを作成してください';

  @override
  String get changePasswordWrongOrFailed => '現在のパスワードが違うか、操作に失敗しました';

  @override
  String get passwordMaxLength32 => 'パスワードは最大 32 文字です';

  @override
  String get passwordMeetAllRequirements => 'すべてのパスワード要件を満たしてください';

  @override
  String encryptionInitFailed(String error) {
    return '暗号化の初期化に失敗しました：$error';
  }

  @override
  String get passwordVerifyForgotGoReset => 'パスワードをお忘れですか？リセット';

  @override
  String get passwordStrengthWeak => '弱い';

  @override
  String get passwordStrengthMedium => '普通';

  @override
  String get passwordStrengthStrong => '強い';

  @override
  String get changePasswordPageTitle => 'パスワード変更';

  @override
  String get changePasswordPageSubtitle => 'ノートアカウントを保護';

  @override
  String get changePasswordSecurityHintTitle => 'セキュリティのヒント';

  @override
  String get changePasswordSecurityHintBody =>
      '• 定期的にパスワードを変更しましょう\n• 英字・数字を含む強いパスワードを使いましょう\n• 誕生日や電話番号は避けましょう';

  @override
  String get changePasswordOldLabel => '現在のパスワード';

  @override
  String get changePasswordOldHint => '現在のパスワードを入力';

  @override
  String get changePasswordNewLabel => '新しいパスワード';

  @override
  String get changePasswordNewHint => '新しいパスワードを入力';

  @override
  String get changePasswordStrengthLabel => 'パスワード強度：';

  @override
  String get changePasswordMatchOk => '一致しています';

  @override
  String get changePasswordMatchBad => '一致しません';

  @override
  String get changePasswordConfirmLabel => '新しいパスワード（確認）';

  @override
  String get changePasswordConfirmHint => 'もう一度入力';

  @override
  String get changePasswordRuleLength => '6〜32 文字';

  @override
  String get changePasswordRuleCase => '大文字と小文字を含む';

  @override
  String get changePasswordRuleDigit => '数字を含む';

  @override
  String get changePasswordClear => 'クリア';

  @override
  String get changePasswordSubmit => '変更を確定';

  @override
  String get validatorOldPasswordRequired => '現在のパスワードを入力してください';

  @override
  String get validatorNewPasswordRequired => '新しいパスワードを入力してください';

  @override
  String get validatorNewPasswordMin6 => '6 文字以上';

  @override
  String get validatorNewPasswordMax32 => '32 文字まで';

  @override
  String get validatorConfirmRequired => '確認用パスワードを入力してください';

  @override
  String get validatorConfirmMismatch => '入力が一致しません';

  @override
  String get changePasswordRulesTitle => 'パスワード要件';

  @override
  String get loginWelcomeTitle => 'おかえりなさい';

  @override
  String get loginSubtitle => 'ノートアカウントにサインイン';

  @override
  String get loginEmailOrUsernameLabel => 'メールまたはユーザー名';

  @override
  String get loginEmailOrUsernameHint => 'メールまたはユーザー名を入力';

  @override
  String get validatorLoginIdRequired => 'メールまたはユーザー名を入力してください';

  @override
  String get loginPasswordFieldLabel => 'パスワード';

  @override
  String get loginPasswordFieldHint => 'パスワードを入力';

  @override
  String get validatorLoginPasswordRequired => 'パスワードを入力してください';

  @override
  String get validatorLoginPasswordMin6 => 'パスワードは6文字以上';

  @override
  String get loginButton => 'サインイン';

  @override
  String get createWalletPasswordPageTitle => 'ノートノートアカウントパスワードを設定';

  @override
  String get createWalletPasswordSubtitle => 'ノートを安全に保護';

  @override
  String get createWalletPasswordWhyTitle => 'パスワードが必要な理由';

  @override
  String get createWalletPasswordWhyBody =>
      'ノートアカウントパスワードでセキュリティキーとリカバリーフレーズを暗号化し、本人だけがノートにアクセスできます。紛失すると復元できないため必ず覚えてください。';

  @override
  String get walletPasswordFieldLabel => 'ノートノートアカウントパスワード';

  @override
  String get walletPasswordFieldHint => '6〜32 文字を入力';

  @override
  String get walletConfirmPasswordFieldLabel => 'パスワード確認';

  @override
  String get walletConfirmPasswordFieldHint => 'もう一度入力';

  @override
  String get walletPasswordImportantNotice => '重要';

  @override
  String get walletPasswordWarnBullets =>
      '• パスワードはノートアカウントを保護します\n• 覚えやすく推測しにくいものを\n• 英数字と記号を混ぜることを推奨\n• 紛失すると復元不可です';

  @override
  String get createWalletPasswordSubmitCreate => '確定してノートアカウントを作成';

  @override
  String get createWalletPasswordSubmitReset => '確定してパスワードをリセット';

  @override
  String get createWalletPasswordFooterAck => '確定することでパスワードの重要性に同意したことになります';

  @override
  String get walletPasswordRulesHeader => '要件：';

  @override
  String get walletPasswordRuleLength632 => '6〜32 文字';

  @override
  String get walletPasswordRuleLetter => '英字を含む';

  @override
  String get walletPasswordRuleNumberRecommended => '数字を含む（推奨）';

  @override
  String get walletPasswordRuleMatch => '2回の入力が一致';

  @override
  String get walletBootstrapImporting => 'ノートアカウントを復元中...';

  @override
  String get walletBootstrapInitializing => 'ノートアカウントを初期化中...';

  @override
  String get passwordVerifyTitle => 'パスワード確認';

  @override
  String get passwordVerifyDescription => '安全のため、ノートノートアカウントパスワードを入力してください';

  @override
  String get passwordVerifyDescExportMnemonic =>
      'リカバリーフレーズを表示・エクスポートする前にノートノートアカウントパスワードを入力してください';

  @override
  String get passwordVerifyDescExportPrivateKey =>
      'セキュリティキーを表示する前にノートノートアカウントパスワードを入力してください';

  @override
  String get passwordVerifyDescImportWallet => 'ノートアカウントを復元する前にパスワードを確認してください';

  @override
  String get passwordVerifyDescBackupMnemonic =>
      'リカバリーフレーズをバックアップする前にノートノートアカウントパスワードを入力してください';

  @override
  String get passwordVerifyDescCreateWallet => 'ノートアカウントを作成する前にパスワードを確認してください';

  @override
  String get passwordVerifyDescDeleteWallet => 'ノートアカウントを削除する前にパスワードを確認してください';

  @override
  String get passwordVerifyDescMintNft => 'NFT をミントするにはノートノートアカウントパスワードが必要です';

  @override
  String get passwordVerifyWalletPasswordLabel => 'ノートノートアカウントパスワード';

  @override
  String get passwordVerifyWalletPasswordHint => 'ノートノートアカウントパスワードを入力';

  @override
  String get validatorWalletPasswordRequired => 'パスワードを入力してください';

  @override
  String get passwordVerifyNoEncryptedData => '暗号データが見つかりません。パスワードを設定し直してください';

  @override
  String passwordVerifyFailedWithError(String error) {
    return '検証に失敗しました：$error';
  }

  @override
  String passwordVerifyLockoutMinutes(int minutes) {
    return '試行回数が多すぎます。$minutes 分後に再試行してください';
  }

  @override
  String passwordVerifyLockoutHours(int hours) {
    return '試行回数が多すぎます。$hours 時間後に再試行してください';
  }

  @override
  String passwordVerifyWrongWithCount(int current, int max) {
    return 'パスワードが違います（$current/$max）';
  }

  @override
  String passwordVerifyAttemptsBanner(int count, int remaining) {
    return '誤り $count 回。残り $remaining 回';
  }

  @override
  String passwordVerifyLockBanner(String time) {
    return '試行回数が多すぎます。$time 後に再試行してください';
  }

  @override
  String passwordVerifyDurationHoursMinutes(int hours, int minutes) {
    return '$hours 時間 $minutes 分';
  }

  @override
  String passwordVerifyDurationMinutes(int minutes) {
    return '$minutes 分';
  }

  @override
  String get passwordVerifySecurityTipsTitle => 'セキュリティのヒント';

  @override
  String passwordVerifySecurityTipsBody(int maxAttempts) {
    return '• パスワードは 6〜32 文字\n• 周囲の安全を確認\n• $maxAttempts 回誤ると一時ロック';
  }

  @override
  String get paste => '貼り付け';

  @override
  String get loadingDefault => '読み込み中…';

  @override
  String get walletLoadingTagline => 'BlockNote · 安全 · 信頼 · 永続';

  @override
  String get walletLoadingStepConnecting => 'ネットワークに接続しています…';

  @override
  String get walletLoadingStepVerifying => 'ノートアカウントを確認しています…';

  @override
  String get walletLoadingStepSyncing => 'ノートを同期しています…';

  @override
  String get walletLoadingStepComplete => 'まもなく完了します';

  @override
  String get retry => '再試行';

  @override
  String loadFailedWithError(String error) {
    return '読み込みに失敗しました：$error';
  }

  @override
  String get selectEvmChainFirst => 'まず EVM 対応ネットワークを選択してください';

  @override
  String get noteNotFoundShort => 'ノートが見つかりません';

  @override
  String get createOrSelectWalletFirst => 'ノートアカウントを作成または選択してください';

  @override
  String get privateKeyDecryptFailedHint =>
      'セキュリティキーを取得できません。パスワードを確認してください。変更した場合はリカバリーフレーズを再復元してください';

  @override
  String get uploadingIpfsAndMinting => 'IPFS にアップロードしてミント中…';

  @override
  String ipfsFileUploadFailed(String details) {
    return 'IPFS ファイルのアップロードに失敗しました：$details';
  }

  @override
  String onChainSuccessTx(String txHash) {
    return 'チェーン登録成功：$txHash';
  }

  @override
  String get draftSavedIpfsRetry => '下書きとして保存し、IPFS 画像に置き換えました。後で再試行できます';

  @override
  String mintFailedGasDebug(String detail) {
    return '残高不足（Gas）\n$detail';
  }

  @override
  String get mintFailedGasUser => 'Gas 支払いのための残高が不足しています。入金してから再試行してください';

  @override
  String mintFailedGeneric(String error) {
    return '公開に失敗しました：$error';
  }

  @override
  String get walletErrNoWalletYet => '先にノートアカウントを作成または復元してください';

  @override
  String get walletErrUnrecognizedAccount => '現在のノートアカウントを認識できません';

  @override
  String get walletErrWalletDataNotFound => 'ノートアカウントデータが見つかりません';

  @override
  String get walletErrImportedMnemonicNoExport =>
      'リカバリーフレーズ復元のノートアカウントはここで再度エクスポートできません';

  @override
  String get walletErrImportedMnemonicNoBackup =>
      'リカバリーフレーズ復元のノートアカウントはここでバックアップ不要です';

  @override
  String get walletErrPrivateKeyWalletNoMnemonic =>
      'セキュリティキー復元のノートアカウントにリカバリーフレーズはありません';

  @override
  String get walletErrNoEncryptedMnemonic =>
      'このノートアカウントにローカル暗号化リカバリーフレーズがありません';

  @override
  String get walletErrDecryptFailed => '復号に失敗しました。パスワードを確認してください';

  @override
  String get walletErrMissingAddress => 'ノートアカウントアドレスがありません';

  @override
  String get walletErrGetPrivateKeyFailed => 'セキュリティキーを取得できません。パスワードを確認してください';

  @override
  String get exportMnemonicDocTitle => 'オンチェーンノート — リカバリーフレーズバックアップ';

  @override
  String exportMnemonicDocTime(String time) {
    return '生成日時：$time';
  }

  @override
  String get exportMnemonicDocLabel => 'リカバリーフレーズ（厳重に保管）：';

  @override
  String get exportMnemonicDocSecurity =>
      '⚠️ セキュリティの注意：\n1. 安全な場所に保管してください\n2. 誰とも共有しないでください\n3. 紛失すると復元できません';

  @override
  String get exportMnemonicUseCopyOnPlatform => 'このプラットフォームではコピーをご利用ください';

  @override
  String exportMnemonicSavedTo(String path) {
    return '保存しました：$path';
  }

  @override
  String get walletBootstrapCreating => 'ノートアカウント作成中…';

  @override
  String get chainNameEvm => 'EVM（Ethereum / BSC / Polygon など）';

  @override
  String get chainPkDescEvm => '0x 付き 64 桁の 16 進数、合計 66 文字';

  @override
  String get chainNameBitcoin => 'Bitcoin';

  @override
  String get chainPkDescBitcoin => 'WIF 形式、5・K・L で始まり 51〜52 文字';

  @override
  String get chainNameSolana => 'Solana';

  @override
  String get chainPkDescSolana => 'Base58、おおよそ 87〜88 文字、0・O・I・l を含まない';

  @override
  String get chainNameTron => 'Tron';

  @override
  String get chainPkDescTronHex => '64 桁の 16 進数（0x なし）';

  @override
  String get chainNameCosmos => 'Cosmos';

  @override
  String get chainPkDescCosmosHex => '64 桁の 16 進数（0x なし）';

  @override
  String walletPkSubtitleLength(int count) {
    return '$count 文字';
  }

  @override
  String walletPkSubtitleStartsWith(String prefix) {
    return '$prefix で始まる';
  }

  @override
  String get walletImportSelectChainTitle => 'ブロックチェーン種別を選択';

  @override
  String get walletImportEvmOnlyNotice => '未対応です。EVM セキュリティキー復元をご利用ください';

  @override
  String get walletImportPageSubtitle => 'リカバリーフレーズまたはセキュリティキーでノートアカウントを復元';

  @override
  String get walletImportTabMnemonic => 'リカバリーフレーズ';

  @override
  String get walletImportTabPrivateKey => 'セキュリティキー';

  @override
  String get walletImportInputMethod => '入力方法';

  @override
  String get walletImportInputSingle => '1 語ずつ';

  @override
  String get walletImportInputPasteFull => '全文貼り付け';

  @override
  String get walletImportWordCountLabel => 'リカバリーフレーズ語数';

  @override
  String walletImportWordCountN(int n) {
    return '$n 語';
  }

  @override
  String get walletImportWordCountDialogTitle => 'ニーモニック語数を選択';

  @override
  String get walletImportWordCountDialogDesc =>
      'BIP39は複数の語数に対応。語数が多いほど安全性が高まります。';

  @override
  String walletImportWordCountOptionLabel(int count) {
    return '$count語のニーモニック';
  }

  @override
  String get walletImportWordCountSecurityLabel => 'セキュリティ：';

  @override
  String get walletImportWordCountSecurityStandard => '標準';

  @override
  String get walletImportWordCountSecurityEnhanced => '強化';

  @override
  String get walletImportWordCountSecurityAdvanced => '上級';

  @override
  String get walletImportWordCountSecurityProfessional => 'プロ';

  @override
  String get walletImportWordCountSecurityMaximum => '最高';

  @override
  String walletImportWordCountSwitched(int n) {
    return '$n語に切り替えました';
  }

  @override
  String get walletImportWordCountDialogTip =>
      '多くのウォレットは12語を使用します。不明な場合は12語を選んでください。';

  @override
  String get walletImportEnterMnemonic => 'リカバリーフレーズを入力';

  @override
  String get walletImportMnemonicPasteTip =>
      'ヒント：全文を貼り付け可能です。上の「全文貼り付け」を選択してください';

  @override
  String get walletImportPasteMnemonicPrompt => 'リカバリーフレーズを貼り付け';

  @override
  String walletImportMnemonicHintWords(int count) {
    return '$count 語をスペース区切りで貼り付け';
  }

  @override
  String get walletImportMnemonicWordFieldHint => '単語';

  @override
  String get walletImportMnemonicParagraphExampleHint =>
      'word1 word2 word3 ...';

  @override
  String get walletImportPrivateKeyFieldHint => '0x... または64文字の16進数';

  @override
  String get walletImportPrivateKeyFieldHintShort => '0x...';

  @override
  String walletImportWordProgress(int current, int total) {
    return '現在の語数：$current / $total';
  }

  @override
  String get walletImportMnemonicSecurityTitle => 'セキュリティのヒント';

  @override
  String get walletImportMnemonicSecurityBody =>
      '• 安全なネットワークで操作してください\n• リカバリーフレーズを失うと復元できません\n• 他人に決して教えないでください\n• 当社はサーバーにリカバリーフレーズを保存しません';

  @override
  String get walletImportSelectChainSection => 'ブロックチェーン種別を選択';

  @override
  String get walletImportTapSwitchChain => 'タップしてチェーンを切り替え';

  @override
  String get walletImportEnterPrivateKey => 'セキュリティキーを入力';

  @override
  String get walletImportPkFormatExample => 'セキュリティキー形式の例';

  @override
  String get walletImportPkSevereTitle => '重大な警告';

  @override
  String get walletImportPkSevereBody =>
      '• セキュリティキーはノートアカウントの完全な権限です\n• 入手された者がノートを完全に管理できます\n• 安全でない端末で入力しないでください\n• スクリーンショットやチャット送信は避けてください';

  @override
  String get walletImportConfirm => '復元を確定';

  @override
  String walletImportMnemonicNeedCount(int count) {
    return '$count 語すべて入力してください';
  }

  @override
  String walletImportMnemonicWrongCount(int count, int current) {
    return '$count 語必要です（現在 $current 語）';
  }

  @override
  String get walletImportMnemonicInvalidWords =>
      'リカバリーフレーズが無効です。小文字の英単語を使用してください';

  @override
  String get walletImportPkEmpty => 'セキュリティキーを入力してください';

  @override
  String get walletImportPkNeed0x => 'セキュリティキーは 0x で始まる必要があります';

  @override
  String get walletImportPkNeedWif => 'セキュリティキーは 5・K・L で始まる必要があります';

  @override
  String get walletImportPkWifLength => 'セキュリティキーの長さは 51〜52 文字である必要があります';

  @override
  String walletImportPkLengthExpected(int length) {
    return 'セキュリティキーの長さは $length 文字である必要があります';
  }

  @override
  String get walletImportPkInvalidFormat => 'セキュリティキーの形式が無効です';

  @override
  String get walletImportEvmOnly => 'EVM セキュリティキーの復元のみ対応しています';

  @override
  String get walletImportDeriveAddressFailed =>
      'セキュリティキーからアドレスを導出できません。形式を確認してください';

  @override
  String get walletImportDuplicatePk => 'このアドレスは既に存在します。重複復元はできません';

  @override
  String get walletImportDuplicateMnemonic => 'このリカバリーフレーズのノートアカウントは既に復元済みです';

  @override
  String get walletImportInvalidPrivateKeyRetry =>
      'セキュリティキーが無効です。確認して再試行してください';

  @override
  String get walletImportInvalidMnemonicRetry => 'リカバリーフレーズが無効です。確認して再試行してください';

  @override
  String get clipboardEmpty => 'クリップボードが空です';

  @override
  String get mnemonicViewLengthTitle => 'リカバリーフレーズ長';

  @override
  String get mnemonicViewInputMode => '入力モード';

  @override
  String get mnemonicViewSingleWord => '1 語ずつ';

  @override
  String get mnemonicViewFullPaste => '段落を貼り付け';

  @override
  String get mnemonicViewImportCta => 'リカバリーフレーズを復元';

  @override
  String mnemonicViewEnterOrdered(int count) {
    return '順番に $count 語入力してください';
  }

  @override
  String get mnemonicViewPasteHint => '全文を貼り付け、語の間はスペースで区切ってください';

  @override
  String mnemonicCountMismatch(int expected, int current) {
    return '$expected 語必要です（現在 $current 語）';
  }

  @override
  String get mnemonicInvalidBip39 => '無効なリカバリーフレーズです。綴りを確認してください';

  @override
  String get walletSelectorTitle => 'マイノートアカウント';

  @override
  String get walletSelectorSubtitle => 'すべてのノートアカウントを管理';

  @override
  String walletNumberedName(int n) {
    return 'ノートアカウント $n';
  }

  @override
  String get walletDefaultCreatedNameFirst => 'マイノートアカウント';

  @override
  String walletDefaultCreatedNameNumbered(int n) {
    return 'マイノートアカウント $n';
  }

  @override
  String get walletDefaultPrivateKeyNameFirst => 'セキュリティキーノートアカウント';

  @override
  String walletDefaultPrivateKeyNameNumbered(int n) {
    return 'セキュリティキーノートアカウント $n';
  }

  @override
  String get walletBackupNotYet => '未バックアップ';

  @override
  String get walletBackupPromptLine1 => 'ノートアカウントをバックアップ';

  @override
  String get walletBackupPromptLine2 => 'タップして今すぐリカバリーフレーズをバックアップ';

  @override
  String get walletDeleteConfirmTitle => 'ノートアカウントを削除しますか？';

  @override
  String get walletDeleteConfirmLine1 => '元に戻せません。リカバリーフレーズをバックアップ済みか確認してください。';

  @override
  String get walletDeleteConfirmLine2Notes => 'このノートアカウントに紐づくローカルノートも削除されます。';

  @override
  String get walletDeleteCannotCurrent => '⚠️ 使用中のノートアカウントは削除できません';

  @override
  String get walletDeleteLastHint => '削除後ノートアカウントがなくなり、オンボーディングに戻ります。';

  @override
  String get walletEditNameSubtitle => 'わかりやすい名前を設定';

  @override
  String get walletNameFieldLabel => 'ノートアカウント名';

  @override
  String get walletNameFieldHint => 'ノートアカウント名を入力';

  @override
  String get networkNodeAdd => 'ノードを追加';

  @override
  String get networkNodeTest => 'テスト';

  @override
  String get networkNodeSetDefault => 'デフォルトに設定';

  @override
  String get networkNodeOnline => 'オンライン';

  @override
  String get networkNodeOffline => 'オフライン';

  @override
  String get networkNodeConnectionFailed => 'ノード接続に失敗しました';

  @override
  String get networkRpcUrlInvalid => '有効な HTTP または HTTPS の RPC URL を入力してください。';

  @override
  String get networkNodeDuplicate => 'この RPC URL は既に一覧にあります。';

  @override
  String get networkNodeNameRpcRequired => 'ノード名と RPC URL を入力してください';

  @override
  String get networkNodeAdded => 'ノードを追加しました';

  @override
  String get networkRpcCopied => 'RPC URL をコピーしました';

  @override
  String get networkNodeSwitched => 'このノードに切り替えました';

  @override
  String get networkNodeDeleted => 'ノードを削除しました';

  @override
  String get networkSettingsTitle => 'ネットワーク設定';

  @override
  String get networkSettingsSubtitle => 'ブロックチェーン RPC ノードの設定';

  @override
  String networkLoadFailed(String message) {
    return '読み込みに失敗しました：$message';
  }

  @override
  String get networkSectionMainnet => 'メインネット';

  @override
  String get networkSectionTestnet => 'テストネット';

  @override
  String get networkTestnetListHint =>
      'アプリ内のチェーン一覧で testnet とマークされたネットワークがここに表示されます。';

  @override
  String networkCountNetworks(int count) {
    return '$count ネットワーク';
  }

  @override
  String get networkAboutNodesTitle => 'RPC ノードについて';

  @override
  String get networkAboutNodesBullet1 => 'RPC ノードはブロックチェーンへの接続窓口です。';

  @override
  String get networkAboutNodesBullet2 => '速度や安定性のためカスタムノードを追加できます。';

  @override
  String get networkAboutNodesBullet3 => '信頼できる公開ノードまたは自前のノードを推奨します。';

  @override
  String get networkStatusConnectionOk => '接続 OK';

  @override
  String get networkStatusConnectionError => '接続エラー';

  @override
  String get networkStatusCustomized => 'カスタム';

  @override
  String networkNodeCountLabel(int count) {
    return 'ノード $count 件';
  }

  @override
  String networkAllNodesTitle(int count) {
    return 'すべてのノード（$count）';
  }

  @override
  String networkDetailHeaderNodeCount(int count) {
    return 'ノード $count 件';
  }

  @override
  String get networkQuickAddTitle => 'ノードをすばやく追加';

  @override
  String get networkQuickAddLine1 => 'ネットワークをタップして詳細を開き、カスタム RPC を追加できます。';

  @override
  String get networkQuickAddLine2 =>
      '複数ノードを追加可能です。一覧は今後の機能（最速ノードの選択など）に備えて保持されます。';

  @override
  String get networkNodeProbeOk => 'ノード接続は正常です';

  @override
  String networkNodeProbeOkLatency(int ms) {
    return 'ノード接続は正常、レイテンシ $ms ms';
  }

  @override
  String get networkCurrentNodeTitle => '現在使用中のノード';

  @override
  String get networkNodeActiveBadge => '有効';

  @override
  String get networkNoNodeSelected => 'ノードが未選択です';

  @override
  String networkNodeLatencyMs(int ms) {
    return 'レイテンシ $ms ms';
  }

  @override
  String get networkAddRpcDialogTitle => 'RPC ノードを追加';

  @override
  String networkAddRpcDialogSubtitle(String networkName) {
    return '$networkName ネットワーク用のカスタム RPC ノードを追加';
  }

  @override
  String get networkNodeNameLabel => 'ノード名';

  @override
  String get networkNodeNameHint => '例：マイノード 1';

  @override
  String get networkRpcUrlLabel => 'RPC URL';

  @override
  String get networkRpcUrlHint => 'https://…';

  @override
  String get networkExampleRpcLabel => 'RPC URL の例';

  @override
  String get networkConfirmAddNode => '追加する';

  @override
  String get networkTipsTitle => 'ヒント';

  @override
  String get networkTipsLine1 => 'バックアップ用に複数ノードを追加しましょう。';

  @override
  String get networkTipsLine2 => 'テストで接続状態と遅延を確認できます。';

  @override
  String get networkTipsLine3 => 'レイテンシが低いほどトランザクションが速くなることが多いです。';

  @override
  String get networkTipsLine4 => 'プリセットのデフォルトノードは削除できません。';

  @override
  String get networkNodeInUseBadge => '使用中';

  @override
  String get networkCannotDeleteDefaultNode => 'デフォルトノードは削除できません。';

  @override
  String get networkDeleteSwitchNodeFirst => '削除する前に別のノードに切り替えてください。';

  @override
  String homeFiatApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String homeUnitPrice(String price) {
    return '単価: $price';
  }

  @override
  String get homeUnitPriceUnavailable => '単価: --';

  @override
  String get homeTransactionHistory => 'ノート作成記録';

  @override
  String get homeTransactionHistoryNotConfigured => 'ノート作成記録は未設定です';

  @override
  String get transactionHistorySubtitle => 'すべてのノート作成記録を確認';

  @override
  String get transactionHistoryStatTotal => '合計';

  @override
  String get transactionHistoryStatSuccess => '成功';

  @override
  String get transactionHistoryStatPending => '確認待ち';

  @override
  String get transactionHistoryStatFailed => '失敗';

  @override
  String get transactionHistoryFilterAll => 'すべて';

  @override
  String get transactionHistoryFilterSend => 'ノート作成';

  @override
  String get transactionHistoryFilterReceive => '受信';

  @override
  String get transactionHistorySelectChain => 'ネットワークを選択';

  @override
  String get transactionHistoryCopied => 'クリップボードにコピーしました';

  @override
  String get transactionHistoryExplorerInvalidUrl => 'エクスプローラーの URL が無効です';

  @override
  String get transactionHistoryExplorerLaunchFailed => 'ブラウザを開けません。設定を確認してください';

  @override
  String transactionHistoryExplorerOpenError(String error) {
    return '開けませんでした: $error';
  }

  @override
  String get transactionHistoryRefreshed => 'ノート作成記録を更新しました';

  @override
  String get transactionHistoryTimeJustNow => 'たった今';

  @override
  String transactionHistoryTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 時間前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 日前',
    );
    return '$_temp0';
  }

  @override
  String get transactionHistoryEmptyTitle => 'ノート作成記録がありません';

  @override
  String get transactionHistoryEmptyHintFiltered => '条件に一致するノート作成記録がありません';

  @override
  String get transactionHistoryEmptyHintAll => 'まだノート作成記録はありません';

  @override
  String get transactionHistoryTypeSend => 'ノート作成';

  @override
  String get transactionHistoryTypeReceive => '受信';

  @override
  String get transactionHistoryStatusSuccess => '成功';

  @override
  String get transactionHistoryStatusFailed => '失敗';

  @override
  String get transactionHistoryStatusPending => '確認待ち';

  @override
  String get transactionHistoryDetailFrom => '送信元';

  @override
  String get transactionHistoryDetailTo => '送信先';

  @override
  String get transactionHistoryDetailTxHash => 'オンチェーンハッシュ';

  @override
  String get transactionHistoryDetailBlock => 'ブロック';

  @override
  String transactionHistoryGasLine(String fee, String symbol) {
    return 'Gas: $fee $symbol';
  }

  @override
  String homeGasBalanceTitle(String symbol) {
    return '$symbol ガス残高';
  }

  @override
  String get homeTotalAssets => '総残高';

  @override
  String get homeRefreshBalance => '残高を更新';

  @override
  String get homeGetGas => 'ガスを取得';

  @override
  String get homeGasHelp => 'ガスはオンチェーン取引の手数料です。残高を十分に確保してください。';

  @override
  String getGasDialogTitle(String symbol) {
    return '$symbol をガス用に取得';
  }

  @override
  String getGasDialogSubtitle(String chainName) {
    return '$chainName ノートアカウントへの入金方法を選んでください';
  }

  @override
  String get getGasOptionReceiveTitle => 'トークンを受け取る';

  @override
  String get getGasBadgeRecommended => 'おすすめ';

  @override
  String getGasReceiveHint(String symbol) {
    return '別のノートアカウントや取引所から $symbol を送る';
  }

  @override
  String get getGasWalletAddressLabel => 'ノートアカウントアドレス';

  @override
  String get getGasShowQr => 'QR';

  @override
  String get getGasHideQr => '非表示';

  @override
  String getGasTransferWarning(String chainName) {
    return '送金ネットワークが $chainName であることを確認してください。違うとノートを失う可能性があります';
  }

  @override
  String get getGasFaucetTitle => 'テストネットのフォーセット';

  @override
  String get getGasBadgeFree => '無料';

  @override
  String getGasFaucetHint(String symbol) {
    return 'フォーセットでテストネットの $symbol を無料取得';
  }

  @override
  String getGasFaucetOpen(int index) {
    return 'フォーセット $index を開く';
  }

  @override
  String get getGasBuyExchangeTitle => '取引所で購入';

  @override
  String get getGasBadgeComingSoon => '近日対応';

  @override
  String getGasBuyExchangeHint(String symbol) {
    return '取引所で $symbol を購入しノートアカウントに出金';
  }

  @override
  String get getGasDialogCancel => 'キャンセル';

  @override
  String get getGasAddressCopied => 'アドレスをコピーしました';

  @override
  String get getGasInvalidLink => 'リンクが無効です';

  @override
  String get getGasCouldNotOpenLink => 'リンクを開けません。ブラウザを確認してください';

  @override
  String getGasOpenFailed(String error) {
    return '開けませんでした: $error';
  }

  @override
  String get homeRecentNotes => '最近のノート';

  @override
  String get homeRefreshRecentNotes => '最近のノートを更新';

  @override
  String get homeLoadingOnChainNotes => 'オンチェーンノートを読み込み中';

  @override
  String get homeSyncingOnChainNotes => 'オンチェーンノートを同期中…';

  @override
  String get homeNoNotesInLastMonth => '最近1か月はノートがありません';

  @override
  String get homeCreateNewNotePrompt => '新しいノートを作成しましょう';

  @override
  String get notesAllChains => 'すべてのチェーン';

  @override
  String get notesSwitchedToAllChains => 'すべてのチェーンに切り替えました';

  @override
  String get notesFilterAll => 'すべて';

  @override
  String get notesFilterOnChain => 'オンチェーン';

  @override
  String get notesFilterOffChain => 'オフチェーン';

  @override
  String get notesSortNewest => '新しい順';

  @override
  String get notesSortUpdated => '更新順';

  @override
  String get notesSortOldest => '古い順';

  @override
  String get notesSortTitle => 'タイトル';

  @override
  String notesTimelineNoteCount(int count) {
    return '$count件';
  }

  @override
  String get noteStatsTotalNotes => 'ノート総数';

  @override
  String get noteStatsOnChainCount => 'オンチェーン';

  @override
  String get noteStatsImages => '画像';

  @override
  String get noteStatsChars => '文字数';

  @override
  String get noteDeleteNote => 'ノートを削除';

  @override
  String get noteDeleteConfirmTitle => 'ノートを削除しますか？';

  @override
  String get noteDeleteConfirmBody => 'このノートを削除しますか？元に戻せません。';

  @override
  String get noteDeletedSnackbar => 'ノートを削除しました';

  @override
  String noteDeleteFailed(String error) {
    return '削除に失敗しました：$error';
  }

  @override
  String noteUpdatedAt(String date) {
    return '更新 $date';
  }

  @override
  String noteCreatedAt(String date) {
    return '作成 $date';
  }

  @override
  String get noteNoContent => '内容はまだありません';

  @override
  String get noteEditorCreateNewNote => '新しいノートを作成';

  @override
  String noteEditorChainLine(String chainName) {
    return '$chainName チェーン';
  }

  @override
  String get noteEditorSelectChainToPublish => 'チェーンを選択するとオンチェーン公開できます';

  @override
  String get noteEditorSave => '保存';

  @override
  String get noteEditorSaving => '保存中…';

  @override
  String get noteTitleLabel => 'タイトル';

  @override
  String get noteTitleHint => 'ノートのタイトルを入力…';

  @override
  String get noteCoverImages => 'カバー画像（任意）';

  @override
  String get noteCoverAdd => 'カバーを追加';

  @override
  String get noteCoverUploading => 'アップロード中…';

  @override
  String get noteCoverTapUpload => 'タップしてカバー画像をアップロード';

  @override
  String get noteCoverFormatsHint => 'JPG・PNG などに対応';

  @override
  String get noteRichTextGuideTitle => 'リッチテキスト機能';

  @override
  String get noteRichTextHeadingLabel => '見出し：';

  @override
  String get noteRichTextHeadingBody => 'ツールバーの「見出し」で番号付き見出しを挿入できます。';

  @override
  String get noteRichTextListLabel => 'リスト：';

  @override
  String get noteRichTextListBody => '箇条書きや番号付きリストを挿入できます。';

  @override
  String get noteRichTextEmojiLabel => '絵文字：';

  @override
  String get noteRichTextEmojiBody => 'よく使う絵文字やマーカーを素早く挿入。';

  @override
  String get noteRichTextTemplateLabel => 'テンプレート：';

  @override
  String get noteRichTextTemplateBody => '定型テンプレートですぐに書き始められます。';

  @override
  String get noteRichTextImageLabel => '画像：';

  @override
  String get noteRichTextImageBody => 'ツールバーの画像ボタンで本文に挿入できます。';

  @override
  String get noteRichTextPreviewHint => 'ヒント:「プレビュー」で整形結果を確認できます。';

  @override
  String get noteEditorContentPlaceholder =>
      'アイデアや計画を書き留めましょう…\n\nヒント：ツールバーから素早く挿入できます：\n• 見出しとリスト\n• 絵文字と記号\n• クイックテンプレート\n• 画像\n\nリッチテキスト対応。詳細画面できれいに表示されます。';

  @override
  String get noteTipsTitle => '書くときのヒント';

  @override
  String get noteTipsBody =>
      '• 分かりやすいタイトルをつける\n• アイデアや予定、重要な情報を記録\n• 画像で内容を豊かに\n• 保存後、オンチェーン公開で永久保存';

  @override
  String get noteReadyTitle => '入力完了';

  @override
  String get noteReadyBody => '内容が揃いました。右上の「保存」でノートを作成できます。';

  @override
  String get noteTypeSectionLabel => 'ノートの種類：';

  @override
  String get notePublishToChain => 'チェーンに公開';

  @override
  String get notePublishing => '公開中…';

  @override
  String get noteOnChainPublished => 'オンチェーン済み';

  @override
  String get selectBlockchainFirst => '先にブロックチェーンネットワークを選択してください';

  @override
  String get noteImageAdded => '画像を追加しました';

  @override
  String get noteImagePickFailed => '画像を選べませんでした';

  @override
  String get noteSavedToLocal => 'ローカルに保存しました';

  @override
  String get notePublishFailedKeptDraft => '公開に失敗しました。下書きとして保存しました';

  @override
  String get noteSavedAsDraft => '下書きとして保存しました';

  @override
  String get richTextPreviewMode => 'プレビューモード';

  @override
  String get richTextEditMode => '編集モード';

  @override
  String get richTextPreview => 'プレビュー';

  @override
  String get richTextEdit => '編集';

  @override
  String richTextLineCount(int count) {
    return '$count 行';
  }

  @override
  String richTextCharCount(int count) {
    return '$count 文字';
  }

  @override
  String get richTextToolbarBottomHint =>
      'ヒント: ツールバーで整形を挿入するか、絵文字や記号を直接入力できます。';

  @override
  String get richTextToolbarHeading => '見出し';

  @override
  String get richTextTooltipInsertHeading => '見出しを挿入';

  @override
  String get richTextTooltipBulletList => '箇条書きを挿入';

  @override
  String get richTextTooltipNumberedList => '番号リストを挿入';

  @override
  String get richTextTooltipStatusMarkers => 'ステータス記号を挿入';

  @override
  String get richTextToolbarEmojiMenu => '絵文字';

  @override
  String get richTextTooltipInsertEmoji => '絵文字を挿入';

  @override
  String get richTextToolbarTemplate => 'テンプレート';

  @override
  String get richTextTooltipQuickTemplate => 'クイックテンプレート';

  @override
  String get richTextTooltipAddImage => '画像を追加';

  @override
  String get richTextMdImageAlt => '画像';

  @override
  String get richTextInsertNumberedHeading => '\n1️⃣ タイトル\n';

  @override
  String get richTextInsertBulletLines => '\n• 項目 1\n• 項目 2\n• 項目 3\n';

  @override
  String get richTextInsertNumberedLines => '\n1. 一つ目\n2. 二つ目\n3. 三つ目\n';

  @override
  String get richTextInsertStatusMarkers => '\n🟢 完了\n🔵 進行中\n🟡 未対応\n';

  @override
  String get richTextEmojiGroupNumberedTitle => '数字見出し';

  @override
  String get richTextEmojiGroupStatus => 'ステータス';

  @override
  String get richTextEmojiGroupSymbols => 'よく使う記号';

  @override
  String get richTextEmojiGroupEmoji => '絵文字';

  @override
  String get richTextEmojiHeadingWord => 'タイトル';

  @override
  String get richTextEmojiBodyWord => '本文';

  @override
  String get richTextTplStandardNoteName => '📝 標準ノート';

  @override
  String get richTextTplStandardNoteBody =>
      'タイトル\n\n本文:\n• ポイント 1\n• ポイント 2\n• ポイント 3\n\nまとめ:\n';

  @override
  String get richTextTplTaskName => '✅ タスクリスト';

  @override
  String get richTextTplTaskBody =>
      'タスクリスト\n\n今日:\n✓ 完了\n✗ 未完了\n→ 進行中\n\nメモ:\n';

  @override
  String get richTextTplStudyName => '📚 学習ノート';

  @override
  String get richTextTplStudyBody =>
      '学習ノート - テーマ\n\n1️⃣ 重要な概念\n• 概念 1: 説明\n• 概念 2: 説明\n\n2️⃣ まとめ\n• 要点 1\n• 要点 2\n\n3️⃣ 演習\n';

  @override
  String get richTextTplIdeaName => '💡 アイデア';

  @override
  String get richTextTplIdeaBody =>
      '💡 アイデア\n\n着想:\n🟢 コアアイデア\n\n利点:\n• メリット 1\n• メリット 2\n\n次:\n→ 次のステップ\n';

  @override
  String get richTextTplProjectName => '📊 プロジェクト計画';

  @override
  String get richTextTplProjectBody =>
      'プロジェクト計画\n\n🎯 目標:\n\n📝 ステップ:\n1. ステップ 1\n2. ステップ 2\n3. ステップ 3\n\n⏰ スケジュール:\n';

  @override
  String get gasPreviewTitle => 'ガス料金プレビュー';

  @override
  String get gasPreviewSubtitle => 'ガス速度を選び、オンチェーン公開を確定してください。';

  @override
  String get gasPreviewLoading => 'ガス料金を取得中…';

  @override
  String get gasPreviewPickSpeed => 'ガス速度';

  @override
  String get gasPreviewLiveRates => '推定レート';

  @override
  String get gasSpeedSlow => '低速';

  @override
  String get gasSpeedStandard => '標準';

  @override
  String get gasSpeedFast => '高速';

  @override
  String get gasTimeSlow => '約3–5分';

  @override
  String get gasTimeStandard => '約1–2分';

  @override
  String get gasTimeFast => '約15–30秒';

  @override
  String get gasDescSlow => 'baseFee×1.1、優先度手数料 = max(30Gwei, 推奨) + 3Gwei';

  @override
  String get gasDescStandard => 'baseFee×1.25、優先度手数料 = max(30Gwei, 推奨) + 8Gwei';

  @override
  String get gasDescFast => 'baseFee×1.5、優先度手数料 = max(30Gwei, 推奨) + 20Gwei';

  @override
  String get gasLabelGasPrice => 'ガス価格';

  @override
  String get gasLabelEstCost => '見積り';

  @override
  String get gasRecommendedBadge => 'おすすめ';

  @override
  String gasPreviewGweiMax(String value) {
    return '$value Gwei（上限）';
  }

  @override
  String get gasFeeBreakdownTitle => '内訳';

  @override
  String get gasFeeRowBase => '基本手数料';

  @override
  String get gasFeeRowPriority => '優先手数料';

  @override
  String get gasFeeRowNoteSize => 'ノートサイズ';

  @override
  String get gasFeeRowTotal => '合計';

  @override
  String gasFeeNoteSizeKb(String kb) {
    return '$kb KB';
  }

  @override
  String get gasWarningTitle => 'ご注意';

  @override
  String get gasWarningBody =>
      '• ガスはネットワークへの支払いで、アプリとは無関係です。\n• 混雑により実額が多少変わる場合があります。\n• オンチェーン後は削除・編集できません。';

  @override
  String get gasConfirmOnChain => 'オンチェーンで確定';

  @override
  String get gasOnChainConfirmDialogTitle => 'オンチェーン後は変更できません';

  @override
  String get gasOnChainConfirmDialogBody =>
      'このノートはブロックチェーン（IPFS + オンチェーン証跡）に書き込まれます。\n送信後は削除・編集できません。内容に問題がないことを確認してから続行してください。';

  @override
  String get gasOnChainConfirmDialogQuestion => 'オンチェーンに公開しますか？';

  @override
  String get onChainConfirmParamSummarySectionTitle => '呼び出しパラメータ';

  @override
  String get noteOnChainParamJsonKeyNetwork => 'ネットワーク';

  @override
  String get noteOnChainParamJsonKeyChainId => 'チェーン ID';

  @override
  String get noteOnChainParamJsonKeyFeeToken => 'ガス支払トークン';

  @override
  String get noteOnChainParamJsonKeySender => '送信元（あなたのノートアカウント）';

  @override
  String get noteOnChainParamJsonKeyContract => 'コントラクトアドレス';

  @override
  String get noteOnChainParamJsonKeyContractName => 'コントラクト名';

  @override
  String get noteOnChainParamJsonKeyFunction => '呼び出し関数';

  @override
  String get noteOnChainParamJsonKeyNoteTitle => 'ノートタイトル';

  @override
  String get noteOnChainParamJsonKeyContentSha256 => '本文フィンガープリント SHA-256';

  @override
  String get noteOnChainParamJsonGroupMintCall => 'オンチェーン呼び出し（コントラクト引数）';

  @override
  String get noteOnChainParamJsonGroupContext => 'いま確認できる情報';

  @override
  String get noteOnChainParamJsonValueUriPending =>
      'セキュリティ認証後に IPFS へアップロードされ、実際の ipfs:// が入ります';

  @override
  String get noteOnChainConfirmPageTitle => 'オンチェーン公開の確認';

  @override
  String get noteOnChainConfirmPageSubtitle => 'ノートをブロックチェーンに永久保存します';

  @override
  String get noteOnChainConfirmNoExplorer =>
      'このネットワークにはエクスプローラーが設定されていません。コントラクトを開けません。';

  @override
  String get noteOnChainConfirmMintStatusUncertain =>
      'オンチェーン状態が不明です。後でノートまたはエクスプローラーで確認してください。';

  @override
  String get noteOnChainConfirmSignButton => '確認してセキュリティ認証';

  @override
  String get noteOnChainConfirmTipTitle => '公開前の注意';

  @override
  String get noteOnChainConfirmTipBody =>
      '• 公開後はノートの編集・削除はできません\n• ノートは永久にオンチェーンとなり、あなたのものになります\n• 少額のガス代が一度だけ必要です';

  @override
  String get noteOnChainConfirmNoteContentSection => 'ノート内容';

  @override
  String get noteOnChainConfirmNoteTitleLabel => 'タイトル';

  @override
  String get noteOnChainConfirmContentPreview => '本文プレビュー';

  @override
  String get noteOnChainConfirmNoteHashLabel => 'ノートハッシュ (SHA-256)';

  @override
  String get noteOnChainConfirmChainDetailsSection => 'オンチェーン詳細';

  @override
  String get noteOnChainConfirmMyWallet => 'マイノートアカウント';

  @override
  String get noteOnChainConfirmTargetContract => '対象コントラクト';

  @override
  String get noteOnChainConfirmContractOwnershipHint =>
      'コントラクトがノート（NFT）をミントします。ノート（NFT）はあなたのノートアカウントに帰属し、ノートの永久所有権はあなたにあります。';

  @override
  String noteOnChainConfirmNoteRecipientAddress(String address) {
    return 'ノート受取アドレス：$address';
  }

  @override
  String get noteOnChainConfirmNetworkFee => 'ネットワーク手数料';

  @override
  String get noteOnChainConfirmGasPriceLabel => 'ガス単価';

  @override
  String get noteOnChainConfirmGasLimitLabel => 'ガス上限';

  @override
  String get noteOnChainConfirmOnChainFee => 'オンチェーン手数料';

  @override
  String get noteOnChainConfirmGasOnlyHint => 'ガスのみ';

  @override
  String get noteOnChainConfirmAdvancedSection => '詳細設定';

  @override
  String get noteOnChainConfirmNonceLabel => 'Nonce';

  @override
  String get noteOnChainConfirmNetworkLabel => 'ネットワーク';

  @override
  String get noteOnChainConfirmGasSlow => '低速';

  @override
  String get noteOnChainConfirmGasNormal => '標準';

  @override
  String get noteOnChainConfirmGasFast => '高速';

  @override
  String get noteOnChainConfirmGasTimeSlow => '約5分';

  @override
  String get noteOnChainConfirmGasTimeNormal => '約1分';

  @override
  String get noteOnChainConfirmGasTimeFast => '約15秒';

  @override
  String get saveOptionsTitle => '保存方法を選択';

  @override
  String get saveOptionsSubtitle => '用途に合った保存方法を選んでください。';

  @override
  String get saveOnChainTitle => 'オンチェーンに保存';

  @override
  String get saveOnChainDescription => 'ブロックチェーンに永久保存。改ざんに強い';

  @override
  String get saveOnChainFeature1 => '永続';

  @override
  String get saveOnChainFeature2 => '検証可能';

  @override
  String get saveOnChainFeature3 => '分散型';

  @override
  String get ipfsUploadConfirmTitle => 'IPFS にアップロード';

  @override
  String get ipfsUploadConfirmBody =>
      'このノートにローカル画像があります。オンチェーンの前に、分散ストレージ（IPFS）へアップロードする必要があります。アップロード後、ブロックチェーンへの書き込みに進めます。\n\nIPFS にアップロードして続行しますか？';

  @override
  String get saveBadgeSecure => '安全';

  @override
  String get saveDraftTitle => '下書きで保存';

  @override
  String get saveDraftDescription => 'あとで編集。チェーンリソースはまだ使いません';

  @override
  String get saveDraftFeature1 => 'いつでも編集';

  @override
  String get saveDraftFeature2 => 'ローカル保存';

  @override
  String get saveDraftFeature3 => 'すばやく保存';

  @override
  String get saveBadgeRecommended => 'おすすめ';

  @override
  String get saveLocalTitle => 'ローカルに保存';

  @override
  String get saveLocalDescription => 'この端末にのみ保存';

  @override
  String get saveLocalFeature1 => 'オフライン向け';

  @override
  String get saveLocalFeature2 => '即時保存';

  @override
  String get saveLocalFeature3 => '手数料なし';

  @override
  String saveWillPublishToChain(String chainName) {
    return '$chainName に保存します';
  }

  @override
  String get guideWelcomeTitle => 'オンチェーンノートへようこそ';

  @override
  String get guideWelcomeSubtitle => 'はじめる前に、ノートアカウントを設定しましょう';

  @override
  String get guideSecurityTitle => 'あなたのデータはあなたのもの';

  @override
  String get guideSecurityBody =>
      'セキュリティキーは端末にのみ保存され、当社サーバーに機密情報は保存しません。リカバリーフレーズとセキュリティキーを安全に保管してください。';

  @override
  String get guideCreateWalletTitle => '新しいノートアカウントを作成';

  @override
  String get guideCreateWalletSubtitle => '新しいアドレスとリカバリーフレーズを生成します';

  @override
  String get guideRecommendedNewUser => '初めての方におすすめ';

  @override
  String get guideImportWalletTitle => '既存のノートアカウントを復元';

  @override
  String get guideImportWalletSubtitle => 'リカバリーフレーズまたはセキュリティキーで復元します';

  @override
  String get guideTagMnemonic => 'リカバリーフレーズ';

  @override
  String get guideTagPrivateKey => 'セキュリティキー';

  @override
  String get guideICloudRestoreTitle => 'iCloud から復元';

  @override
  String get guideICloudRestoreSubtitle => 'iCloud にバックアップしている場合、すばやく復元できます';

  @override
  String get guideBadgeIosOnly => 'iOS のみ';

  @override
  String get guideGoogleRestoreTitle => 'Google ドライブから復元';

  @override
  String get guideGoogleRestoreSubtitle =>
      'Google ドライブにバックアップしている場合、すばやく復元できます';

  @override
  String get guideBadgeAllDevices => '全デバイス対応';

  @override
  String get guideFooterHint => 'いずれかを選んで続行してください。\nセキュリティキーはこの端末に安全に保存されます。';

  @override
  String get guideProviderICloud => 'iCloud';

  @override
  String get guideProviderGoogleDrive => 'Google ドライブ';

  @override
  String get guideLoadingWalletMessage => 'ノートアカウントを読み込み中…';

  @override
  String googlePlayReviewModeTapHint(int remaining) {
    return 'あと $remaining 回タップで審査モードに入ります';
  }

  @override
  String get helpCenter => 'ヘルプセンター';

  @override
  String get helpCenterSubtitle => 'よくある質問とガイド';

  @override
  String get helpSectionQuickGuide => 'クイックガイド';

  @override
  String get helpSectionFaq => 'よくある質問';

  @override
  String get helpSearchHint => '質問を検索…';

  @override
  String get helpCategoryAll => 'すべて';

  @override
  String get helpCategoryBasics => '基本操作';

  @override
  String get helpCategoryBlockchain => 'ブロックチェーン';

  @override
  String get helpCategoryWalletSecurity => 'ノートアカウントの安全';

  @override
  String get helpCategoryWalletMgmt => 'ノートアカウント管理';

  @override
  String get helpCategoryAdvanced => '高度な機能';

  @override
  String get helpCategoryCommon => 'よくあるトラブル';

  @override
  String get helpComingSoon => '近日公開';

  @override
  String get helpEmptyTitle => '該当する質問がありません';

  @override
  String get helpEmptySubtitle => '別のキーワードを試すかサポートへ';

  @override
  String get helpContactTitle => 'サポートに連絡';

  @override
  String get helpContactSubtitle => '回答がない場合はメールで';

  @override
  String get helpContactSendFeedback => 'フィードバックを送る';

  @override
  String get helpContactYourEmailOptional => 'メール（任意）';

  @override
  String get helpContactEmailHint => '';

  @override
  String get helpContactMessageLabel => '内容';

  @override
  String get helpContactMessageHint => '問題やご提案を入力…';

  @override
  String get helpContactSending => '送信中…';

  @override
  String get helpContactSend => '送信';

  @override
  String get helpCopySupportEmail => 'メールアドレスをコピーしました';

  @override
  String get helpFeedbackEmpty => 'フィードバックを入力してください';

  @override
  String get helpFeedbackThanks => 'ありがとうございます！';

  @override
  String get helpFeedbackMailFailed => 'メールを開けませんでした';

  @override
  String get helpFeedbackMailSubject => 'ユーザーフィードバック';

  @override
  String get helpQuickGuide1Title => 'クイックスタート';

  @override
  String get helpQuickGuide1Desc => '5分で基本機能を把握';

  @override
  String get helpQuickGuide2Title => '最初のノートを作成';

  @override
  String get helpQuickGuide2Desc => 'ノートを作成してオンチェーン保存';

  @override
  String get helpQuickGuide3Title => 'リカバリーフレーズのバックアップ';

  @override
  String get helpQuickGuide3Desc => 'ノートとデータを守る';

  @override
  String get helpQuickGuide4Title => '複数ノートアカウントの管理';

  @override
  String get helpQuickGuide4Desc => '作成・復元・切り替え';

  @override
  String get helpFaq1Question => 'オンチェーンノートとは？';

  @override
  String get helpFaq1Answer =>
      'ブロックチェーン上にノートを永続保存するアプリです。一度オンチェーンに載せると改ざん耐性と追跡性が高まり、原則として変更・削除はできません。';

  @override
  String get helpFaq2Question => 'ノートの作成方法は？';

  @override
  String get helpFaq2Answer =>
      'ホームの「ノート作成」、またはノート一覧の「+」から作成します。タイトル・本文・画像を追加できます。';

  @override
  String get helpFaq3Question => '保存方法は？';

  @override
  String get helpFaq3Answer =>
      '下書き（いつでも編集）・ローカル保存・オンチェーン保存の3種類です。まず下書きで校正してから公開することをおすすめします。';

  @override
  String get helpFaq4Question => 'オンチェーン保存と手数料は？';

  @override
  String get helpFaq4Answer =>
      'オンチェーン保存はブロックチェーンに永続記録します。ガス代はネットワークが請求し、ネットワークごとに異なります。';

  @override
  String get helpFaq5Question => '対応ネットワークは？';

  @override
  String get helpFaq5Answer =>
      'Ethereum、BSC、Polygon、Arbitrum、Optimism、Avalanche、Fantom、Base など主要EVMをサポートします。ホームで切り替え可能です。';

  @override
  String get helpFaq6Question => 'オンチェーンを確認するには？';

  @override
  String get helpFaq6Answer =>
      'トランザクションハッシュを詳細画面やブロックエクスプローラーで確認できます。「検証」機能も利用できます。';

  @override
  String get helpFaq7Question => 'リカバリーフレーズとは？バックアップは？';

  @override
  String get helpFaq7Answer =>
      'リカバリーフレーズ（多くは12語の英単語）はノートアカウントを復元するマスターキーです。\n\n紛失すると永久にアクセスできなくなる可能性があります。\n漏洩するとノートが永久に失われたり、他人に管理されたりする可能性があります。\nアプリは復元できません。\n紙に書き、安全な場所に保管してください。';

  @override
  String get helpFaq8Question => 'リカバリーフレーズのバックアップ手順は？';

  @override
  String get helpFaq8Answer =>
      'マイページ→バックアップ→注意事項を読む→順に書き写す→確認→完了。他者が見えない環境で行ってください。';

  @override
  String get helpFaq9Question => 'リカバリーフレーズとセキュリティキーの違いは？';

  @override
  String get helpFaq9Answer =>
      'どちらも復元に使えます。リカバリーフレーズは単語列で扱いやすく推奨。セキュリティキーは長い16進で上級者向けです。';

  @override
  String get helpFaq10Question => 'ノートアカウントの切り替えは？';

  @override
  String get helpFaq10Answer =>
      'ホーム上部のアドレスをタップして選択、またはノートアカウント管理で作成・復元します。複数管理に対応します。';

  @override
  String get helpFaq11Question => 'チェーンごとのアドレスは？';

  @override
  String get helpFaq11Answer =>
      'マイノートアカウントでカードを展開すると各チェーンのアドレスが表示され、タップでコピーできます。EVM互換では同一形式のアドレスになります。';

  @override
  String get helpFaq12Question => 'RPCをカスタムするには？';

  @override
  String get helpFaq12Answer =>
      'マイページ→ネットワーク設定→ネットを選ぶ→ノード追加→URL入力→テスト→既定に設定。安定性向上に役立ちます。';

  @override
  String get helpFaq13Question => 'リッチテキストの対応は？';

  @override
  String get helpFaq13Answer => '太字・斜体・下線、見出し、リスト、引用、コード、画像アップロードなどに対応します。';

  @override
  String get helpFaq14Question => 'オンチェーン後に編集・削除できる？';

  @override
  String get helpFaq14Answer => '原則できません。下書きで十分に推敲してから公開し、機密は載せないようご注意ください。';

  @override
  String get helpFaq15Question => 'なぜ待ち時間がある？';

  @override
  String get helpFaq15Answer =>
      '取引がマイニングされるまで時間がかかります。混雑とガス速度（速/標準/遅）に依存し、多くは数分以内です。';

  @override
  String get helpFaq16Question => 'パスワードを忘れたら？';

  @override
  String get helpFaq16Answer =>
      'リカバリーフレーズで再復元して新パスワードを設定できます。パスワードは端末暗号化、最終的な復元はリカバリーフレーズです。';

  @override
  String helpFeedbackMailBody(String email, String message) {
    return '連絡メール：$email\n\n$message';
  }

  @override
  String get termsOfServiceLastUpdatedLabel => '最終更新';

  @override
  String get termsOfServiceIntroTitle => '重要なお知らせ';

  @override
  String termsOfServiceIntroBody(String privacyDoc) {
    return '本利用規約と$privacyDocをよくお読みください。本サービスを利用することで、関連するルールに同意したものとみなします。同意できない場合はご利用をおやめください。';
  }

  @override
  String get termsOfServiceHelpTitle => 'サポートが必要ですか？';

  @override
  String get termsOfServiceHelpBody =>
      '本規約についてご不明な点がある場合は、アプリ内のヘルプセンターを開くか、設定のフィードバックやメールでお問い合わせください。合理的な期間内にできる限り対応します。';

  @override
  String get termsOfServiceHelpMailFeedback => 'メールでフィードバック';

  @override
  String get termsOfServiceSection01Title => '1. 規約への同意';

  @override
  String termsOfServiceSection01Body(String appTitle) {
    return '「$appTitle」（以下「本サービス」）へようこそ。利用前に本利用規約（以下「本規約」）をお読みください。\n同意のタップ、登録、ログイン、または本サービスの利用により、本規約に拘束されることに同意したものとみなします。同意できない場合はご利用を中止してください。\n当社は本規約を随時改定することがあり、アプリ内の通知または更新後も利用を続けると、改定後の規約に同意したものとみなされます。';
  }

  @override
  String get termsOfServiceSection02Title => '2. サービス内容';

  @override
  String get termsOfServiceSection02Body =>
      '本サービスは、ローカル保存とブロックチェーン関連機能を組み合わせたメモアプリです。端末上でメモの作成・編集・管理ができ、任意でオンチェーン操作（送金、ハッシュ、メタデータなど、アプリ内の手順・案内に従います）を行えます。\n現在の特徴（バージョンにより変更あり）：\n• ローカル保存：メモ等のデータは主に端末内（ローカルDB等）に保存されます。アプリをアンインストールするとローカルデータが失われることがあります。必ずご自身でバックアップしてください。\n• オンチェーン機能：証明、同期、表示等の目的で、任意にオンチェーン操作を送信できます。オンチェーン記録は公開され削除が困難なことが多いです。\n• マルチチェーン：アプリに表示される複数のEVM互換ネットワークに対応します。\n• ノートアカウント：鍵は端末上で生成または復元され、リカバリーフレーズ・セキュリティキーの保管は利用者の責任です。\n本サービスは技術的手段のみを提供し、コンテンツの合法性、正確性、完全性、特定目的への適合性を保証するものではありません。';

  @override
  String get termsOfServiceSection03Title => '3. ノートアカウントとセキュリティ';

  @override
  String get termsOfServiceSection03Body =>
      '3.1 ノートアカウントと資格情報：ノートアカウントを作成または復元後、アプリは端末側でアドレスと鍵素材を管理します。リカバリーフレーズ・セキュリティキーはノートを復元するための重要な手段の一つです。オフラインでバックアップし、厳重に管理してください。\n3.2 セキュリティ上の責任：端末上でアプリまたはノートアカウントがロック解除されている状態で行われた操作は、利用者またはその許可環境下での行為とみなします。リカバリーフレーズ・セキュリティキーの漏えい、端末紛失、マルウェア、フィッシング、案内に従わない操作等に起因する損害は、利用者が負担します。\n3.3 セキュリティの推奨事項：\n• リカバリーフレーズ・セキュリティキーを第三者に開示しないでください\n• アプリに強力なパスワードを設定し、利用可能な場合は端末ロック・生体認証を有効化してください\n• 信頼できる環境でリカバリーフレーズをバックアップし、内容を検証してください\n• なりすましアプリ・フィッシングに注意してください\n3.4 当社およびスタッフが、いかなる理由でもリカバリーフレーズやセキュリティキーの全体を求めることはありません。そのような要求には応じず、公式経路でご報告ください。';

  @override
  String get termsOfServiceSection04Title => '4. オンチェーン取引と手数料';

  @override
  String termsOfServiceSection04Body(String appTitle) {
    return '4.1 Gas とネットワーク料金：オンチェーン取引には、ネットワークへ支払う手数料（Gas等）が必要です。料金はネットワークが徴収し、ソフトウェア提供者である「$appTitle」が商業的に代理徴収するものではありません。金額はネットワークと混雑状況によります。\n4.2 確認時間：取引にはネットワーク確認が必要で、所要時間はネットワーク状態と手数料設定によります。特定の所要時間を保証しません。\n4.3 失敗と課金：残高不足、RPC障害、利用者によるキャンセル、コントラクトのrevert等で失敗することがあり、既に消費されたネットワーク料金はネットワーク規則に従い返金されない場合があります。\n4.4 不可逆性：十分に確認されたオンチェーン取引は通常取り消せません。セキュリティ認証・ブロードキャスト前にネットワーク、金額、コントラクト操作内容を再確認してください。\n4.5 利用者が開始したすべてのオンチェーン操作とその結果について、利用者が責任を負います。法令で許される範囲で、ブロックチェーンプロトコル、第三者ノード、スマートコントラクト、または利用者の誤操作に起因する損害について当社は責任を負いません。';
  }

  @override
  String get termsOfServiceSection05Title => '5. 利用上の禁止事項';

  @override
  String get termsOfServiceSection05Body =>
      '本サービスの利用にあたり、次を行ってはなりません。\n• 違法・侵害・中傷・わいせつ・暴力的・ヘイトその他不法なコンテンツの作成・アップロード・流通\n• 詐欺、マネーロンダリング、違法な資金調達、知的財産権侵害、当局が禁止する行為への利用\n• 許可なく本サービスまたは関連インフラへのアクセス・探査・妨害・破壊\n• スクレイピング、APIの濫用、その他利用者の通常利用を害する行為（書面による許可がある場合を除く）\n• 嫌がらせや無断の商用メッセージの大量送信\n違反があった場合、警告、機能制限、利用停止・終了、その他必要な措置をとることがあり、法令または監督当局の要請に応じて協力することがあります。';

  @override
  String get termsOfServiceSection06Title => '6. 知的財産権';

  @override
  String get termsOfServiceSection06Body =>
      '6.1 本サービス自体：クライアントソフトウェア、UI、商標、文書等の著作権・商標権等は当社または権利者に帰属します。許可なく、コアソフトの複製・リバースエンジニアリング・クラック・商用再頒布をしてはなりません（法令上許容される範囲を除く）。\n6.2 利用者のコンテンツ：作成したメモ等の権利は利用者に留保され、本規約により当社へ移転するものではありません。\n6.3 当社へのライセンス：同期、表示、バックアップ、オンチェーン送信等、本サービスの運用・改善に必要な範囲で、非独占・ロイヤリティフリー（規約で許される範囲で撤回可能）のライセンスを付与します。\n6.4 書面の許可なく、当社の商標・アプリ名・ロゴを紛らわしい方法で使用しないでください。';

  @override
  String get termsOfServiceSection07Title => '7. 免責事項';

  @override
  String get termsOfServiceSection07Body =>
      '7.1 「現状有姿」：法令で認められる最大限の範囲で、本サービスは「現状有姿」「提供可能な範囲」で提供されます。継続稼働、無誤動作、ニーズへの適合、すべての機器・ソフトとの互換性について、黙示・明示の保証は行いません。\n7.2 データとセキュリティ：合理的な措置を講じますが、不可抗力、端末紛失、マルウェア、攻撃、ブロックチェーン/IPFS等の外部システムによる漏えい・喪失・停止が永遠に起こらないことは保証できません。\n7.3 第三者：ノード、ゲートウェイ、分散ストレージ、プッシュ通知等の第三者サービスに依存することがあり、その可用性・正確性・コンプライアンスを保証しません。リスクはご自身で評価してください。\n7.4 オンチェーンノートとプロトコルのリスク：オンチェーンノートおよび関連プロトコルには、ネットワーク障害、コントラクトの不具合、フォーク等のリスクがあります。利用者が理解し負担します。\n7.5 責任制限：法令で禁じられる場合を除き、間接・付随・特別・結果的損害について責任を負いません。総賠償額は、当該紛争に関して利用者が当社に実際に支払った金額を上限とします（ゼロの場合はゼロ）。';

  @override
  String get termsOfServiceSection08Title => '8. 変更・中止・終了';

  @override
  String get termsOfServiceSection08Body =>
      '8.1 事業、コンプライアンス、技術上の理由により、機能の変更・一時停止・終了を行うことがあります。可能な範囲でアプリ内でお知らせします。\n8.2 利用者はいつでも利用を中止しアンインストールできます。重要なデータは事前にエクスポート・バックアップしてください。\n8.3 本規約に重大に違反した場合、利用を停止・終了することがあります。\n8.4 終了後、法令で別段の定めがない限り、オンチェーン、第三者ネットワーク、または利用者が管理するローカルのデータを保存・返還する義務はありません。';

  @override
  String get termsOfServiceSection09Title => '9. 準拠法と紛争解決';

  @override
  String get termsOfServiceSection09Body =>
      '9.1 本規約の成立、有効性、解釈および履行は、中華人民共和国本土の法律に準拠します（本規約の目的に限り、強行法の別段の定めがある場合を除き、外国法を選ばせる抵触法規則は除外します）。\n9.2 紛争は、まず誠意をもって協議により解決するものとします。\n9.3 協議が整わない場合、管轄権を有する裁判所に訴えを提起することができます（例：当社の主たる事務所所在地を管轄する裁判所）。強行的な管轄規則と抵触する場合は法令に従います。';

  @override
  String get termsOfServiceSection10Title => '10. その他';

  @override
  String termsOfServiceSection10Body(String privacyDoc) {
    return '10.1 完全合意：本規約、$privacyDoc（該当する場合）、およびアプリ内の個別ルールが、本サービス利用の主たる規律を構成します。抵触する場合、個別ルールが当該事項について優先します（強行法に反しない範囲）。\n10.2 分離可能性：いずれかの条項が無効または執行不能とされた場合でも、残りは有効とし、可能な限り原文の趣旨に沿って解釈されます。\n10.3 権利不放棄：権利を行使しなかったことも、放棄を意味しません。\n10.4 お問い合わせ：法令で別の義務的チャネルがない限り、アプリ内のヘルプセンターまたはフィードバックから本規約に関する質問ができます。';
  }

  @override
  String termsOfServiceFooterLine1(String appTitle) {
    return '$appTitle をご利用いただきありがとうございます。';
  }

  @override
  String get connectEvmAccountFirst => '先に EVM ノートアカウントを接続してください';

  @override
  String get createAccountFailedRetry => 'ノートアカウントの作成に失敗しました。しばらくしてから再試行してください';

  @override
  String createAccountFailedWithError(String error) {
    return 'ノートアカウントの作成に失敗しました：$error';
  }

  @override
  String get transactionHistoryConnectEvm =>
      'ネットワークを選択し、EVM ノートアカウントが接続されていることを確認してください';

  @override
  String get transactionHistoryUnsupportedNetwork =>
      'このネットワークではノート作成記録一覧に未対応です。一般的な EVM ネットワークに切り替えてください。';

  @override
  String get securityVerificationFailed => 'セキュリティ認証に失敗しました';

  @override
  String get walletImportPrivateKeyHint => 'セキュリティキーを入力してください。第三者に共有しないでください。';

  @override
  String get walletImportPrivateKeySubmit => 'セキュリティキーを復元';
}
