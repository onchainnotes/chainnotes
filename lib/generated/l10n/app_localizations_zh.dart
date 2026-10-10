// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '链上笔记';

  @override
  String get tabHome => '首页';

  @override
  String get tabNotes => '笔记';

  @override
  String get tabProfile => '我的';

  @override
  String get myNotes => '我的笔记';

  @override
  String notesCount(int count) {
    return '共 $count 篇笔记';
  }

  @override
  String get createNote => '创建笔记';

  @override
  String get selectNetwork => '选择网络';

  @override
  String get selectNetworkSubtitle => '选择您想要使用的区块链网络';

  @override
  String get chainSelectorMainnetTab => '主网';

  @override
  String get chainSelectorTestnetTab => '测试网';

  @override
  String get chainSelectorFooterHint => '切换网络后，笔记将保存在对应的区块链上';

  @override
  String get chainSelectorTestnetNoticeTitle => '测试网说明';

  @override
  String get chainSelectorTestnetNoticeBody => '测试网用于开发测试，代币无真实价值';

  @override
  String get chainSelectorAllChainsTitle => '全部链';

  @override
  String get chainSelectorAllChainsSubtitle => '显示所有链的笔记';

  @override
  String chainSelectorChainIdLabel(int chainId) {
    return '链 ID：$chainId';
  }

  @override
  String get chainSelectorCurrentBadge => '当前';

  @override
  String chainSelectorGasLabel(String cost) {
    return 'Gas：$cost';
  }

  @override
  String get chainGasCostLevelMedium => '中等';

  @override
  String get chainSelectorTestnetChainWarning => '测试网络 · 无真实价值';

  @override
  String get viewAll => '查看全部';

  @override
  String get aboutUs => '关于我们';

  @override
  String get aboutPageTagline => '永久保存 · 不可篡改 · 完全掌控';

  @override
  String splashVersionLabel(String version) {
    return '版本 $version';
  }

  @override
  String get aboutPageVersionSection => '版本信息';

  @override
  String get aboutPageCurrentVersion => '当前版本';

  @override
  String get photosPermissionDeniedSnack => '无相册权限，请在系统设置中开启后重试';

  @override
  String get pressBackAgainToExitApp => '再次点击退出应用';

  @override
  String noteEditorOnChainTypeConfirmedSnack(String publishAction) {
    return '已确认上链，请保存或点击「$publishAction」继续';
  }

  @override
  String get actionShow => '显示';

  @override
  String get actionHide => '隐藏';

  @override
  String get actionSaveToFile => '保存文件';

  @override
  String get mnemonicExportSecurityConfirmTitle => '安全确认';

  @override
  String get mnemonicExportAckSaved => '我已安全保存恢复短语到可靠位置';

  @override
  String get mnemonicExportAckUnderstandLoss => '我理解丢失恢复短语将无法恢复笔记账户';

  @override
  String get mnemonicExportAckNoShare => '我承诺不向任何人泄露恢复短语';

  @override
  String get mnemonicExportSafetyTipsTitle => '安全建议';

  @override
  String get mnemonicExportSafetyTipPaper => '将恢复短语写在纸上，存放在安全的地方';

  @override
  String get mnemonicExportSafetyTipNoScreenshot => '不要截图或保存在联网设备上';

  @override
  String get mnemonicExportSafetyTipCheckBackup => '定期检查备份的完整性';

  @override
  String get mnemonicExportFinishCta => '我已安全保存';

  @override
  String get aboutPageReleaseDate => '发布日期';

  @override
  String get aboutPageBuildNumber => '构建版本';

  @override
  String get aboutPageCoreFeatures => '核心特性';

  @override
  String get aboutFeatureOnChainTitle => '链上存储';

  @override
  String get aboutFeatureOnChainDesc => 'SHA-256 哈希上链，永久不可篡改';

  @override
  String get aboutFeatureSecureTitle => '数据安全';

  @override
  String get aboutFeatureSecureDesc => '端到端加密，您掌握安全密钥';

  @override
  String get aboutFeatureSyncTitle => '即时同步';

  @override
  String get aboutFeatureSyncDesc => '多设备实时同步，随时随地访问';

  @override
  String get aboutFeatureControlTitle => '完全掌控';

  @override
  String get aboutFeatureControlDesc => '去中心化架构，数据完全属于您';

  @override
  String get aboutPageTechStack => '技术栈';

  @override
  String get aboutPageContactUs => '联系我们';

  @override
  String get aboutPageOfficialWebsite => '官方网站';

  @override
  String get aboutPageContactEmail => '联系邮箱';

  @override
  String get aboutPageOpenSource => '开源代码';

  @override
  String get aboutPageCreditsMadeWith => '用心呈现 ';

  @override
  String aboutPageCopyrightNotice(String yearBrand) {
    return '© $yearBrand。保留所有权利。';
  }

  @override
  String get walletManagement => '笔记账户管理';

  @override
  String get walletCannotDeleteSwitchFirst => '不能删除当前使用的笔记账户，请先切换';

  @override
  String get walletViewMnemonicCompleteBackupFirst => '请先完成恢复短语备份后再查看恢复短语或安全密钥';

  @override
  String get walletDemoPrimaryName => '我的主笔记账户';

  @override
  String get walletAddressListTitle => '笔记账户地址列表';

  @override
  String get copyAddressButton => '复制地址';

  @override
  String get labelCopied => '已复制';

  @override
  String get walletManagementDeleteIrreversible =>
      '此操作不可撤销。请确保您已经备份了恢复短语或安全密钥。';

  @override
  String get walletManagementDeleteWarningTitle => '警告：删除后无法恢复';

  @override
  String get walletManagementDeleteAssetsLoss =>
      '请确保您已经妥善保存了笔记账户的恢复短语或安全密钥，否则您的笔记将永久丢失。';

  @override
  String get walletCreateSystemDescription => '系统将为您生成一个新的笔记账户地址和恢复短语';

  @override
  String get walletCreateBackupReminderBody => '创建后请立即备份恢复短语，恢复短语是恢复笔记账户的唯一凭证。';

  @override
  String get walletCreateGenerateSubtitle => '生成新笔记账户';

  @override
  String get walletAddressCopied => '地址已复制';

  @override
  String get walletNameRequired => '笔记账户名称不能为空';

  @override
  String get walletNameUpdated => '笔记账户名称已更新';

  @override
  String get walletKeepAtLeastOne => '至少需要保留一个笔记账户';

  @override
  String get walletCannotDeleteCurrent => '不能删除当前使用的笔记账户';

  @override
  String get walletDeleted => '笔记账户已删除';

  @override
  String get walletCreated => '笔记账户创建成功';

  @override
  String get walletImportMnemonicOrKeyRequired => '请输入恢复短语或安全密钥';

  @override
  String get walletImportSuccess => '笔记账户恢复成功';

  @override
  String get walletImportedCannotViewMnemonic => '恢复的笔记账户无法查看恢复短语';

  @override
  String get walletMarkedBackedUp => '已标记为已备份';

  @override
  String get walletSwitched => '已切换笔记账户';

  @override
  String get viewMnemonic => '查看恢复短语';

  @override
  String get viewPrivateKey => '查看安全密钥';

  @override
  String get privateKeyExportSelectNetworkHint => '选择要查看的网络';

  @override
  String get privateKeyExportKeepKeySafeHint => '请妥善保管您的安全密钥';

  @override
  String get privateKeyExportSecurityWarningTitle => '安全警告';

  @override
  String get privateKeyExportWarnBullet1 => '安全密钥是管理笔记的最高权限凭证';

  @override
  String get privateKeyExportWarnBullet2 => '任何人获得安全密钥即可完全管理您的笔记';

  @override
  String get privateKeyExportWarnBullet3 => '请确保周围环境安全，无人窥视';

  @override
  String get privateKeyExportWarnBullet4 => '切勿截图、拍照或通过网络传输安全密钥';

  @override
  String get privateKeyExportSupportedNetworksTitle => '支持的网络';

  @override
  String privateKeyExportNetworkCount(int count) {
    return '$count 个网络';
  }

  @override
  String get privateKeyExportViewSafetyTitle => '安全密钥安全提示';

  @override
  String get privateKeyExportViewBullet1 => '确保周围环境安全，无人窥视屏幕';

  @override
  String get privateKeyExportViewBullet2 => '不要在公共场所或不安全的网络环境下查看';

  @override
  String get privateKeyExportViewBullet3 => '查看完毕后请尽快关闭此页面';

  @override
  String get privateKeyExportKeySectionTitle => '安全密钥';

  @override
  String get privateKeyExportBip44Hint =>
      'BIP44 以太坊路径派生的安全密钥在各 EVM 主网相同，仅网络名称不同。';

  @override
  String get privateKeyExportMaskedPlaceholder =>
      '0x•••••••••••••••••••••••••••••••••';

  @override
  String get privateKeyExportDoNotShareInline => '请勿将安全密钥告知任何人或通过网络传输';

  @override
  String privateKeyExportNetworkAddressLabel(String networkName) {
    return '$networkName 网络地址';
  }

  @override
  String get privateKeyExportImportantReminderTitle => '重要提醒';

  @override
  String get privateKeyExportReminderBullet1 => '拥有安全密钥 = 可完全管理该地址下的笔记';

  @override
  String get privateKeyExportReminderBullet2 => '安全密钥泄露将导致笔记永久丢失，无法找回';

  @override
  String get privateKeyExportReminderBullet3 => '官方团队永远不会要求您提供安全密钥';

  @override
  String get privateKeyExportReminderBullet4 => '建议使用恢复短语作为备份方式，而非安全密钥';

  @override
  String get privateKeyExportBackToList => '返回列表';

  @override
  String get privateKeyExportCopySecurityKey => '复制安全密钥';

  @override
  String get mnemonicManagePageTitle => '恢复短语管理';

  @override
  String get mnemonicManagePageSubtitle => '请妥善保管恢复短语，切勿泄露';

  @override
  String get mnemonicBackupFlowTitle => '备份恢复短语';

  @override
  String mnemonicBackupFlowStepProgress(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get mnemonicBackupFlowLoadFailed => '加载失败';

  @override
  String get mnemonicBackupFlowCTAUnderstoodStart => '我已了解，开始备份';

  @override
  String get mnemonicBackupFlowCTACopiedContinue => '我已抄写，继续验证';

  @override
  String get mnemonicBackupFlowCTAVerifiedContinue => '验证通过，继续';

  @override
  String get mnemonicBackupFlowCTAPleaseVerify => '请完成验证';

  @override
  String get mnemonicBackupFlowCTAFinish => '完成备份';

  @override
  String get mnemonicBackupFlowCTANext => '下一步';

  @override
  String get mnemonicBackupFlowFooterCopyHint => '请确保已经正确抄写所有恢复短语后再继续';

  @override
  String get mnemonicBackupFlowStep1Heading => '开始备份前';

  @override
  String get mnemonicBackupFlowStep1Subheading => '请仔细阅读以下安全提示';

  @override
  String get mnemonicBackupFlowSecurityTipsTitle => '重要安全提示';

  @override
  String get mnemonicBackupFlowSecurityTip1 => '恢复短语是恢复笔记账户的唯一凭证';

  @override
  String get mnemonicBackupFlowSecurityTip2 => '任何人获得恢复短语即可管理您的笔记';

  @override
  String get mnemonicBackupFlowSecurityTip3 => '丢失恢复短语将永久无法恢复笔记账户';

  @override
  String get mnemonicBackupFlowBackupAdviceTitle => '安全备份建议';

  @override
  String get mnemonicBackupFlowBackupAdvice1 => '将恢复短语写在纸上，存放在安全的地方';

  @override
  String get mnemonicBackupFlowBackupAdvice2 => '不要截图或保存在联网设备上';

  @override
  String get mnemonicBackupFlowBackupAdvice3 => '不要通过网络传输或分享给任何人';

  @override
  String get mnemonicBackupFlowBackupAdvice4 => '建议多处备份，分散保管';

  @override
  String get mnemonicBackupFlowProcessTitle => '备份流程';

  @override
  String get mnemonicBackupFlowProcess1 => '查看并抄写您的恢复短语';

  @override
  String get mnemonicBackupFlowProcess2 => '通过验证确认备份正确';

  @override
  String get mnemonicBackupFlowProcess3 => '完成备份，保护您的笔记安全';

  @override
  String get mnemonicBackupFlowYourMnemonicTitle => '您的恢复短语';

  @override
  String get mnemonicBackupFlowYourMnemonicSubtitle => '请按顺序抄写下来，妥善保管';

  @override
  String mnemonicBackupFlowWordCount(int count) {
    return '$count 个恢复短语';
  }

  @override
  String get mnemonicBackupFlowPleaseNoteTitle => '请注意';

  @override
  String get mnemonicBackupFlowStep2NoteBody =>
      '建议使用纸笔抄写恢复短语，而不是截图或复制到联网设备。点击眼睛图标可以显示/隐藏恢复短语。';

  @override
  String get mnemonicBackupFlowVerifyTitle => '验证恢复短语';

  @override
  String get mnemonicBackupFlowVerifySubtitle => '请选择正确的单词以确认您已正确备份';

  @override
  String mnemonicBackupFlowVerifyWordQuestion(int position) {
    return '第 $position 个单词是？';
  }

  @override
  String get mnemonicBackupFlowVerifySuccessTitle => '验证成功！';

  @override
  String get mnemonicBackupFlowVerifySuccessBody => '您已正确备份恢复短语';

  @override
  String get mnemonicBackupFlowDoneTitle => '备份完成！';

  @override
  String get mnemonicBackupFlowDoneSubtitle => '您的恢复短语已安全备份';

  @override
  String get mnemonicBackupFlowDoneSectionTitle => '已完成';

  @override
  String get mnemonicBackupFlowDoneCheck1 => '查看并抄写恢复短语';

  @override
  String get mnemonicBackupFlowDoneCheck2 => '通过验证测试';

  @override
  String get mnemonicBackupFlowDoneCheck3 => '恢复短语已安全保存';

  @override
  String get mnemonicBackupFlowDoneSecurityTitle => '安全提醒';

  @override
  String get mnemonicBackupFlowDoneSecurity1 => '请将恢复短语保存在安全的物理位置';

  @override
  String get mnemonicBackupFlowDoneSecurity2 => '切勿向任何人透露您的恢复短语';

  @override
  String get mnemonicBackupFlowDoneSecurity3 => '官方团队永远不会索要您的恢复短语';

  @override
  String get mnemonicBackupFlowDoneSecurity4 => '定期检查备份是否完整可读';

  @override
  String get mnemonicBackupFlowFinalEncouragementTitle => '现在您可以安心使用笔记账户了！';

  @override
  String get mnemonicBackupFlowFinalEncouragementBody => '您的笔记受到恢复短语的保护';

  @override
  String get switchWallet => '切换';

  @override
  String get viewAddresses => '查看地址';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get createWallet => '创建笔记账户';

  @override
  String get importWallet => '恢复笔记账户';

  @override
  String get mnemonicOrPrivateKey => '恢复短语或安全密钥';

  @override
  String get close => '关闭';

  @override
  String get copy => '复制';

  @override
  String get mnemonicCopied => '恢复短语已复制';

  @override
  String get privateKeyCopied => '安全密钥已复制';

  @override
  String get backedUp => '已备份';

  @override
  String get editWalletName => '编辑笔记账户名称';

  @override
  String get deleteWallet => '删除笔记账户';

  @override
  String get confirmDeleteWallet => '确认删除笔记账户';

  @override
  String get newWalletCreated => '新笔记账户已创建';

  @override
  String get cannotDeleteCurrentWallet => '无法删除当前使用的笔记账户';

  @override
  String get edit => '编辑';

  @override
  String get createNewWallet => '创建新笔记账户';

  @override
  String get editWalletNameTitle => '修改笔记账户名称';

  @override
  String get noteNotFoundBack => '笔记不存在，返回';

  @override
  String get createNoteNotImplemented => '创建笔记（待实现）';

  @override
  String get newWalletCreateSuccess => '新笔记账户创建成功！';

  @override
  String restoringFromProvider(String provider) {
    return '正在从$provider恢复笔记账户...';
  }

  @override
  String restoredFromProvider(String provider) {
    return '已从$provider恢复笔记账户！';
  }

  @override
  String noBackupFoundProvider(String provider) {
    return '未找到$provider备份，请尝试其他方式';
  }

  @override
  String get walletAddressCopiedShort => '笔记账户地址已复制';

  @override
  String switchedToChain(String chain) {
    return '已切换到 $chain';
  }

  @override
  String get fillAllFields => '请填写完整信息';

  @override
  String get passwordMismatch => '两次输入的新密码不一致';

  @override
  String get passwordMinLength => '密码长度至少6位';

  @override
  String get passwordChangeSuccess => '密码修改成功';

  @override
  String get enterValidEmail => '请输入有效的邮箱地址';

  @override
  String get verificationCodeSent => '验证码已发送';

  @override
  String get enterSixDigitCode => '请输入6位验证码';

  @override
  String get emailBindSuccess => '邮箱绑定成功';

  @override
  String get emailUnbound => '邮箱已解绑';

  @override
  String get logoutNotConnected => '退出登录（待接入）';

  @override
  String get changePassword => '修改密码';

  @override
  String get confirm => '确认';

  @override
  String get bindEmail => '绑定邮箱';

  @override
  String get editNoteOpenByRoute => '请通过路由打开编辑页';

  @override
  String get imageUploadNotConnected => '图片上传待接入存储服务';

  @override
  String get imageRemoved => '图片已移除';

  @override
  String get titleContentRequired => '标题和内容不能为空';

  @override
  String get submittedToChain => '已提交上链';

  @override
  String get onChainNoteCannotChangeType => '已上链的笔记无法更改类型';

  @override
  String get setToLocalNote => '已设置为本地笔记（不会上链）';

  @override
  String get setToDraft => '已设置为草稿';

  @override
  String get editNote => '编辑笔记';

  @override
  String get noteDetailEditDisabledOnChain => '已上链不可编辑';

  @override
  String get noteTypeDraft => '草稿';

  @override
  String get noteTypeLocal => '本地';

  @override
  String get noteTypeOnChain => '已上链';

  @override
  String get blockchainVerify => '验证区块链';

  @override
  String get blockchainVerifyTitle => '区块链验证';

  @override
  String getGas(String symbol) {
    return '获取 $symbol 燃料费';
  }

  @override
  String get addressCopied => '地址已复制';

  @override
  String get redirectingToFaucet => '正在跳转到水龙头网站';

  @override
  String get noFaucetForNetwork => '该网络暂无水龙头';

  @override
  String get loginNotImplemented => '登录功能待实现';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get forgotPasswordNotImplemented => '忘记密码功能待实现';

  @override
  String get noAccountYet => '还没有笔记账户？';

  @override
  String get registerNotImplemented => '注册功能待实现';

  @override
  String get registerNow => '立即注册';

  @override
  String get mnemonicVerifySuccess => '恢复短语校验通过，导入逻辑由外部实现';

  @override
  String get privateKeyVerifySuccess => '安全密钥校验通过，导入逻辑由外部实现';

  @override
  String get importSuccess => '笔记账户恢复成功！';

  @override
  String get cleared => '已清空';

  @override
  String get back => '返回';

  @override
  String get current => '当前';

  @override
  String get imported => '已恢复';

  @override
  String get defaultBadge => '默认';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get searchNotesHint => '搜索笔记...';

  @override
  String get noMatchNotes => '未找到匹配的笔记';

  @override
  String get noOnChainNotes => '暂无已上链的笔记';

  @override
  String get noOffChainNotes => '暂无未上链的笔记';

  @override
  String get noNotes => '暂无笔记';

  @override
  String get tryOtherSearch => '试试其他搜索词';

  @override
  String get startCreateFirstNote => '开始创建您的第一篇笔记';

  @override
  String get profileNotConnected => '未连接';

  @override
  String get profileSectionAccount => '笔记账户管理';

  @override
  String get profileNetworkSettingsSubtitle => '配置 RPC 与节点';

  @override
  String get profileSectionSecurity => '安全';

  @override
  String get profileChangePasswordSubtitle => '保护您的笔记账户安全';

  @override
  String get profileBindEmailNotBound => '未绑定';

  @override
  String get profileBindEmailBadgeBound => '已绑定';

  @override
  String get profileSectionPreferences => '偏好设置';

  @override
  String get profileNotifications => '通知提醒';

  @override
  String get profileDarkMode => '深色模式';

  @override
  String get profileLanguage => '语言';

  @override
  String get profileSectionMore => '更多';

  @override
  String get profileTestPage => '测试页面';

  @override
  String get profileTestPageSubtitle => '功能测试入口';

  @override
  String get profileTerms => '服务条款';

  @override
  String get profilePrivacy => '隐私政策';

  @override
  String get profileRateUs => '给我们评分';

  @override
  String get profileShare => '分享给朋友';

  @override
  String profileShareMessage(String url) {
    return '我正在使用这款链上笔记 App，推荐给你：\n$url';
  }

  @override
  String get profileLogoutLabel => '退出登录';

  @override
  String get profileLogoutPending => '退出登录（待接入）';

  @override
  String profilePageFooter(String appTitle, String version, String year) {
    return '$appTitle v$version\n© $year 保留所有权利。';
  }

  @override
  String get profileAvatarFallback => 'ME';

  @override
  String get profileDefaultWalletName => '我的笔记账户';

  @override
  String get profileUserActive => '活跃用户';

  @override
  String get profileUserNormal => '普通用户';

  @override
  String get profileStatNotes => '笔记数';

  @override
  String get profileStatOnChain => '已上链';

  @override
  String get profileStatDays => '天数';

  @override
  String get profileBindEmailDialogSubtitle => '请填写您的邮箱地址并获取验证码。';

  @override
  String get profileBindEmailFieldEmail => '邮箱地址';

  @override
  String get profileBindEmailFieldCode => '验证码';

  @override
  String get profileSendVerificationCode => '发送验证码';

  @override
  String profileResendCodeInSeconds(int seconds) {
    return '$seconds 秒后可重发';
  }

  @override
  String get profileUnbindEmail => '解绑邮箱';

  @override
  String get languageSelectTitle => '选择语言';

  @override
  String get languageSelectSubtitle => '选择您偏好的界面语言';

  @override
  String get languageNoticeHint => '提示：';

  @override
  String get languageNoticeBody => '已支持简体中文、繁体中文、英语、日语与韩语；其余语言敬请期待。';

  @override
  String get languageCurrentBadge => '当前';

  @override
  String get languageSnackbarComingSoon => '敬请期待';

  @override
  String languageSwitchedTo(String name) {
    return '语言已切换至 $name';
  }

  @override
  String get languageFooterMore => '更多语言即将支持';

  @override
  String get changePasswordSameAsOld => '新密码不能与旧密码相同';

  @override
  String get changePasswordLength632 => '新密码长度为 6-32 位';

  @override
  String get walletNoSavedKey => '未找到已保存的密钥，请先创建笔记账户';

  @override
  String get changePasswordWrongOrFailed => '旧密码错误或操作失败';

  @override
  String get passwordMaxLength32 => '密码长度最多为 32 位';

  @override
  String get passwordMeetAllRequirements => '请满足所有密码要求';

  @override
  String encryptionInitFailed(String error) {
    return '加密初始化失败：$error';
  }

  @override
  String get passwordVerifyForgotGoReset => '忘记密码？去重置密码';

  @override
  String get passwordStrengthWeak => '弱';

  @override
  String get passwordStrengthMedium => '中等';

  @override
  String get passwordStrengthStrong => '强';

  @override
  String get changePasswordPageTitle => '修改密码';

  @override
  String get changePasswordPageSubtitle => '保护您的笔记账户安全';

  @override
  String get changePasswordSecurityHintTitle => '安全提示';

  @override
  String get changePasswordSecurityHintBody =>
      '• 定期修改密码可以提高笔记账户安全性\n• 请使用强密码，包含字母、数字和符号\n• 不要使用生日、电话等容易被猜到的密码';

  @override
  String get changePasswordOldLabel => '旧密码';

  @override
  String get changePasswordOldHint => '请输入旧密码';

  @override
  String get changePasswordNewLabel => '新密码';

  @override
  String get changePasswordNewHint => '请输入新密码';

  @override
  String get changePasswordStrengthLabel => '密码强度：';

  @override
  String get changePasswordMatchOk => '密码一致';

  @override
  String get changePasswordMatchBad => '密码不一致';

  @override
  String get changePasswordConfirmLabel => '确认新密码';

  @override
  String get changePasswordConfirmHint => '请再次输入新密码';

  @override
  String get changePasswordRuleLength => '6-32 个字符';

  @override
  String get changePasswordRuleCase => '包含大小写字母';

  @override
  String get changePasswordRuleDigit => '包含数字';

  @override
  String get changePasswordClear => '清空';

  @override
  String get changePasswordSubmit => '确认修改';

  @override
  String get validatorOldPasswordRequired => '请输入旧密码';

  @override
  String get validatorNewPasswordRequired => '请输入新密码';

  @override
  String get validatorNewPasswordMin6 => '至少6个字符';

  @override
  String get validatorNewPasswordMax32 => '最多32个字符';

  @override
  String get validatorConfirmRequired => '请确认新密码';

  @override
  String get validatorConfirmMismatch => '两次输入不一致';

  @override
  String get changePasswordRulesTitle => '密码要求';

  @override
  String get loginWelcomeTitle => '欢迎回来';

  @override
  String get loginSubtitle => '请登录您的笔记账户';

  @override
  String get loginEmailOrUsernameLabel => '邮箱或用户名';

  @override
  String get loginEmailOrUsernameHint => '请输入您的邮箱或用户名';

  @override
  String get validatorLoginIdRequired => '请输入邮箱或用户名';

  @override
  String get loginPasswordFieldLabel => '密码';

  @override
  String get loginPasswordFieldHint => '请输入您的密码';

  @override
  String get validatorLoginPasswordRequired => '请输入密码';

  @override
  String get validatorLoginPasswordMin6 => '密码长度至少为6位';

  @override
  String get loginButton => '登录';

  @override
  String get createWalletPasswordPageTitle => '设置笔记账户密码';

  @override
  String get createWalletPasswordSubtitle => '保护您的笔记安全';

  @override
  String get createWalletPasswordWhyTitle => '为什么需要密码？';

  @override
  String get createWalletPasswordWhyBody =>
      '笔记账户密码用于加密您的安全密钥和恢复短语，确保只有您能访问您的笔记。请务必牢记此密码，遗失后无法找回。';

  @override
  String get walletPasswordFieldLabel => '笔记账户密码';

  @override
  String get walletPasswordFieldHint => '请输入6-32位密码';

  @override
  String get walletConfirmPasswordFieldLabel => '确认密码';

  @override
  String get walletConfirmPasswordFieldHint => '请再次输入密码';

  @override
  String get walletPasswordImportantNotice => '重要提示';

  @override
  String get walletPasswordWarnBullets =>
      '• 密码用于保护您的笔记账户安全\n• 请使用容易记住但难以猜测的密码\n• 建议混合使用字母、数字和符号\n• 密码遗失后无法找回，请务必牢记';

  @override
  String get createWalletPasswordSubmitCreate => '确认并创建笔记账户';

  @override
  String get createWalletPasswordSubmitReset => '确认并重置密码';

  @override
  String get createWalletPasswordFooterAck => '点击确认即表示您已了解密码的重要性';

  @override
  String get walletPasswordRulesHeader => '密码要求：';

  @override
  String get walletPasswordRuleLength632 => '6-32位字符';

  @override
  String get walletPasswordRuleLetter => '包含字母';

  @override
  String get walletPasswordRuleNumberRecommended => '包含数字（推荐）';

  @override
  String get walletPasswordRuleMatch => '两次密码一致';

  @override
  String get walletBootstrapImporting => '恢复笔记账户...';

  @override
  String get walletBootstrapInitializing => '初始化笔记账户...';

  @override
  String get passwordVerifyTitle => '验证密码';

  @override
  String get passwordVerifyDescription => '为了您的安全，请输入笔记账户密码以继续操作';

  @override
  String get passwordVerifyDescExportMnemonic => '查看并导出恢复短语前，请输入笔记账户密码';

  @override
  String get passwordVerifyDescExportPrivateKey => '查看安全密钥前，请输入笔记账户密码';

  @override
  String get passwordVerifyDescImportWallet => '恢复笔记账户前请验证您的笔记账户密码';

  @override
  String get passwordVerifyDescBackupMnemonic => '备份恢复短语前，请输入笔记账户密码';

  @override
  String get passwordVerifyDescCreateWallet => '创建笔记账户前请验证您的笔记账户密码';

  @override
  String get passwordVerifyDescDeleteWallet => '删除笔记账户前请验证您的笔记账户密码';

  @override
  String get passwordVerifyDescMintNft => '铸造 NFT 需要验证笔记账户密码';

  @override
  String get passwordVerifyWalletPasswordLabel => '笔记账户密码';

  @override
  String get passwordVerifyWalletPasswordHint => '请输入笔记账户密码';

  @override
  String get validatorWalletPasswordRequired => '请输入密码';

  @override
  String get passwordVerifyNoEncryptedData => '未找到加密数据，请重新设置密码';

  @override
  String passwordVerifyFailedWithError(String error) {
    return '验证失败：$error';
  }

  @override
  String passwordVerifyLockoutMinutes(int minutes) {
    return '密码错误次数过多，请在 $minutes 分钟后重试';
  }

  @override
  String passwordVerifyLockoutHours(int hours) {
    return '密码错误次数过多，请在 $hours 小时后重试';
  }

  @override
  String passwordVerifyWrongWithCount(int current, int max) {
    return '密码错误（$current/$max）';
  }

  @override
  String passwordVerifyAttemptsBanner(int count, int remaining) {
    return '密码错误 $count 次，剩余 $remaining 次机会';
  }

  @override
  String passwordVerifyLockBanner(String time) {
    return '密码错误次数过多，请在 $time 后重试';
  }

  @override
  String passwordVerifyDurationHoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分钟';
  }

  @override
  String passwordVerifyDurationMinutes(int minutes) {
    return '$minutes分钟';
  }

  @override
  String get passwordVerifySecurityTipsTitle => '安全提示';

  @override
  String passwordVerifySecurityTipsBody(int maxAttempts) {
    return '• 密码长度为 6-32 位\n• 请确保周围环境安全\n• 密码错误 $maxAttempts 次将临时锁定';
  }

  @override
  String get paste => '粘贴';

  @override
  String get loadingDefault => '加载中…';

  @override
  String get walletLoadingTagline => 'BlockNote · 安全 · 可信 · 永久';

  @override
  String get walletLoadingStepConnecting => '连接区块链网络…';

  @override
  String get walletLoadingStepVerifying => '验证笔记账户信息…';

  @override
  String get walletLoadingStepSyncing => '同步笔记数据…';

  @override
  String get walletLoadingStepComplete => '加载完成！';

  @override
  String get retry => '重试';

  @override
  String loadFailedWithError(String error) {
    return '加载失败：$error';
  }

  @override
  String get selectEvmChainFirst => '请先选择支持 EVM 的网络';

  @override
  String get noteNotFoundShort => '笔记不存在';

  @override
  String get createOrSelectWalletFirst => '请先创建或选择笔记账户';

  @override
  String get privateKeyDecryptFailedHint =>
      '获取安全密钥失败，请确认密码正确。若曾更换过密码，请重新导入恢复短语';

  @override
  String get uploadingIpfsAndMinting => '上传至 IPFS 并铸造中…';

  @override
  String ipfsFileUploadFailed(String details) {
    return 'IPFS 文件上传失败：$details';
  }

  @override
  String onChainSuccessTx(String txHash) {
    return '上链成功：$txHash';
  }

  @override
  String get draftSavedIpfsRetry => '已保存为草稿并替换为 IPFS 图片，稍后可直接重试上链';

  @override
  String mintFailedGasDebug(String detail) {
    return '余额不足（Gas）\n$detail';
  }

  @override
  String get mintFailedGasUser => '余额不足，无法支付 Gas，请充值后再试';

  @override
  String mintFailedGeneric(String error) {
    return '上链失败：$error';
  }

  @override
  String get walletErrNoWalletYet => '请先创建或恢复笔记账户';

  @override
  String get walletErrUnrecognizedAccount => '无法识别当前笔记账户';

  @override
  String get walletErrWalletDataNotFound => '未找到当前笔记账户数据';

  @override
  String get walletErrImportedMnemonicNoExport => '恢复短语导入的笔记账户无法在此再次导出恢复短语';

  @override
  String get walletErrImportedMnemonicNoBackup => '恢复短语导入的笔记账户无需在此备份';

  @override
  String get walletErrPrivateKeyWalletNoMnemonic => '安全密钥导入的笔记账户不包含恢复短语';

  @override
  String get walletErrNoEncryptedMnemonic => '当前笔记账户无本地加密的恢复短语数据';

  @override
  String get walletErrDecryptFailed => '解密失败，请确认密码正确';

  @override
  String get walletErrMissingAddress => '缺少笔记账户地址';

  @override
  String get walletErrGetPrivateKeyFailed => '获取安全密钥失败，请确认密码正确';

  @override
  String get exportMnemonicDocTitle => '链上笔记 — 恢复短语备份';

  @override
  String exportMnemonicDocTime(String time) {
    return '生成时间：$time';
  }

  @override
  String get exportMnemonicDocLabel => '恢复短语（请妥善保管）：';

  @override
  String get exportMnemonicDocSecurity =>
      '⚠️ 安全提示：\n1. 请将此恢复短语保存在安全的地方\n2. 不要与任何人分享\n3. 丢失恢复短语将无法恢复您的笔记账户与数据';

  @override
  String get exportMnemonicUseCopyOnPlatform => '当前平台请使用复制';

  @override
  String exportMnemonicSavedTo(String path) {
    return '已保存：$path';
  }

  @override
  String get walletBootstrapCreating => '创建笔记账户中…';

  @override
  String get chainNameEvm => 'EVM 链（Ethereum/BSC/Polygon 等）';

  @override
  String get chainPkDescEvm => '以 0x 开头的 64 位十六进制字符串，总长度 66 个字符';

  @override
  String get chainNameBitcoin => 'Bitcoin';

  @override
  String get chainPkDescBitcoin => 'WIF 格式，以 5、K 或 L 开头，长度 51–52 个字符';

  @override
  String get chainNameSolana => 'Solana';

  @override
  String get chainPkDescSolana => 'Base58 编码，长度约 87–88 个字符，不含 0、O、I、l';

  @override
  String get chainNameTron => 'Tron';

  @override
  String get chainPkDescTronHex => '64 位十六进制字符串（不含 0x 前缀）';

  @override
  String get chainNameCosmos => 'Cosmos';

  @override
  String get chainPkDescCosmosHex => '64 位十六进制字符串（不含 0x 前缀）';

  @override
  String walletPkSubtitleLength(int count) {
    return '$count 位字符';
  }

  @override
  String walletPkSubtitleStartsWith(String prefix) {
    return '以 $prefix 开头';
  }

  @override
  String get walletImportSelectChainTitle => '选择区块链类型';

  @override
  String get walletImportEvmOnlyNotice => '暂不支持，请使用 EVM 链安全密钥导入';

  @override
  String get walletImportPageSubtitle => '使用恢复短语或安全密钥恢复笔记账户';

  @override
  String get walletImportTabMnemonic => '恢复短语';

  @override
  String get walletImportTabPrivateKey => '安全密钥';

  @override
  String get walletImportInputMethod => '输入方式';

  @override
  String get walletImportInputSingle => '单个输入';

  @override
  String get walletImportInputPasteFull => '整句粘贴';

  @override
  String get walletImportWordCountLabel => '恢复短语数量';

  @override
  String walletImportWordCountN(int n) {
    return '$n 个词';
  }

  @override
  String get walletImportWordCountDialogTitle => '选择助记词数量';

  @override
  String get walletImportWordCountDialogDesc => 'BIP39标准支持多种助记词长度，安全性随词数增加而提升';

  @override
  String walletImportWordCountOptionLabel(int count) {
    return '$count个助记词';
  }

  @override
  String get walletImportWordCountSecurityLabel => '安全级别：';

  @override
  String get walletImportWordCountSecurityStandard => '标准';

  @override
  String get walletImportWordCountSecurityEnhanced => '增强';

  @override
  String get walletImportWordCountSecurityAdvanced => '高级';

  @override
  String get walletImportWordCountSecurityProfessional => '专业';

  @override
  String get walletImportWordCountSecurityMaximum => '极高';

  @override
  String walletImportWordCountSwitched(int n) {
    return '已切换到$n个词';
  }

  @override
  String get walletImportWordCountDialogTip =>
      '大多数钱包使用12个词的助记词。如果您不确定，请选择12个词。';

  @override
  String get walletImportEnterMnemonic => '请输入恢复短语';

  @override
  String get walletImportMnemonicPasteTip => '提示：支持直接粘贴整句恢复短语，请使用上方「整句粘贴」模式';

  @override
  String get walletImportPasteMnemonicPrompt => '请粘贴恢复短语';

  @override
  String walletImportMnemonicHintWords(int count) {
    return '请粘贴您的 $count 个恢复短语，用空格分隔';
  }

  @override
  String get walletImportMnemonicWordFieldHint => '单词';

  @override
  String get walletImportMnemonicParagraphExampleHint =>
      'word1 word2 word3 ...';

  @override
  String get walletImportPrivateKeyFieldHint => '0x... 或 64 位十六进制';

  @override
  String get walletImportPrivateKeyFieldHintShort => '0x...';

  @override
  String walletImportWordProgress(int current, int total) {
    return '当前词数：$current / $total';
  }

  @override
  String get walletImportMnemonicSecurityTitle => '安全提示';

  @override
  String get walletImportMnemonicSecurityBody =>
      '• 请确保在安全的网络环境中操作\n• 恢复短语一旦丢失将无法找回\n• 切勿向他人透露您的恢复短语\n• 我们不会在服务器上存储您的恢复短语';

  @override
  String get walletImportSelectChainSection => '选择区块链类型';

  @override
  String get walletImportTapSwitchChain => '点击切换链类型';

  @override
  String get walletImportEnterPrivateKey => '请输入安全密钥';

  @override
  String get walletImportPkFormatExample => '安全密钥格式示例';

  @override
  String get walletImportPkSevereTitle => '严重警告';

  @override
  String get walletImportPkSevereBody =>
      '• 安全密钥是您笔记账户的最高权限凭证\n• 任何人获得安全密钥即可完全管理您的笔记\n• 请勿在不安全的设备上输入安全密钥\n• 请勿截图或通过聊天软件发送安全密钥';

  @override
  String get walletImportConfirm => '确认恢复';

  @override
  String walletImportMnemonicNeedCount(int count) {
    return '请输入完整的 $count 个恢复短语';
  }

  @override
  String walletImportMnemonicWrongCount(int count, int current) {
    return '请输入完整的 $count 个恢复短语，当前为 $current 个';
  }

  @override
  String get walletImportMnemonicInvalidWords => '恢复短语格式不正确，应为小写英文单词';

  @override
  String get walletImportPkEmpty => '请输入安全密钥';

  @override
  String get walletImportPkNeed0x => '安全密钥应以 0x 开头';

  @override
  String get walletImportPkNeedWif => '安全密钥应以 5、K 或 L 开头';

  @override
  String get walletImportPkWifLength => '安全密钥长度应为 51–52 个字符';

  @override
  String walletImportPkLengthExpected(int length) {
    return '安全密钥长度不正确（应为 $length 位字符）';
  }

  @override
  String get walletImportPkInvalidFormat => '安全密钥格式不正确';

  @override
  String get walletImportEvmOnly => '当前仅支持 EVM 安全密钥导入';

  @override
  String get walletImportDeriveAddressFailed => '无法从安全密钥推导地址，请检查格式';

  @override
  String get walletImportDuplicatePk => '该安全密钥对应的地址已存在，请勿重复恢复';

  @override
  String get walletImportDuplicateMnemonic => '该恢复短语对应笔记账户已恢复，请勿重复恢复';

  @override
  String get walletImportInvalidPrivateKeyRetry => '安全密钥无效，请检查后重试';

  @override
  String get walletImportInvalidMnemonicRetry => '恢复短语无效，请检查后重试';

  @override
  String get clipboardEmpty => '剪贴板为空';

  @override
  String get mnemonicViewLengthTitle => '恢复短语长度';

  @override
  String get mnemonicViewInputMode => '输入方式';

  @override
  String get mnemonicViewSingleWord => '单个输入';

  @override
  String get mnemonicViewFullPaste => '整段粘贴';

  @override
  String get mnemonicViewImportCta => '使用恢复短语';

  @override
  String mnemonicViewEnterOrdered(int count) {
    return '请按顺序输入 $count 个恢复短语';
  }

  @override
  String get mnemonicViewPasteHint => '请粘贴完整恢复短语，词与词之间用空格分隔';

  @override
  String mnemonicCountMismatch(int expected, int current) {
    return '请输入 $expected 个恢复短语，当前为 $current 个';
  }

  @override
  String get mnemonicInvalidBip39 => '无效的恢复短语，请检查拼写';

  @override
  String get walletSelectorTitle => '我的笔记账户';

  @override
  String get walletSelectorSubtitle => '管理您的所有笔记账户';

  @override
  String walletNumberedName(int n) {
    return '笔记账户 $n';
  }

  @override
  String get walletDefaultCreatedNameFirst => '我的笔记账户';

  @override
  String walletDefaultCreatedNameNumbered(int n) {
    return '我的笔记账户$n';
  }

  @override
  String get walletDefaultPrivateKeyNameFirst => '我的安全密钥笔记账户';

  @override
  String walletDefaultPrivateKeyNameNumbered(int n) {
    return '我的安全密钥笔记账户$n';
  }

  @override
  String get walletBackupNotYet => '尚未备份笔记账户';

  @override
  String get walletBackupPromptLine1 => '尚未备份笔记账户';

  @override
  String get walletBackupPromptLine2 => '点击立即备份恢复短语';

  @override
  String get walletDeleteConfirmTitle => '确认删除笔记账户';

  @override
  String get walletDeleteConfirmLine1 => '删除后将无法恢复此笔记账户，请确保您已备份恢复短语。';

  @override
  String get walletDeleteConfirmLine2Notes => '该笔记账户关联的本地笔记数据也将一并删除。';

  @override
  String get walletDeleteCannotCurrent => '⚠️ 无法删除当前使用的笔记账户';

  @override
  String get walletDeleteLastHint => '删除后将无笔记账户，将返回引导页重新创建或恢复。';

  @override
  String get walletEditNameSubtitle => '为您的笔记账户设置一个易于识别的名称';

  @override
  String get walletNameFieldLabel => '笔记账户名称';

  @override
  String get walletNameFieldHint => '输入笔记账户名称';

  @override
  String get networkNodeAdd => '添加节点';

  @override
  String get networkNodeTest => '测试';

  @override
  String get networkNodeSetDefault => '设为默认';

  @override
  String get networkNodeOnline => '在线';

  @override
  String get networkNodeOffline => '离线';

  @override
  String get networkNodeConnectionFailed => '节点连接失败';

  @override
  String get networkRpcUrlInvalid => '请输入有效的 HTTP 或 HTTPS RPC URL';

  @override
  String get networkNodeDuplicate => '该节点已存在';

  @override
  String get networkNodeNameRpcRequired => '请输入节点名称和 RPC URL';

  @override
  String get networkNodeAdded => '节点添加成功';

  @override
  String get networkRpcCopied => 'RPC URL 已复制';

  @override
  String get networkNodeSwitched => '已切换到该节点';

  @override
  String get networkNodeDeleted => '节点已删除';

  @override
  String get networkSettingsTitle => '网络设置';

  @override
  String get networkSettingsSubtitle => '配置区块链网络节点';

  @override
  String networkLoadFailed(String message) {
    return '加载失败：$message';
  }

  @override
  String get networkSectionMainnet => '主网';

  @override
  String get networkSectionTestnet => '测试网络';

  @override
  String get networkTestnetListHint =>
      '应用内数据源（ChainDatas）中标记为 testnet 的网络均会出现在此列表。';

  @override
  String networkCountNetworks(int count) {
    return '$count 个网络';
  }

  @override
  String get networkAboutNodesTitle => '关于网络节点';

  @override
  String get networkAboutNodesBullet1 => 'RPC 节点是连接区块链网络的入口';

  @override
  String get networkAboutNodesBullet2 => '您可以添加自定义节点以提高速度或可靠性';

  @override
  String get networkAboutNodesBullet3 => '建议使用知名的公共节点或自建节点';

  @override
  String get networkStatusConnectionOk => '连接正常';

  @override
  String get networkStatusConnectionError => '连接异常';

  @override
  String get networkStatusCustomized => '已自定义';

  @override
  String networkNodeCountLabel(int count) {
    return '$count 个节点';
  }

  @override
  String networkAllNodesTitle(int count) {
    return '所有节点（$count）';
  }

  @override
  String networkDetailHeaderNodeCount(int count) {
    return '共有 $count 个节点';
  }

  @override
  String get networkQuickAddTitle => '快速添加节点';

  @override
  String get networkQuickAddLine1 => '点击任意网络进入详情页，即可添加自定义 RPC 节点。';

  @override
  String get networkQuickAddLine2 => '支持添加多个节点，系统会保留列表供后续扩展（如优选最快节点）。';

  @override
  String get networkNodeProbeOk => '节点连接正常';

  @override
  String networkNodeProbeOkLatency(int ms) {
    return '节点连接正常，延迟 $ms ms';
  }

  @override
  String get networkCurrentNodeTitle => '当前使用的节点';

  @override
  String get networkNodeActiveBadge => '活跃';

  @override
  String get networkNoNodeSelected => '未选择节点';

  @override
  String networkNodeLatencyMs(int ms) {
    return '延迟 $ms ms';
  }

  @override
  String get networkAddRpcDialogTitle => '添加 RPC 节点';

  @override
  String networkAddRpcDialogSubtitle(String networkName) {
    return '为 $networkName 网络添加自定义 RPC 节点';
  }

  @override
  String get networkNodeNameLabel => '节点名称';

  @override
  String get networkNodeNameHint => '例如：自定义节点 1';

  @override
  String get networkRpcUrlLabel => 'RPC URL';

  @override
  String get networkRpcUrlHint => 'https://…';

  @override
  String get networkExampleRpcLabel => '示例 RPC URL';

  @override
  String get networkConfirmAddNode => '确认添加';

  @override
  String get networkTipsTitle => '使用提示';

  @override
  String get networkTipsLine1 => '建议添加多个节点作为备份';

  @override
  String get networkTipsLine2 => '测试节点以查看连接状态和延迟';

  @override
  String get networkTipsLine3 => '选择延迟低的节点可提高交易速度';

  @override
  String get networkTipsLine4 => '默认节点（预设）不可删除';

  @override
  String get networkNodeInUseBadge => '使用中';

  @override
  String get networkCannotDeleteDefaultNode => '默认节点不能删除';

  @override
  String get networkDeleteSwitchNodeFirst => '请先切换到其他节点再删除';

  @override
  String homeFiatApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String homeUnitPrice(String price) {
    return '单价：$price';
  }

  @override
  String get homeUnitPriceUnavailable => '单价：--';

  @override
  String get homeTransactionHistory => '创建笔记记录';

  @override
  String get homeTransactionHistoryNotConfigured => '创建笔记记录功能未配置';

  @override
  String get transactionHistorySubtitle => '查看您的所有创建笔记记录';

  @override
  String get transactionHistoryStatTotal => '总计';

  @override
  String get transactionHistoryStatSuccess => '成功';

  @override
  String get transactionHistoryStatPending => '待确认';

  @override
  String get transactionHistoryStatFailed => '失败';

  @override
  String get transactionHistoryFilterAll => '全部';

  @override
  String get transactionHistoryFilterSend => '创建笔记';

  @override
  String get transactionHistoryFilterReceive => '接收';

  @override
  String get transactionHistorySelectChain => '选择网络';

  @override
  String get transactionHistoryCopied => '已复制到剪贴板';

  @override
  String get transactionHistoryExplorerInvalidUrl => '无效的浏览器链接';

  @override
  String get transactionHistoryExplorerLaunchFailed => '无法打开浏览器，请检查系统设置';

  @override
  String transactionHistoryExplorerOpenError(String error) {
    return '打开失败：$error';
  }

  @override
  String get transactionHistoryRefreshed => '创建笔记记录已更新';

  @override
  String get transactionHistoryTimeJustNow => '刚刚';

  @override
  String transactionHistoryTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分钟前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count小时前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count天前',
    );
    return '$_temp0';
  }

  @override
  String get transactionHistoryEmptyTitle => '暂无创建笔记记录';

  @override
  String get transactionHistoryEmptyHintFiltered => '没有找到匹配的创建笔记记录';

  @override
  String get transactionHistoryEmptyHintAll => '当前没有任何创建笔记记录';

  @override
  String get transactionHistoryTypeSend => '创建笔记';

  @override
  String get transactionHistoryTypeReceive => '接收';

  @override
  String get transactionHistoryStatusSuccess => '成功';

  @override
  String get transactionHistoryStatusFailed => '失败';

  @override
  String get transactionHistoryStatusPending => '待确认';

  @override
  String get transactionHistoryDetailFrom => '发送方';

  @override
  String get transactionHistoryDetailTo => '接收方';

  @override
  String get transactionHistoryDetailTxHash => '上链哈希';

  @override
  String get transactionHistoryDetailBlock => '区块高度';

  @override
  String transactionHistoryGasLine(String fee, String symbol) {
    return 'Gas: $fee $symbol';
  }

  @override
  String homeGasBalanceTitle(String symbol) {
    return '$symbol 燃料费余额';
  }

  @override
  String get homeTotalAssets => '总余额';

  @override
  String get homeRefreshBalance => '刷新余额';

  @override
  String get homeGetGas => '获取燃料费';

  @override
  String get homeGasHelp => '燃料费用于支付交易上链的 Gas 费用，请确保余额充足';

  @override
  String getGasDialogTitle(String symbol) {
    return '获取 $symbol 燃料费';
  }

  @override
  String getGasDialogSubtitle(String chainName) {
    return '选择一种方式为您的 $chainName 笔记账户充值';
  }

  @override
  String get getGasOptionReceiveTitle => '接收代币';

  @override
  String get getGasBadgeRecommended => '推荐';

  @override
  String getGasReceiveHint(String symbol) {
    return '从其他笔记账户或交易所转入 $symbol';
  }

  @override
  String get getGasWalletAddressLabel => '笔记账户地址';

  @override
  String get getGasShowQr => '二维码';

  @override
  String get getGasHideQr => '隐藏';

  @override
  String getGasTransferWarning(String chainName) {
    return '请确保转账网络为 $chainName，否则笔记可能丢失';
  }

  @override
  String get getGasFaucetTitle => '测试网水龙头';

  @override
  String get getGasBadgeFree => '免费';

  @override
  String getGasFaucetHint(String symbol) {
    return '从水龙头免费领取测试网 $symbol';
  }

  @override
  String getGasFaucetOpen(int index) {
    return '跳转到水龙头网址 $index';
  }

  @override
  String get getGasBuyExchangeTitle => '从交易所购买';

  @override
  String get getGasBadgeComingSoon => '即将推出';

  @override
  String getGasBuyExchangeHint(String symbol) {
    return '通过交易所购买 $symbol 并提现到笔记账户';
  }

  @override
  String get getGasDialogCancel => '取消';

  @override
  String get getGasAddressCopied => '地址已复制';

  @override
  String get getGasInvalidLink => '无效的链接';

  @override
  String get getGasCouldNotOpenLink => '无法打开链接，请检查是否已安装浏览器';

  @override
  String getGasOpenFailed(String error) {
    return '打开失败：$error';
  }

  @override
  String get homeRecentNotes => '最近笔记';

  @override
  String get homeRefreshRecentNotes => '刷新最近笔记';

  @override
  String get homeLoadingOnChainNotes => '正在加载链上笔记';

  @override
  String get homeSyncingOnChainNotes => '正在同步链上笔记…';

  @override
  String get homeNoNotesInLastMonth => '最近一个月都没有笔记了';

  @override
  String get homeCreateNewNotePrompt => '快来创建您的新笔记';

  @override
  String get notesAllChains => '全部链';

  @override
  String get notesSwitchedToAllChains => '已切换到全部链';

  @override
  String get notesFilterAll => '全部';

  @override
  String get notesFilterOnChain => '已上链';

  @override
  String get notesFilterOffChain => '未上链';

  @override
  String get notesSortNewest => '最新';

  @override
  String get notesSortUpdated => '更新';

  @override
  String get notesSortOldest => '最早';

  @override
  String get notesSortTitle => '标题';

  @override
  String notesTimelineNoteCount(int count) {
    return '$count 篇';
  }

  @override
  String get noteStatsTotalNotes => '总笔记';

  @override
  String get noteStatsOnChainCount => '已上链';

  @override
  String get noteStatsImages => '图片数';

  @override
  String get noteStatsChars => '总字数';

  @override
  String get noteDeleteNote => '删除笔记';

  @override
  String get noteDeleteConfirmTitle => '删除笔记？';

  @override
  String get noteDeleteConfirmBody => '确认删除这条笔记吗？删除后不可恢复。';

  @override
  String get noteDeletedSnackbar => '笔记已删除';

  @override
  String noteDeleteFailed(String error) {
    return '删除失败：$error';
  }

  @override
  String noteUpdatedAt(String date) {
    return '更新于 $date';
  }

  @override
  String noteCreatedAt(String date) {
    return '创建于 $date';
  }

  @override
  String get noteNoContent => '暂无内容';

  @override
  String get noteEditorCreateNewNote => '创建新笔记';

  @override
  String noteEditorChainLine(String chainName) {
    return '$chainName 链';
  }

  @override
  String get noteEditorSelectChainToPublish => '选择链后可上链';

  @override
  String get noteEditorSave => '保存';

  @override
  String get noteEditorSaving => '保存中';

  @override
  String get noteTitleLabel => '标题';

  @override
  String get noteTitleHint => '给你的笔记起个标题…';

  @override
  String get noteCoverImages => '封面图片（可选）';

  @override
  String get noteCoverAdd => '添加封面';

  @override
  String get noteCoverUploading => '上传中';

  @override
  String get noteCoverTapUpload => '点击上传封面图片';

  @override
  String get noteCoverFormatsHint => '支持 JPG、PNG 等格式';

  @override
  String get noteRichTextGuideTitle => '富文本编辑功能';

  @override
  String get noteRichTextHeadingLabel => '标题：';

  @override
  String get noteRichTextHeadingBody => '点击工具栏「标题」按钮插入数字标题。';

  @override
  String get noteRichTextListLabel => '列表：';

  @override
  String get noteRichTextListBody => '插入项目符号或编号列表。';

  @override
  String get noteRichTextEmojiLabel => 'Emoji：';

  @override
  String get noteRichTextEmojiBody => '快速插入常用表情和状态标记。';

  @override
  String get noteRichTextTemplateLabel => '模板：';

  @override
  String get noteRichTextTemplateBody => '选择预设模板快速开始创作。';

  @override
  String get noteRichTextImageLabel => '图片：';

  @override
  String get noteRichTextImageBody => '点击工具栏图片按钮，直接插入到正文中。';

  @override
  String get noteRichTextPreviewHint => '提示：切换到「预览」可查看排版效果。';

  @override
  String get noteEditorContentPlaceholder =>
      '在这里记录你的想法、灵感、计划…\n\n提示：使用工具栏可快速插入：\n• 标题和列表\n• Emoji 和特殊符号\n• 快速模板\n• 图片\n\n支持富文本格式，详情页会自动美化显示！';

  @override
  String get noteTipsTitle => '创作提示';

  @override
  String get noteTipsBody =>
      '• 给笔记起个有意义的标题\n• 记录你的想法、计划或重要信息\n• 可以添加图片让内容更丰富\n• 保存后可选择上链，永久存储';

  @override
  String get noteReadyTitle => '准备就绪';

  @override
  String get noteReadyBody => '内容已填写，点击右上角「保存」即可创建笔记。';

  @override
  String get noteTypeSectionLabel => '笔记类型：';

  @override
  String get notePublishToChain => '发布到链上';

  @override
  String get notePublishing => '上链中…';

  @override
  String get noteOnChainPublished => '已上链';

  @override
  String get selectBlockchainFirst => '请先选择区块链网络';

  @override
  String get noteImageAdded => '图片已添加';

  @override
  String get noteImagePickFailed => '选择图片失败';

  @override
  String get noteSavedToLocal => '已保存到本地';

  @override
  String get notePublishFailedKeptDraft => '上链失败，已保存为草稿';

  @override
  String get noteSavedAsDraft => '已保存为草稿';

  @override
  String get richTextPreviewMode => '预览模式';

  @override
  String get richTextEditMode => '编辑模式';

  @override
  String get richTextPreview => '预览';

  @override
  String get richTextEdit => '编辑';

  @override
  String richTextLineCount(int count) {
    return '$count 行';
  }

  @override
  String richTextCharCount(int count) {
    return '$count 字符';
  }

  @override
  String get richTextToolbarBottomHint => '提示：使用工具栏快速插入格式，或手动输入 emoji 和特殊符号。';

  @override
  String get richTextToolbarHeading => '标题';

  @override
  String get richTextTooltipInsertHeading => '插入标题';

  @override
  String get richTextTooltipBulletList => '插入列表';

  @override
  String get richTextTooltipNumberedList => '插入编号列表';

  @override
  String get richTextTooltipStatusMarkers => '插入状态标记';

  @override
  String get richTextToolbarEmojiMenu => '表情';

  @override
  String get richTextTooltipInsertEmoji => '插入表情';

  @override
  String get richTextToolbarTemplate => '模板';

  @override
  String get richTextTooltipQuickTemplate => '快速模板';

  @override
  String get richTextTooltipAddImage => '添加图片';

  @override
  String get richTextMdImageAlt => '图片';

  @override
  String get richTextInsertNumberedHeading => '\n1️⃣ 标题\n';

  @override
  String get richTextInsertBulletLines => '\n• 列表项 1\n• 列表项 2\n• 列表项 3\n';

  @override
  String get richTextInsertNumberedLines => '\n1. 第一项\n2. 第二项\n3. 第三项\n';

  @override
  String get richTextInsertStatusMarkers => '\n🟢 已完成\n🔵 进行中\n🟡 待处理\n';

  @override
  String get richTextEmojiGroupNumberedTitle => '数字标题';

  @override
  String get richTextEmojiGroupStatus => '状态标记';

  @override
  String get richTextEmojiGroupSymbols => '常用符号';

  @override
  String get richTextEmojiGroupEmoji => '表情';

  @override
  String get richTextEmojiHeadingWord => '标题';

  @override
  String get richTextEmojiBodyWord => '内容';

  @override
  String get richTextTplStandardNoteName => '📝 标准笔记';

  @override
  String get richTextTplStandardNoteBody =>
      '标题\n\n主要内容：\n• 要点 1\n• 要点 2\n• 要点 3\n\n总结：\n';

  @override
  String get richTextTplTaskName => '✅ 任务清单';

  @override
  String get richTextTplTaskBody =>
      '任务清单\n\n今日任务：\n✓ 已完成的任务\n✗ 未完成的任务\n→ 进行中的任务\n\n备注：\n';

  @override
  String get richTextTplStudyName => '📚 学习笔记';

  @override
  String get richTextTplStudyBody =>
      '学习笔记 - 主题\n\n1️⃣ 关键概念\n• 概念 1：说明\n• 概念 2：说明\n\n2️⃣ 重点总结\n• 要点 1\n• 要点 2\n\n3️⃣ 实践应用\n';

  @override
  String get richTextTplIdeaName => '💡 灵感记录';

  @override
  String get richTextTplIdeaBody =>
      '💡 灵感记录\n\n想法：\n🟢 核心想法描述\n\n优势：\n• 优点 1\n• 优点 2\n\n下一步：\n→ 行动计划\n';

  @override
  String get richTextTplProjectName => '📊 项目规划';

  @override
  String get richTextTplProjectBody =>
      '项目规划\n\n🎯 目标：\n\n📝 计划：\n1. 第一步\n2. 第二步\n3. 第三步\n\n⏰ 时间线：\n';

  @override
  String get gasPreviewTitle => 'Gas 费用预览';

  @override
  String get gasPreviewSubtitle => '请选择 Gas 速度并确认上链。';

  @override
  String get gasPreviewLoading => '正在获取 Gas 费用…';

  @override
  String get gasPreviewPickSpeed => '选择 Gas 速度';

  @override
  String get gasPreviewLiveRates => '实时费率';

  @override
  String get gasSpeedSlow => '慢速';

  @override
  String get gasSpeedStandard => '标准';

  @override
  String get gasSpeedFast => '快速';

  @override
  String get gasTimeSlow => '约 3–5 分钟';

  @override
  String get gasTimeStandard => '约 1–2 分钟';

  @override
  String get gasTimeFast => '约 15–30 秒';

  @override
  String get gasDescSlow => 'baseFee×1.1；小费 = max(30 Gwei, 网络建议) + 3 Gwei';

  @override
  String get gasDescStandard => 'baseFee×1.25；小费 = max(30 Gwei, 网络建议) + 8 Gwei';

  @override
  String get gasDescFast => 'baseFee×1.5；小费 = max(30 Gwei, 网络建议) + 20 Gwei';

  @override
  String get gasLabelGasPrice => 'Gas 价格';

  @override
  String get gasLabelEstCost => '预计费用';

  @override
  String get gasRecommendedBadge => '推荐';

  @override
  String gasPreviewGweiMax(String value) {
    return '$value Gwei（上限）';
  }

  @override
  String get gasFeeBreakdownTitle => '费用明细';

  @override
  String get gasFeeRowBase => '基础费用';

  @override
  String get gasFeeRowPriority => '优先费用';

  @override
  String get gasFeeRowNoteSize => '笔记大小';

  @override
  String get gasFeeRowTotal => '总费用';

  @override
  String gasFeeNoteSizeKb(String kb) {
    return '$kb KB';
  }

  @override
  String get gasWarningTitle => '温馨提示';

  @override
  String get gasWarningBody =>
      '• Gas 费用由区块链网络收取，与应用无关\n• 实际费用可能因网络拥堵略有浮动\n• 上链后的笔记无法删除或修改';

  @override
  String get gasConfirmOnChain => '确认上链';

  @override
  String get gasOnChainConfirmDialogTitle => '上链后不可修改';

  @override
  String get gasOnChainConfirmDialogBody =>
      '当前笔记将被写入区块链（IPFS + 链上存证），\n一旦提交将无法删除或修改，请确认内容无误后再继续。';

  @override
  String get gasOnChainConfirmDialogQuestion => '是否确认上链？';

  @override
  String get onChainConfirmParamSummarySectionTitle => '参数摘要';

  @override
  String get noteOnChainParamJsonKeyNetwork => '网络';

  @override
  String get noteOnChainParamJsonKeyChainId => '链 ID';

  @override
  String get noteOnChainParamJsonKeyFeeToken => 'Gas 支付代币';

  @override
  String get noteOnChainParamJsonKeySender => '发起地址（你的笔记账户）';

  @override
  String get noteOnChainParamJsonKeyContract => '合约地址';

  @override
  String get noteOnChainParamJsonKeyContractName => '合约名称';

  @override
  String get noteOnChainParamJsonKeyFunction => '调用方法';

  @override
  String get noteOnChainParamJsonKeyNoteTitle => '笔记标题';

  @override
  String get noteOnChainParamJsonKeyContentSha256 => '正文指纹 SHA-256';

  @override
  String get noteOnChainParamJsonGroupMintCall => '上链调用（合约参数）';

  @override
  String get noteOnChainParamJsonGroupContext => '当前可核对信息';

  @override
  String get noteOnChainParamJsonValueUriPending =>
      '安全验证确认并上传至 IPFS 后填入实际 ipfs:// 地址';

  @override
  String get noteOnChainConfirmPageTitle => '确认笔记上链';

  @override
  String get noteOnChainConfirmPageSubtitle => '将笔记永久保存到区块链';

  @override
  String get noteOnChainConfirmNoExplorer => '当前网络未配置区块浏览器，无法查看合约';

  @override
  String get noteOnChainConfirmMintStatusUncertain => '上链状态异常，请稍后在笔记或浏览器中核对';

  @override
  String get noteOnChainConfirmSignButton => '确认并安全验证';

  @override
  String get noteOnChainConfirmTipTitle => '上链提示';

  @override
  String get noteOnChainConfirmTipBody =>
      '• 上链后无法修改或删除笔记\n• 笔记将永久上链，归你所有\n• 需要支付少量 Gas 费用，仅一次';

  @override
  String get noteOnChainConfirmNoteContentSection => '笔记内容';

  @override
  String get noteOnChainConfirmNoteTitleLabel => '标题';

  @override
  String get noteOnChainConfirmContentPreview => '内容预览';

  @override
  String get noteOnChainConfirmNoteHashLabel => '笔记哈希 (SHA-256)';

  @override
  String get noteOnChainConfirmChainDetailsSection => '上链详情';

  @override
  String get noteOnChainConfirmMyWallet => '我的笔记账户';

  @override
  String get noteOnChainConfirmTargetContract => '目标合约';

  @override
  String get noteOnChainConfirmContractOwnershipHint =>
      '合约负责铸造笔记（NFT），笔记（NFT）最终归属于你的笔记账户，你拥有笔记的永久所有权';

  @override
  String noteOnChainConfirmNoteRecipientAddress(String address) {
    return '笔记接收地址：$address';
  }

  @override
  String get noteOnChainConfirmNetworkFee => '网络费用';

  @override
  String get noteOnChainConfirmGasPriceLabel => 'Gas 单价';

  @override
  String get noteOnChainConfirmGasLimitLabel => 'Gas 上限';

  @override
  String get noteOnChainConfirmOnChainFee => '上链费用';

  @override
  String get noteOnChainConfirmGasOnlyHint => '仅需支付 Gas';

  @override
  String get noteOnChainConfirmAdvancedSection => '高级详情';

  @override
  String get noteOnChainConfirmNonceLabel => 'Nonce';

  @override
  String get noteOnChainConfirmNetworkLabel => '网络';

  @override
  String get noteOnChainConfirmGasSlow => '慢速';

  @override
  String get noteOnChainConfirmGasNormal => '标准';

  @override
  String get noteOnChainConfirmGasFast => '快速';

  @override
  String get noteOnChainConfirmGasTimeSlow => '约 5 分钟';

  @override
  String get noteOnChainConfirmGasTimeNormal => '约 1 分钟';

  @override
  String get noteOnChainConfirmGasTimeFast => '约 15 秒';

  @override
  String get saveOptionsTitle => '选择保存方式';

  @override
  String get saveOptionsSubtitle => '根据您的需求选择合适的保存方式';

  @override
  String get saveOnChainTitle => '上链保存';

  @override
  String get saveOnChainDescription => '永久存储在区块链，不可篡改';

  @override
  String get saveOnChainFeature1 => '永久保存';

  @override
  String get saveOnChainFeature2 => '可验证';

  @override
  String get saveOnChainFeature3 => '去中心化';

  @override
  String get ipfsUploadConfirmTitle => '上传到 IPFS';

  @override
  String get ipfsUploadConfirmBody =>
      '当前笔记含有本地图片，上链前需先上传到去中心化存储（IPFS）。上传后可在后续步骤写入区块链。\n\n是否将相关内容上传到 IPFS 并继续？';

  @override
  String get saveBadgeSecure => '安全';

  @override
  String get saveDraftTitle => '保存为草稿';

  @override
  String get saveDraftDescription => '稍后继续编辑，不占用链资源';

  @override
  String get saveDraftFeature1 => '随时编辑';

  @override
  String get saveDraftFeature2 => '本地存储';

  @override
  String get saveDraftFeature3 => '快速保存';

  @override
  String get saveBadgeRecommended => '推荐';

  @override
  String get saveLocalTitle => '保存到本地';

  @override
  String get saveLocalDescription => '完成编辑，仅保存在设备上';

  @override
  String get saveLocalFeature1 => '离线可用';

  @override
  String get saveLocalFeature2 => '即时保存';

  @override
  String get saveLocalFeature3 => '零费用';

  @override
  String saveWillPublishToChain(String chainName) {
    return '将保存到 $chainName';
  }

  @override
  String get guideWelcomeTitle => '欢迎使用链上笔记';

  @override
  String get guideWelcomeSubtitle => '开始之前，让我们设置您的数字笔记账户';

  @override
  String get guideSecurityTitle => '您的数据，您做主';

  @override
  String get guideSecurityBody =>
      '笔记账户安全密钥完全由您控制，我们不会在服务器上存储任何敏感信息。请务必妥善保管您的恢复短语和安全密钥。';

  @override
  String get guideCreateWalletTitle => '创建新笔记账户';

  @override
  String get guideCreateWalletSubtitle => '全新开始，系统将为您生成一个全新的笔记账户地址和恢复短语';

  @override
  String get guideRecommendedNewUser => '推荐新用户';

  @override
  String get guideImportWalletTitle => '恢复现有笔记账户';

  @override
  String get guideImportWalletSubtitle => '使用恢复短语或安全密钥恢复您已有的笔记账户';

  @override
  String get guideTagMnemonic => '恢复短语';

  @override
  String get guideTagPrivateKey => '安全密钥';

  @override
  String get guideICloudRestoreTitle => '从 iCloud 恢复';

  @override
  String get guideICloudRestoreSubtitle => '如果您之前在 iCloud 中备份过笔记账户，可以快速恢复';

  @override
  String get guideBadgeIosOnly => '仅限 iOS 设备';

  @override
  String get guideGoogleRestoreTitle => '从 Google Drive 恢复';

  @override
  String get guideGoogleRestoreSubtitle =>
      '如果您之前在 Google Drive 中备份过笔记账户，可以快速恢复';

  @override
  String get guideBadgeAllDevices => '支持所有设备';

  @override
  String get guideFooterHint => '选择任一方式继续使用链上笔记\n您的安全密钥将安全存储在本地设备中';

  @override
  String get guideProviderICloud => 'iCloud';

  @override
  String get guideProviderGoogleDrive => 'Google Drive';

  @override
  String get guideLoadingWalletMessage => '加载笔记账户…';

  @override
  String googlePlayReviewModeTapHint(int remaining) {
    return '再点击 $remaining 次进入审核模式';
  }

  @override
  String get helpCenter => '帮助中心';

  @override
  String get helpCenterSubtitle => '常见问题与使用指南';

  @override
  String get helpSectionQuickGuide => '快速指南';

  @override
  String get helpSectionFaq => '常见问题';

  @override
  String get helpSearchHint => '搜索问题…';

  @override
  String get helpCategoryAll => '全部';

  @override
  String get helpCategoryBasics => '基础使用';

  @override
  String get helpCategoryBlockchain => '区块链';

  @override
  String get helpCategoryWalletSecurity => '笔记账户安全';

  @override
  String get helpCategoryWalletMgmt => '笔记账户管理';

  @override
  String get helpCategoryAdvanced => '高级功能';

  @override
  String get helpCategoryCommon => '常见问题';

  @override
  String get helpComingSoon => '敬请期待';

  @override
  String get helpEmptyTitle => '没有找到相关问题';

  @override
  String get helpEmptySubtitle => '试试其他关键词或联系客服';

  @override
  String get helpContactTitle => '联系客服';

  @override
  String get helpContactSubtitle => '没有找到答案？发送邮件给我们';

  @override
  String get helpContactSendFeedback => '发送反馈';

  @override
  String get helpContactYourEmailOptional => '您的邮箱（选填）';

  @override
  String get helpContactEmailHint => '';

  @override
  String get helpContactMessageLabel => '反馈内容';

  @override
  String get helpContactMessageHint => '请描述您遇到的问题或建议…';

  @override
  String get helpContactSending => '发送中…';

  @override
  String get helpContactSend => '发送';

  @override
  String get helpCopySupportEmail => '邮箱地址已复制';

  @override
  String get helpFeedbackEmpty => '请输入反馈内容';

  @override
  String get helpFeedbackThanks => '感谢您的反馈！';

  @override
  String get helpFeedbackMailFailed => '打开邮件失败，请稍后重试';

  @override
  String get helpFeedbackMailSubject => '用户反馈';

  @override
  String get helpQuickGuide1Title => '快速入门';

  @override
  String get helpQuickGuide1Desc => '5分钟了解链上笔记的基本功能';

  @override
  String get helpQuickGuide2Title => '创建第一条笔记';

  @override
  String get helpQuickGuide2Desc => '手把手教您创建并上链保存笔记';

  @override
  String get helpQuickGuide3Title => '备份恢复短语';

  @override
  String get helpQuickGuide3Desc => '确保您的笔记和数据安全';

  @override
  String get helpQuickGuide4Title => '管理多个笔记账户';

  @override
  String get helpQuickGuide4Desc => '创建、恢复和切换笔记账户';

  @override
  String get helpFaq1Question => '什么是链上笔记？';

  @override
  String get helpFaq1Answer =>
      '链上笔记是一个基于区块链技术的笔记应用。您可以将笔记永久保存到区块链上，实现数据的不可篡改和永久保存。笔记一旦上链，任何人都无法修改或删除，确保内容的真实性和可追溯性。';

  @override
  String get helpFaq2Question => '如何创建一条新笔记？';

  @override
  String get helpFaq2Answer =>
      '您可以通过以下方式创建笔记：\n1. 在首页点击“创建笔记”按钮\n2. 在笔记页面点击右下角的“+”按钮\n3. 创建后可以添加标题、内容和图片';

  @override
  String get helpFaq3Question => '笔记有哪些保存方式？';

  @override
  String get helpFaq3Answer =>
      '系统提供三种保存方式：\n1. 保存为草稿：本地保存，可随时编辑\n2. 保存到本地：完成编辑，本地存储\n3. 上链保存：永久保存到区块链，不可修改\n\n建议先保存为草稿，确认内容无误后再选择上链保存。';

  @override
  String get helpFaq4Question => '什么是上链保存？需要付费吗？';

  @override
  String get helpFaq4Answer =>
      '上链保存是指将笔记内容通过区块链技术永久存储。上链需要支付 Gas 费用（网络手续费），这是由区块链网络收取的，并非应用费用。不同区块链网络的 Gas 费用不同，通常 L2 网络（如 Arbitrum、Optimism）的费用更低。';

  @override
  String get helpFaq5Question => '支持哪些区块链网络？';

  @override
  String get helpFaq5Answer =>
      '目前支持 8 条主流区块链：\n• Ethereum（以太坊主网）\n• BSC（币安智能链）\n• Polygon（马蹄链）\n• Arbitrum（L2 网络）\n• Optimism（L2 网络）\n• Avalanche（雪崩链）\n• Fantom（FTM 链）\n• Base（Base 链）\n\n您可以在首页随时切换网络。';

  @override
  String get helpFaq6Question => '如何验证笔记是否真的上链了？';

  @override
  String get helpFaq6Answer =>
      '笔记上链后会生成区块链哈希值（Hash），您可以：\n1. 在笔记详情页查看哈希值\n2. 点击“验证”按钮查看完整的区块链信息\n3. 复制哈希值到对应链的区块链浏览器查询\n\n系统会显示该笔记在区块链上的完整记录。';

  @override
  String get helpFaq7Question => '什么是恢复短语？为什么要备份？';

  @override
  String get helpFaq7Answer =>
      '恢复短语是恢复笔记账户的唯一凭证，通常由 12 个英文单词组成。它是您笔记账户的“主密钥”。\n\n重要性：\n• 恢复短语丢失 = 笔记账户永久丢失\n• 恢复短语泄露 = 笔记可能永久丢失或被他人管理\n• 应用无法帮您找回恢复短语\n\n务必妥善保管，建议抄写在纸上保存在安全的地方。';

  @override
  String get helpFaq8Question => '如何备份恢复短语？';

  @override
  String get helpFaq8Answer =>
      '备份恢复短语的步骤：\n1. 进入“我的”页面\n2. 点击“备份恢复短语”\n3. 阅读安全提示\n4. 抄写 12 个恢复短语\n5. 按顺序验证恢复短语\n6. 完成备份\n\n注意：请在安全的环境下备份，确保无人窥视。';

  @override
  String get helpFaq9Question => '安全密钥和恢复短语有什么区别？';

  @override
  String get helpFaq9Answer =>
      '恢复短语和安全密钥都可以恢复笔记账户，但有所不同：\n\n恢复短语：\n• 12 个英文单词\n• 易于抄写和记忆\n• 可以派生多个安全密钥\n• 推荐的备份方式\n\n安全密钥：\n• 64 位十六进制字符串\n• 难以记忆\n• 对应单个地址\n• 适合高级用户';

  @override
  String get helpFaq10Question => '如何切换笔记账户？';

  @override
  String get helpFaq10Answer =>
      '切换笔记账户的方法：\n1. 点击首页顶部的笔记账户地址\n2. 在弹出的笔记账户选择器中选择要切换的笔记账户\n3. 或点击“笔记账户管理”创建/恢复新笔记账户\n\n系统支持管理多个笔记账户，可随时切换。';

  @override
  String get helpFaq11Question => '如何查看不同链的地址？';

  @override
  String get helpFaq11Answer =>
      '在“我的笔记账户”页面：\n1. 点击笔记账户卡片右侧的下拉箭头\n2. 会展开显示所有支持的 8 条链\n3. 每条链都显示对应的地址\n4. 点击地址可以快速复制\n\n注意：同一个笔记账户在不同链上的地址是相同的（EVM 兼容链）。';

  @override
  String get helpFaq12Question => '如何自定义 RPC 节点？';

  @override
  String get helpFaq12Answer =>
      '自定义 RPC 节点的步骤：\n1. 进入“我的”→“网络设置”\n2. 选择要配置的网络\n3. 点击“添加节点”按钮\n4. 输入节点名称和 RPC URL\n5. 测试连接\n6. 设为默认节点\n\n自定义节点可以提高连接速度和稳定性。';

  @override
  String get helpFaq13Question => '富文本编辑器支持哪些格式？';

  @override
  String get helpFaq13Answer =>
      '富文本编辑器支持多种格式：\n• 粗体、斜体、下划线\n• 标题（H1-H3）\n• 有序列表、无序列表\n• 引用块\n• 代码块\n• 图片上传\n\n使用工具栏按钮即可快速格式化文本。';

  @override
  String get helpFaq14Question => '上链后的笔记可以修改或删除吗？';

  @override
  String get helpFaq14Answer =>
      '不可以。这正是区块链技术的特点：\n\n上链后：\n• 内容永久保存\n• 无法修改\n• 无法删除\n• 任何人都无法篡改\n\n因此建议：\n1. 先保存为草稿反复修改\n2. 确认无误后再上链\n3. 敏感信息不要上链';

  @override
  String get helpFaq15Question => '为什么上链需要等待？';

  @override
  String get helpFaq15Answer =>
      'Gas 费用确认后，笔记会提交到区块链网络。等待时间取决于：\n\n1. 网络拥堵程度\n2. 您选择的 Gas 速度\n   • 快速：15-30 秒\n   • 标准：1-2 分钟\n   • 慢速：3-5 分钟\n3. 区块确认时间\n\n通常 1-2 分钟即可完成。';

  @override
  String get helpFaq16Question => '忘记密码怎么办？';

  @override
  String get helpFaq16Answer =>
      '如果忘记密码：\n\n1. 可以使用恢复短语重新恢复笔记账户\n2. 恢复后重新设置密码\n3. 原有的笔记数据会保留\n\n重要提醒：\n• 密码用于本地加密\n• 恢复短语是最终凭证\n• 务必备份恢复短语';

  @override
  String helpFeedbackMailBody(String email, String message) {
    return '联系邮箱：$email\n\n$message';
  }

  @override
  String get termsOfServiceLastUpdatedLabel => '最近更新';

  @override
  String get termsOfServiceIntroTitle => '重要提示';

  @override
  String termsOfServiceIntroBody(String privacyDoc) {
    return '请仔细阅读本服务条款及$privacyDoc。使用本服务即表示您理解并同意相关规则。若不同意，请勿使用本服务。';
  }

  @override
  String get termsOfServiceHelpTitle => '需要帮助？';

  @override
  String get termsOfServiceHelpBody =>
      '若对本条款有疑问，请前往应用内帮助中心或通过设置中的反馈、邮件联系我们。我们将在合理时间内尽力答复。';

  @override
  String get termsOfServiceHelpMailFeedback => '邮件反馈';

  @override
  String get termsOfServiceSection01Title => '1. 服务条款的接受';

  @override
  String termsOfServiceSection01Body(String appTitle) {
    return '欢迎使用「$appTitle」（以下简称「本服务」）。在使用前请仔细阅读本服务条款（以下简称「本条款」）。\n您点击同意、注册、登录或实际使用本服务，即视为已阅读并同意受本条款约束。若不同意，请停止使用本服务。\n我们可能适时修订本条款，修订后经应用内公告或更新后继续使用视为接受修订版本。';
  }

  @override
  String get termsOfServiceSection02Title => '2. 服务说明';

  @override
  String get termsOfServiceSection02Body =>
      '本服务为结合本地存储与区块链能力的笔记类应用：您可在设备上创建、编辑与管理笔记，并可按自身选择进行与链上相关的操作（例如交易、哈希或元数据等，具体以应用内流程与提示为准）。\n当前实现特点包括（可能随版本更新）：\n• 本地存储：笔记等数据主要保存在您的设备（如本地数据库）；卸载应用可能导致本地数据丢失，请自行备份。\n• 链上相关能力：您可自愿发起链上操作以实现存证、同步或展示等目的；链上记录通常公开且难以删除。\n• 多链支持：支持多条 EVM 兼容网络，具体以应用内列表为准。\n• 笔记账户：由您在设备内生成或导入密钥材料；密钥与恢复短语由您本人保管。\n本服务仅提供技术工具与中立的软件能力，不对您笔记内容的合法性、准确性、完整性或适用于任何特定目的作担保。';

  @override
  String get termsOfServiceSection03Title => '3. 用户笔记账户与安全';

  @override
  String get termsOfServiceSection03Body =>
      '3.1 笔记账户与凭证：创建或恢复笔记账户后，系统会在设备侧管理地址与密钥材料。恢复短语、安全密钥是恢复笔记的唯一有效凭据之一，请务必离线备份并妥善保密。\n3.2 安全责任：凡使用您设备上已解锁的应用与笔记账户所进行之操作，均视为由您或您授权环境下进行；因泄露恢复短语/安全密钥、设备丢失、恶意软件、钓鱼或您未按提示操作导致的损失，由您自行承担。\n3.3 安全建议：\n• 切勿向任何人泄露恢复短语或安全密钥\n• 为应用设置高强度密码并启用系统提供的锁屏/生物识别（若可用）\n• 在可信网络环境下备份恢复短语，并验证备份正确性\n• 警惕仿冒应用与钓鱼链接\n3.4 我们及工作人员不会以任何理由向您索要完整恢复短语或安全密钥。如遇此类请求，请拒绝并通过官方渠道反馈。';

  @override
  String get termsOfServiceSection04Title => '4. 区块链交易与费用';

  @override
  String termsOfServiceSection04Body(String appTitle) {
    return '4.1 Gas 与网络费：在链上发起交易需向区块链网络支付手续费（Gas 等）。费用由网络收取，与「$appTitle」作为软件提供方无商业上的代收关系；费率与额度由网络与当时拥堵情况决定。\n4.2 确认时间：交易需经网络确认，时间取决于网络状态与您选择的费率策略；我们不保证具体确认时长。\n4.3 失败与扣费：因余额不足、RPC 异常、用户撤销、合约回滚等原因可能导致交易失败；部分情况下已消耗的网络费仍无法退还，以网络规则为准。\n4.4 不可逆性：链上交易一经足够确认，通常不可撤销或篡改。请在安全验证与广播前核对网络、金额与合约交互内容。\n4.5 您对您主动发起的全部链上操作及相应后果自行负责。因区块链协议、第三方节点、智能合约或您自身操作失误造成的损失，我们在法律法规允许范围内不承担责任。';
  }

  @override
  String get termsOfServiceSection05Title => '5. 用户行为规范';

  @override
  String get termsOfServiceSection05Body =>
      '使用本服务时，您不得：\n• 制作、上传、传播违法违规、侵权、诽谤、淫秽、暴力、仇恨或侵害他人合法权益的内容\n• 利用本服务从事欺诈、洗钱、非法募资、侵犯知识产权或其他监管机构禁止的行为\n• 对本服务或相关基础设施进行未经授权的访问、探测、干扰或破坏\n• 批量爬取、滥用接口或影响其他用户正常使用（除非我们书面允许）\n• 利用本服务大量发送骚扰或未经授权的商业信息\n若您违反前款，我们有权视情节采取警示、限制功能、中止或终止向您提供服务等措施，并可在依法或依监管部门要求时配合提供必要信息。';

  @override
  String get termsOfServiceSection06Title => '6. 知识产权';

  @override
  String get termsOfServiceSection06Body =>
      '6.1 本服务本身：包括但不限于客户端软件、界面设计、标识与文档的著作权、商标权等归我们或权利人所有。未经许可，您不得复制、反向工程、破解或商业性再分发本服务核心代码（法律允许的合理使用除外）。\n6.2 您的内容：您对自行创作的笔记等内容保留权利；本条款不转移该等权利予我们。\n6.3 为向您提供同步、展示、备份、链上提交等技术实现所必要的范围内，您授予我们非独占、可撤回（在服务条款允许终止使用的范围内）、免许可费的使用许可，仅限于运行与改进本服务之目的。\n6.4 未经书面许可，您不得以容易引起混淆的方式使用我们的商标、应用名称或图标。';

  @override
  String get termsOfServiceSection07Title => '7. 免责声明';

  @override
  String get termsOfServiceSection07Body =>
      '7.1 「现状」提供：在适用法律允许的最大范围内，本服务按「现状」及「可用」基础提供。我们不对服务持续不间断、无错误、满足您所有需求或与其他软硬件完全兼容作明示或默示担保。\n7.2 数据与安全：我们会采取合理技术与管理措施，但无法保证因不可抗力、设备遗失、病毒、第三方攻击或区块链/IPFS 等外部系统导致的数据泄露、丢失或服务中断不会发生。\n7.3 第三方：本服务可能依赖区块链节点、网关、去中心化存储、消息推送等第三方服务；对其可用性、准确性或合规性我们不作担保，相关风险由您自行评估。\n7.4 链上笔记与协议风险：链上笔记及相关协议具有网络异常、合约漏洞、治理分叉等固有风险；您应自行了解并承担。\n7.5 责任限制：除法律强制规定外，我们对任何间接、附带、惩罚性或后果性损害不承担责任；我们的总赔偿额以您就争议服务向我们已实际支付的金额为上限（若为零则以零为限）。';

  @override
  String get termsOfServiceSection08Title => '8. 服务变更、中止与终止';

  @override
  String get termsOfServiceSection08Body =>
      '8.1 我们有权因业务调整、合规要求或技术原因修改、暂停或终止部分或全部功能；将在可行时通过应用内提示等方式告知。\n8.2 您可随时停止使用并卸载本服务；重要数据请务必提前自行导出或备份。\n8.3 若您严重违反本条款，我们可中止或终止向您提供服务。\n8.4 服务终止后，除法律另有要求外，我们没有义务继续保存或向您返还已存储在链上、第三方网络或您本地已由您处置的数据。';

  @override
  String get termsOfServiceSection09Title => '9. 法律适用与争议解决';

  @override
  String get termsOfServiceSection09Body =>
      '9.1 本条款的订立、效力、解释与履行适用中华人民共和国大陆地区法律（仅为本条款目的，不包括冲突法规则导致适用域外法的情形，法律法规另有规定的除外）。\n9.2 因本条款引起的争议，双方应先行友好协商。\n9.3 协商不成的，任何一方可向有管辖权的人民法院提起诉讼（可约定为我们主要办事机构所在地法院，如与强制性管辖规则冲突，以法律为准）。';

  @override
  String get termsOfServiceSection10Title => '10. 其他';

  @override
  String termsOfServiceSection10Body(String privacyDoc) {
    return '10.1 完整协议：本条款与$privacyDoc（如有）及应用内专项规则共同构成您使用本服务的主要规则；冲突时，就专项事项以专项规则为准（不得违反强制性法律）。\n10.2 可分割：若某条款被认定无效或不可执行，其余条款仍然有效，且应在合法范围内尽可能接近原意作出解释。\n10.3 不弃权：我们未及时行使权利不构成对该权利的放弃。\n10.4 联系我们：除法律法规另有强制性渠道外，您可通过应用内「帮助中心」或反馈就本条款提出询问。';
  }

  @override
  String termsOfServiceFooterLine1(String appTitle) {
    return '感谢您信任并使用$appTitle。';
  }

  @override
  String get connectEvmAccountFirst => '请先连接 EVM 笔记账户';

  @override
  String get createAccountFailedRetry => '创建笔记账户失败，请稍后重试';

  @override
  String createAccountFailedWithError(String error) {
    return '创建笔记账户失败：$error';
  }

  @override
  String get transactionHistoryConnectEvm => '请选择网络并确保已连接 EVM 笔记账户';

  @override
  String get transactionHistoryUnsupportedNetwork =>
      '当前网络暂不支持创建笔记记录列表（请切换至常见 EVM 网络）';

  @override
  String get securityVerificationFailed => '安全验证失败';

  @override
  String get walletImportPrivateKeyHint => '请输入您的安全密钥，请勿泄露给他人';

  @override
  String get walletImportPrivateKeySubmit => '导入安全密钥';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '鏈上筆記';

  @override
  String get tabHome => '首頁';

  @override
  String get tabNotes => '筆記';

  @override
  String get tabProfile => '我的';

  @override
  String get myNotes => '我的筆記';

  @override
  String notesCount(int count) {
    return '共 $count 篇筆記';
  }

  @override
  String get createNote => '建立筆記';

  @override
  String get selectNetwork => '選擇網路';

  @override
  String get selectNetworkSubtitle => '選擇您要使用的區塊鏈網路';

  @override
  String get chainSelectorMainnetTab => '主網';

  @override
  String get chainSelectorTestnetTab => '測試網';

  @override
  String get chainSelectorFooterHint => '切換網路後，筆記將儲存在對應的區塊鏈上';

  @override
  String get chainSelectorTestnetNoticeTitle => '測試網說明';

  @override
  String get chainSelectorTestnetNoticeBody => '測試網用於開發測試，代幣無真實價值';

  @override
  String get chainSelectorAllChainsTitle => '全部鏈';

  @override
  String get chainSelectorAllChainsSubtitle => '顯示所有鏈的筆記';

  @override
  String chainSelectorChainIdLabel(int chainId) {
    return '鏈 ID：$chainId';
  }

  @override
  String get chainSelectorCurrentBadge => '目前';

  @override
  String chainSelectorGasLabel(String cost) {
    return 'Gas：$cost';
  }

  @override
  String get chainGasCostLevelMedium => '中等';

  @override
  String get chainSelectorTestnetChainWarning => '測試網路 · 無真實價值';

  @override
  String get viewAll => '查看全部';

  @override
  String get aboutUs => '關於我們';

  @override
  String get aboutPageTagline => '永久保存 · 不可篡改 · 完全掌控';

  @override
  String splashVersionLabel(String version) {
    return '版本 $version';
  }

  @override
  String get aboutPageVersionSection => '版本資訊';

  @override
  String get aboutPageCurrentVersion => '目前版本';

  @override
  String get photosPermissionDeniedSnack => '無相簿權限，請在系統設定中開啟後重試';

  @override
  String get pressBackAgainToExitApp => '再按一次即可退出應用';

  @override
  String noteEditorOnChainTypeConfirmedSnack(String publishAction) {
    return '已確認上鏈，請儲存或點擊「$publishAction」繼續';
  }

  @override
  String get actionShow => '顯示';

  @override
  String get actionHide => '隱藏';

  @override
  String get actionSaveToFile => '儲存檔案';

  @override
  String get mnemonicExportSecurityConfirmTitle => '安全確認';

  @override
  String get mnemonicExportAckSaved => '我已安全保存恢復短語到可靠位置';

  @override
  String get mnemonicExportAckUnderstandLoss => '我了解遺失恢復短語將無法恢復筆記帳戶';

  @override
  String get mnemonicExportAckNoShare => '我承諾不向任何人洩露恢復短語';

  @override
  String get mnemonicExportSafetyTipsTitle => '安全建議';

  @override
  String get mnemonicExportSafetyTipPaper => '將恢復短語寫在紙上，存放在安全的地方';

  @override
  String get mnemonicExportSafetyTipNoScreenshot => '不要截圖或保存在連網裝置上';

  @override
  String get mnemonicExportSafetyTipCheckBackup => '定期檢查備份的完整性';

  @override
  String get mnemonicExportFinishCta => '我已安全保存';

  @override
  String get aboutPageReleaseDate => '發布日期';

  @override
  String get aboutPageBuildNumber => '建置版本';

  @override
  String get aboutPageCoreFeatures => '核心特色';

  @override
  String get aboutFeatureOnChainTitle => '鏈上儲存';

  @override
  String get aboutFeatureOnChainDesc => 'SHA-256 雜湊上鏈，永久不可篡改';

  @override
  String get aboutFeatureSecureTitle => '資料安全';

  @override
  String get aboutFeatureSecureDesc => '端到端加密，您掌握安全密鑰';

  @override
  String get aboutFeatureSyncTitle => '即時同步';

  @override
  String get aboutFeatureSyncDesc => '多裝置即時同步，隨時隨地存取';

  @override
  String get aboutFeatureControlTitle => '完全掌控';

  @override
  String get aboutFeatureControlDesc => '去中心化架構，資料完全屬於您';

  @override
  String get aboutPageTechStack => '技術棧';

  @override
  String get aboutPageContactUs => '聯絡我們';

  @override
  String get aboutPageOfficialWebsite => '官方網站';

  @override
  String get aboutPageContactEmail => '聯絡信箱';

  @override
  String get aboutPageOpenSource => '開源程式碼';

  @override
  String get aboutPageCreditsMadeWith => '用心呈現 ';

  @override
  String aboutPageCopyrightNotice(String yearBrand) {
    return '© $yearBrand。保留所有權利。';
  }

  @override
  String get walletManagement => '筆記帳戶管理';

  @override
  String get walletCannotDeleteSwitchFirst => '無法刪除目前使用的筆記帳戶，請先切換';

  @override
  String get walletViewMnemonicCompleteBackupFirst => '請先完成恢復短語備份後再檢視恢復短語或安全密鑰';

  @override
  String get walletDemoPrimaryName => '我的主筆記帳戶';

  @override
  String get walletAddressListTitle => '筆記帳戶位址列表';

  @override
  String get copyAddressButton => '複製位址';

  @override
  String get labelCopied => '已複製';

  @override
  String get walletManagementDeleteIrreversible => '此操作無法復原。請確認已備份恢復短語或安全密鑰。';

  @override
  String get walletManagementDeleteWarningTitle => '警告：刪除後無法復原';

  @override
  String get walletManagementDeleteAssetsLoss =>
      '請確認已妥善保存恢復短語或安全密鑰，否則您的筆記可能永久遺失。';

  @override
  String get walletCreateSystemDescription => '系統將為您產生新的筆記帳戶位址與恢復短語';

  @override
  String get walletCreateBackupReminderBody => '建立後請立即備份恢復短語，恢復短語是恢復筆記帳戶的唯一憑證。';

  @override
  String get walletCreateGenerateSubtitle => '產生新筆記帳戶';

  @override
  String get walletAddressCopied => '位址已複製';

  @override
  String get walletNameRequired => '筆記帳戶名稱不能為空';

  @override
  String get walletNameUpdated => '筆記帳戶名稱已更新';

  @override
  String get walletKeepAtLeastOne => '至少需要保留一個筆記帳戶';

  @override
  String get walletCannotDeleteCurrent => '無法刪除目前使用中的筆記帳戶';

  @override
  String get walletDeleted => '筆記帳戶已刪除';

  @override
  String get walletCreated => '筆記帳戶建立成功';

  @override
  String get walletImportMnemonicOrKeyRequired => '請輸入恢復短語或安全密鑰';

  @override
  String get walletImportSuccess => '筆記帳戶恢復成功';

  @override
  String get walletImportedCannotViewMnemonic => '恢復的筆記帳戶無法查看恢復短語';

  @override
  String get walletMarkedBackedUp => '已標記為已備份';

  @override
  String get walletSwitched => '已切換筆記帳戶';

  @override
  String get viewMnemonic => '查看恢復短語';

  @override
  String get viewPrivateKey => '查看安全密鑰';

  @override
  String get privateKeyExportSelectNetworkHint => '選擇要查看的網路';

  @override
  String get privateKeyExportKeepKeySafeHint => '請妥善保管您的安全密鑰';

  @override
  String get privateKeyExportSecurityWarningTitle => '安全警告';

  @override
  String get privateKeyExportWarnBullet1 => '安全密鑰是管理筆記的最高權限憑證';

  @override
  String get privateKeyExportWarnBullet2 => '任何人取得安全密鑰即可完全管理您的筆記';

  @override
  String get privateKeyExportWarnBullet3 => '請確保周圍環境安全，無人窺視';

  @override
  String get privateKeyExportWarnBullet4 => '切勿截圖、拍照或透過網路傳輸安全密鑰';

  @override
  String get privateKeyExportSupportedNetworksTitle => '支援的網路';

  @override
  String privateKeyExportNetworkCount(int count) {
    return '$count 個網路';
  }

  @override
  String get privateKeyExportViewSafetyTitle => '安全密鑰安全提示';

  @override
  String get privateKeyExportViewBullet1 => '確保周圍環境安全，無人窺視螢幕';

  @override
  String get privateKeyExportViewBullet2 => '不要在公共場所或不安全的網路環境下查看';

  @override
  String get privateKeyExportViewBullet3 => '查看完畢後請儘快關閉此頁面';

  @override
  String get privateKeyExportKeySectionTitle => '安全密鑰';

  @override
  String get privateKeyExportBip44Hint =>
      'BIP44 以太坊路徑派生的安全密鑰在各 EVM 主網相同，僅網路名稱不同。';

  @override
  String get privateKeyExportMaskedPlaceholder =>
      '0x•••••••••••••••••••••••••••••••••';

  @override
  String get privateKeyExportDoNotShareInline => '請勿將安全密鑰告知任何人或透過網路傳輸';

  @override
  String privateKeyExportNetworkAddressLabel(String networkName) {
    return '$networkName 網路地址';
  }

  @override
  String get privateKeyExportImportantReminderTitle => '重要提醒';

  @override
  String get privateKeyExportReminderBullet1 => '擁有安全密鑰 = 可完全管理該地址下的筆記';

  @override
  String get privateKeyExportReminderBullet2 => '安全密鑰外洩將導致筆記永久遺失，無法找回';

  @override
  String get privateKeyExportReminderBullet3 => '官方團隊永遠不會要求您提供安全密鑰';

  @override
  String get privateKeyExportReminderBullet4 => '建議使用恢復短語作為備份方式，而非安全密鑰';

  @override
  String get privateKeyExportBackToList => '返回列表';

  @override
  String get privateKeyExportCopySecurityKey => '複製安全密鑰';

  @override
  String get mnemonicManagePageTitle => '恢復短語管理';

  @override
  String get mnemonicManagePageSubtitle => '請妥善保管恢復短語，切勿洩露';

  @override
  String get mnemonicBackupFlowTitle => '備份恢復短語';

  @override
  String mnemonicBackupFlowStepProgress(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get mnemonicBackupFlowLoadFailed => '載入失敗';

  @override
  String get mnemonicBackupFlowCTAUnderstoodStart => '我已了解，開始備份';

  @override
  String get mnemonicBackupFlowCTACopiedContinue => '我已抄寫，繼續驗證';

  @override
  String get mnemonicBackupFlowCTAVerifiedContinue => '驗證通過，繼續';

  @override
  String get mnemonicBackupFlowCTAPleaseVerify => '請完成驗證';

  @override
  String get mnemonicBackupFlowCTAFinish => '完成備份';

  @override
  String get mnemonicBackupFlowCTANext => '下一步';

  @override
  String get mnemonicBackupFlowFooterCopyHint => '請確認已正確抄寫所有恢復短語後再繼續';

  @override
  String get mnemonicBackupFlowStep1Heading => '開始備份前';

  @override
  String get mnemonicBackupFlowStep1Subheading => '請仔細閱讀以下安全提示';

  @override
  String get mnemonicBackupFlowSecurityTipsTitle => '重要安全提示';

  @override
  String get mnemonicBackupFlowSecurityTip1 => '恢復短語是恢復筆記帳戶的唯一憑證';

  @override
  String get mnemonicBackupFlowSecurityTip2 => '任何人取得恢復短語即可管理您的筆記';

  @override
  String get mnemonicBackupFlowSecurityTip3 => '遺失恢復短語將永久無法恢復筆記帳戶';

  @override
  String get mnemonicBackupFlowBackupAdviceTitle => '安全備份建議';

  @override
  String get mnemonicBackupFlowBackupAdvice1 => '將恢復短語寫在紙上，存放在安全的地方';

  @override
  String get mnemonicBackupFlowBackupAdvice2 => '不要截圖或保存在連網裝置上';

  @override
  String get mnemonicBackupFlowBackupAdvice3 => '不要透過網路傳送或分享給任何人';

  @override
  String get mnemonicBackupFlowBackupAdvice4 => '建議多處備份，分散保管';

  @override
  String get mnemonicBackupFlowProcessTitle => '備份流程';

  @override
  String get mnemonicBackupFlowProcess1 => '檢視並抄寫您的恢復短語';

  @override
  String get mnemonicBackupFlowProcess2 => '透過驗證確認備份正確';

  @override
  String get mnemonicBackupFlowProcess3 => '完成備份，保護您的筆記安全';

  @override
  String get mnemonicBackupFlowYourMnemonicTitle => '您的恢復短語';

  @override
  String get mnemonicBackupFlowYourMnemonicSubtitle => '請依序抄寫並妥善保管';

  @override
  String mnemonicBackupFlowWordCount(int count) {
    return '$count 個恢復短語';
  }

  @override
  String get mnemonicBackupFlowPleaseNoteTitle => '請注意';

  @override
  String get mnemonicBackupFlowStep2NoteBody =>
      '建議使用紙筆抄寫恢復短語，而非截圖或複製到連網裝置。點擊眼睛圖示可顯示或隱藏恢復短語。';

  @override
  String get mnemonicBackupFlowVerifyTitle => '驗證恢復短語';

  @override
  String get mnemonicBackupFlowVerifySubtitle => '請選擇正確的單字以確認您已正確備份';

  @override
  String mnemonicBackupFlowVerifyWordQuestion(int position) {
    return '第 $position 個單字是？';
  }

  @override
  String get mnemonicBackupFlowVerifySuccessTitle => '驗證成功！';

  @override
  String get mnemonicBackupFlowVerifySuccessBody => '您已正確備份恢復短語';

  @override
  String get mnemonicBackupFlowDoneTitle => '備份完成！';

  @override
  String get mnemonicBackupFlowDoneSubtitle => '您的恢復短語已安全備份';

  @override
  String get mnemonicBackupFlowDoneSectionTitle => '已完成';

  @override
  String get mnemonicBackupFlowDoneCheck1 => '檢視並抄寫恢復短語';

  @override
  String get mnemonicBackupFlowDoneCheck2 => '通過驗證測試';

  @override
  String get mnemonicBackupFlowDoneCheck3 => '恢復短語已安全保存';

  @override
  String get mnemonicBackupFlowDoneSecurityTitle => '安全提醒';

  @override
  String get mnemonicBackupFlowDoneSecurity1 => '請將恢復短語保存在安全的實體位置';

  @override
  String get mnemonicBackupFlowDoneSecurity2 => '切勿向任何人透露您的恢復短語';

  @override
  String get mnemonicBackupFlowDoneSecurity3 => '官方團隊絕不會向您索取恢復短語';

  @override
  String get mnemonicBackupFlowDoneSecurity4 => '定期檢查備份是否完整可讀';

  @override
  String get mnemonicBackupFlowFinalEncouragementTitle => '現在您可以安心使用筆記帳戶了！';

  @override
  String get mnemonicBackupFlowFinalEncouragementBody => '您的筆記受到恢復短語的保護';

  @override
  String get switchWallet => '切換';

  @override
  String get viewAddresses => '檢視位址';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get confirmDelete => '確認刪除';

  @override
  String get createWallet => '建立筆記帳戶';

  @override
  String get importWallet => '恢復筆記帳戶';

  @override
  String get mnemonicOrPrivateKey => '恢復短語或安全密鑰';

  @override
  String get close => '關閉';

  @override
  String get copy => '複製';

  @override
  String get mnemonicCopied => '恢復短語已複製';

  @override
  String get privateKeyCopied => '安全密鑰已複製';

  @override
  String get backedUp => '已備份';

  @override
  String get editWalletName => '編輯筆記帳戶名稱';

  @override
  String get deleteWallet => '刪除筆記帳戶';

  @override
  String get confirmDeleteWallet => '確認刪除筆記帳戶';

  @override
  String get newWalletCreated => '新筆記帳戶已建立';

  @override
  String get cannotDeleteCurrentWallet => '無法刪除目前使用中的筆記帳戶';

  @override
  String get edit => '編輯';

  @override
  String get createNewWallet => '建立新筆記帳戶';

  @override
  String get editWalletNameTitle => '修改筆記帳戶名稱';

  @override
  String get noteNotFoundBack => '筆記不存在，請返回';

  @override
  String get createNoteNotImplemented => '建立筆記（待實作）';

  @override
  String get newWalletCreateSuccess => '新筆記帳戶建立成功！';

  @override
  String restoringFromProvider(String provider) {
    return '正在從 $provider 還原筆記帳戶...';
  }

  @override
  String restoredFromProvider(String provider) {
    return '已從 $provider 還原筆記帳戶！';
  }

  @override
  String noBackupFoundProvider(String provider) {
    return '找不到 $provider 備份，請嘗試其他方式';
  }

  @override
  String get walletAddressCopiedShort => '筆記帳戶位址已複製';

  @override
  String switchedToChain(String chain) {
    return '已切換至 $chain';
  }

  @override
  String get fillAllFields => '請填寫完整資訊';

  @override
  String get passwordMismatch => '兩次輸入的新密碼不一致';

  @override
  String get passwordMinLength => '密碼長度至少 6 個字元';

  @override
  String get passwordChangeSuccess => '密碼已變更';

  @override
  String get enterValidEmail => '請輸入有效的電子郵件位址';

  @override
  String get verificationCodeSent => '驗證碼已傳送';

  @override
  String get enterSixDigitCode => '請輸入 6 位數驗證碼';

  @override
  String get emailBindSuccess => '電子郵件已綁定';

  @override
  String get emailUnbound => '電子郵件已解除綁定';

  @override
  String get logoutNotConnected => '登出（待串接）';

  @override
  String get changePassword => '變更密碼';

  @override
  String get confirm => '確認';

  @override
  String get bindEmail => '綁定電子郵件';

  @override
  String get editNoteOpenByRoute => '請透過路由開啟編輯頁';

  @override
  String get imageUploadNotConnected => '圖片上傳尚未連接儲存服務';

  @override
  String get imageRemoved => '圖片已移除';

  @override
  String get titleContentRequired => '標題與內容不能為空';

  @override
  String get submittedToChain => '已提交上鏈';

  @override
  String get onChainNoteCannotChangeType => '已上鏈的筆記無法變更類型';

  @override
  String get setToLocalNote => '已設為本地筆記（不會上鏈）';

  @override
  String get setToDraft => '已設為草稿';

  @override
  String get editNote => '編輯筆記';

  @override
  String get noteDetailEditDisabledOnChain => '已上鏈不可編輯';

  @override
  String get noteTypeDraft => '草稿';

  @override
  String get noteTypeLocal => '本地';

  @override
  String get noteTypeOnChain => '已上鏈';

  @override
  String get blockchainVerify => '驗證區塊鏈';

  @override
  String get blockchainVerifyTitle => '區塊鏈驗證';

  @override
  String getGas(String symbol) {
    return '取得 $symbol 燃料費';
  }

  @override
  String get addressCopied => '位址已複製';

  @override
  String get redirectingToFaucet => '正在前往水龍頭網站';

  @override
  String get noFaucetForNetwork => '此網路尚無水龍頭';

  @override
  String get loginNotImplemented => '登入功能待實作';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get forgotPasswordNotImplemented => '忘記密碼功能待實作';

  @override
  String get noAccountYet => '還沒有筆記帳戶？';

  @override
  String get registerNotImplemented => '註冊功能待實作';

  @override
  String get registerNow => '立即註冊';

  @override
  String get mnemonicVerifySuccess => '恢復短語校驗通過，匯入邏輯由外部實作';

  @override
  String get privateKeyVerifySuccess => '安全密鑰校驗通過，匯入邏輯由外部實作';

  @override
  String get importSuccess => '筆記帳戶恢復成功！';

  @override
  String get cleared => '已清空';

  @override
  String get back => '返回';

  @override
  String get current => '目前';

  @override
  String get imported => '已恢復';

  @override
  String get defaultBadge => '預設';

  @override
  String get clearSearch => '清除搜尋';

  @override
  String get searchNotesHint => '搜尋筆記...';

  @override
  String get noMatchNotes => '找不到符合的筆記';

  @override
  String get noOnChainNotes => '尚無已上鏈的筆記';

  @override
  String get noOffChainNotes => '尚無未上鏈的筆記';

  @override
  String get noNotes => '尚無筆記';

  @override
  String get tryOtherSearch => '試試其他關鍵字';

  @override
  String get startCreateFirstNote => '開始建立您的第一篇筆記';

  @override
  String get profileNotConnected => '未連線';

  @override
  String get profileSectionAccount => '筆記帳戶管理';

  @override
  String get profileNetworkSettingsSubtitle => '設定 RPC 與節點';

  @override
  String get profileSectionSecurity => '安全';

  @override
  String get profileChangePasswordSubtitle => '保護您的筆記帳戶安全';

  @override
  String get profileBindEmailNotBound => '未綁定';

  @override
  String get profileBindEmailBadgeBound => '已綁定';

  @override
  String get profileSectionPreferences => '偏好設定';

  @override
  String get profileNotifications => '通知提醒';

  @override
  String get profileDarkMode => '深色模式';

  @override
  String get profileLanguage => '語言';

  @override
  String get profileSectionMore => '更多';

  @override
  String get profileTestPage => '測試頁面';

  @override
  String get profileTestPageSubtitle => '功能測試入口';

  @override
  String get profileTerms => '服務條款';

  @override
  String get profilePrivacy => '隱私權政策';

  @override
  String get profileRateUs => '為我們評分';

  @override
  String get profileShare => '分享給朋友';

  @override
  String profileShareMessage(String url) {
    return '我正在使用這款鏈上筆記 App，推薦給你：\n$url';
  }

  @override
  String get profileLogoutLabel => '登出';

  @override
  String get profileLogoutPending => '登出（待串接）';

  @override
  String profilePageFooter(String appTitle, String version, String year) {
    return '$appTitle v$version\n© $year 保留所有權利。';
  }

  @override
  String get profileAvatarFallback => 'ME';

  @override
  String get profileDefaultWalletName => '我的筆記帳戶';

  @override
  String get profileUserActive => '活躍使用者';

  @override
  String get profileUserNormal => '一般使用者';

  @override
  String get profileStatNotes => '筆記數';

  @override
  String get profileStatOnChain => '已上鏈';

  @override
  String get profileStatDays => '天數';

  @override
  String get profileBindEmailDialogSubtitle => '請填寫電子郵件並取得驗證碼。';

  @override
  String get profileBindEmailFieldEmail => '電子郵件位址';

  @override
  String get profileBindEmailFieldCode => '驗證碼';

  @override
  String get profileSendVerificationCode => '傳送驗證碼';

  @override
  String profileResendCodeInSeconds(int seconds) {
    return '$seconds 秒後可重送';
  }

  @override
  String get profileUnbindEmail => '解除綁定電子郵件';

  @override
  String get languageSelectTitle => '選擇語言';

  @override
  String get languageSelectSubtitle => '選擇您偏好的介面語言';

  @override
  String get languageNoticeHint => '提示：';

  @override
  String get languageNoticeBody => '已支援簡體中文、繁體中文、英語、日語與韓語；其餘語言敬請期待。';

  @override
  String get languageCurrentBadge => '目前';

  @override
  String get languageSnackbarComingSoon => '敬請期待';

  @override
  String languageSwitchedTo(String name) {
    return '語言已切換至 $name';
  }

  @override
  String get languageFooterMore => '更多語言即將支援';

  @override
  String get changePasswordSameAsOld => '新密碼不能與舊密碼相同';

  @override
  String get changePasswordLength632 => '新密碼長度為 6-32 位';

  @override
  String get walletNoSavedKey => '找不到已儲存的金鑰，請先建立筆記帳戶';

  @override
  String get changePasswordWrongOrFailed => '舊密碼錯誤或操作失敗';

  @override
  String get passwordMaxLength32 => '密碼長度最多為 32 位';

  @override
  String get passwordMeetAllRequirements => '請滿足所有密碼要求';

  @override
  String encryptionInitFailed(String error) {
    return '加密初始化失敗：$error';
  }

  @override
  String get passwordVerifyForgotGoReset => '忘記密碼？前往重設';

  @override
  String get passwordStrengthWeak => '弱';

  @override
  String get passwordStrengthMedium => '中等';

  @override
  String get passwordStrengthStrong => '強';

  @override
  String get changePasswordPageTitle => '變更密碼';

  @override
  String get changePasswordPageSubtitle => '保護您的筆記帳戶安全';

  @override
  String get changePasswordSecurityHintTitle => '安全提示';

  @override
  String get changePasswordSecurityHintBody =>
      '• 定期變更密碼可提高筆記帳戶安全性\n• 請使用強密碼，包含字母、數字與符號\n• 勿使用生日、電話等易被猜到的密碼';

  @override
  String get changePasswordOldLabel => '舊密碼';

  @override
  String get changePasswordOldHint => '請輸入舊密碼';

  @override
  String get changePasswordNewLabel => '新密碼';

  @override
  String get changePasswordNewHint => '請輸入新密碼';

  @override
  String get changePasswordStrengthLabel => '密碼強度：';

  @override
  String get changePasswordMatchOk => '密碼一致';

  @override
  String get changePasswordMatchBad => '密碼不一致';

  @override
  String get changePasswordConfirmLabel => '確認新密碼';

  @override
  String get changePasswordConfirmHint => '請再次輸入新密碼';

  @override
  String get changePasswordRuleLength => '6-32 個字元';

  @override
  String get changePasswordRuleCase => '包含大小寫字母';

  @override
  String get changePasswordRuleDigit => '包含數字';

  @override
  String get changePasswordClear => '清空';

  @override
  String get changePasswordSubmit => '確認變更';

  @override
  String get validatorOldPasswordRequired => '請輸入舊密碼';

  @override
  String get validatorNewPasswordRequired => '請輸入新密碼';

  @override
  String get validatorNewPasswordMin6 => '至少 6 個字元';

  @override
  String get validatorNewPasswordMax32 => '最多 32 個字元';

  @override
  String get validatorConfirmRequired => '請確認新密碼';

  @override
  String get validatorConfirmMismatch => '兩次輸入不一致';

  @override
  String get changePasswordRulesTitle => '密碼要求';

  @override
  String get loginWelcomeTitle => '歡迎回來';

  @override
  String get loginSubtitle => '請登入您的筆記帳戶';

  @override
  String get loginEmailOrUsernameLabel => '電子郵件或使用者名稱';

  @override
  String get loginEmailOrUsernameHint => '請輸入電子郵件或使用者名稱';

  @override
  String get validatorLoginIdRequired => '請輸入電子郵件或使用者名稱';

  @override
  String get loginPasswordFieldLabel => '密碼';

  @override
  String get loginPasswordFieldHint => '請輸入密碼';

  @override
  String get validatorLoginPasswordRequired => '請輸入密碼';

  @override
  String get validatorLoginPasswordMin6 => '密碼長度至少 6 位';

  @override
  String get loginButton => '登入';

  @override
  String get createWalletPasswordPageTitle => '設定筆記帳戶密碼';

  @override
  String get createWalletPasswordSubtitle => '保護您的筆記安全';

  @override
  String get createWalletPasswordWhyTitle => '為什麼需要密碼？';

  @override
  String get createWalletPasswordWhyBody =>
      '筆記帳戶密碼用於加密安全密鑰與恢復短語，僅您可存取筆記。請務必記住，遺失後無法復原。';

  @override
  String get walletPasswordFieldLabel => '筆記帳戶密碼';

  @override
  String get walletPasswordFieldHint => '請輸入 6-32 位密碼';

  @override
  String get walletConfirmPasswordFieldLabel => '確認密碼';

  @override
  String get walletConfirmPasswordFieldHint => '請再次輸入密碼';

  @override
  String get walletPasswordImportantNotice => '重要提示';

  @override
  String get walletPasswordWarnBullets =>
      '• 密碼保護筆記帳戶安全\n• 請使用易記但難猜的密碼\n• 建議混合字母、數字與符號\n• 密碼遺失無法找回，請務必記住';

  @override
  String get createWalletPasswordSubmitCreate => '確認並建立筆記帳戶';

  @override
  String get createWalletPasswordSubmitReset => '確認並重設密碼';

  @override
  String get createWalletPasswordFooterAck => '確認即表示您了解密碼的重要性';

  @override
  String get walletPasswordRulesHeader => '密碼要求：';

  @override
  String get walletPasswordRuleLength632 => '6-32 個字元';

  @override
  String get walletPasswordRuleLetter => '包含字母';

  @override
  String get walletPasswordRuleNumberRecommended => '包含數字（建議）';

  @override
  String get walletPasswordRuleMatch => '兩次密碼一致';

  @override
  String get walletBootstrapImporting => '恢復筆記帳戶中...';

  @override
  String get walletBootstrapInitializing => '初始化筆記帳戶中...';

  @override
  String get passwordVerifyTitle => '驗證密碼';

  @override
  String get passwordVerifyDescription => '為保障安全，請輸入筆記帳戶密碼以繼續';

  @override
  String get passwordVerifyDescExportMnemonic => '檢視並匯出恢復短語前，請輸入筆記帳戶密碼';

  @override
  String get passwordVerifyDescExportPrivateKey => '檢視安全密鑰前，請輸入筆記帳戶密碼';

  @override
  String get passwordVerifyDescImportWallet => '恢復筆記帳戶前請驗證筆記帳戶密碼';

  @override
  String get passwordVerifyDescBackupMnemonic => '備份恢復短語前，請輸入筆記帳戶密碼';

  @override
  String get passwordVerifyDescCreateWallet => '建立筆記帳戶前請驗證筆記帳戶密碼';

  @override
  String get passwordVerifyDescDeleteWallet => '刪除筆記帳戶前請驗證筆記帳戶密碼';

  @override
  String get passwordVerifyDescMintNft => '鑄造 NFT 須驗證筆記帳戶密碼';

  @override
  String get passwordVerifyWalletPasswordLabel => '筆記帳戶密碼';

  @override
  String get passwordVerifyWalletPasswordHint => '請輸入筆記帳戶密碼';

  @override
  String get validatorWalletPasswordRequired => '請輸入密碼';

  @override
  String get passwordVerifyNoEncryptedData => '找不到加密資料，請重新設定密碼';

  @override
  String passwordVerifyFailedWithError(String error) {
    return '驗證失敗：$error';
  }

  @override
  String passwordVerifyLockoutMinutes(int minutes) {
    return '錯誤次數過多，請於 $minutes 分鐘後再試';
  }

  @override
  String passwordVerifyLockoutHours(int hours) {
    return '錯誤次數過多，請於 $hours 小時後再試';
  }

  @override
  String passwordVerifyWrongWithCount(int current, int max) {
    return '密碼錯誤（$current/$max）';
  }

  @override
  String passwordVerifyAttemptsBanner(int count, int remaining) {
    return '密碼錯誤 $count 次，剩餘 $remaining 次機會';
  }

  @override
  String passwordVerifyLockBanner(String time) {
    return '錯誤次數過多，請於 $time 後再試';
  }

  @override
  String passwordVerifyDurationHoursMinutes(int hours, int minutes) {
    return '$hours 小時 $minutes 分鐘';
  }

  @override
  String passwordVerifyDurationMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get passwordVerifySecurityTipsTitle => '安全提示';

  @override
  String passwordVerifySecurityTipsBody(int maxAttempts) {
    return '• 密碼長度 6-32 位\n• 請確認環境安全\n• 錯誤 $maxAttempts 次將暫時鎖定';
  }

  @override
  String get paste => '貼上';

  @override
  String get loadingDefault => '載入中…';

  @override
  String get walletLoadingTagline => 'BlockNote · 安全 · 可信 · 永久';

  @override
  String get walletLoadingStepConnecting => '連接區塊鏈網路…';

  @override
  String get walletLoadingStepVerifying => '驗證筆記帳戶資訊…';

  @override
  String get walletLoadingStepSyncing => '同步筆記資料…';

  @override
  String get walletLoadingStepComplete => '載入完成！';

  @override
  String get retry => '重試';

  @override
  String loadFailedWithError(String error) {
    return '載入失敗：$error';
  }

  @override
  String get selectEvmChainFirst => '請先選擇支援 EVM 的網路';

  @override
  String get noteNotFoundShort => '找不到筆記';

  @override
  String get createOrSelectWalletFirst => '請先建立或選擇筆記帳戶';

  @override
  String get privateKeyDecryptFailedHint => '無法取得安全密鑰，請確認密碼正確。若曾變更密碼，請重新使用恢復短語';

  @override
  String get uploadingIpfsAndMinting => '上傳至 IPFS 並鑄造中…';

  @override
  String ipfsFileUploadFailed(String details) {
    return 'IPFS 檔案上傳失敗：$details';
  }

  @override
  String onChainSuccessTx(String txHash) {
    return '上鏈成功：$txHash';
  }

  @override
  String get draftSavedIpfsRetry => '已儲存為草稿並替換為 IPFS 圖片，可稍後重試上鏈';

  @override
  String mintFailedGasDebug(String detail) {
    return '餘額不足（Gas）\n$detail';
  }

  @override
  String get mintFailedGasUser => '餘額不足，無法支付 Gas，請儲值後再試';

  @override
  String mintFailedGeneric(String error) {
    return '上鏈失敗：$error';
  }

  @override
  String get walletErrNoWalletYet => '請先建立或恢復筆記帳戶';

  @override
  String get walletErrUnrecognizedAccount => '無法辨識目前筆記帳戶';

  @override
  String get walletErrWalletDataNotFound => '找不到目前筆記帳戶資料';

  @override
  String get walletErrImportedMnemonicNoExport => '以恢復短語恢復的筆記帳戶無法在此再次匯出恢復短語';

  @override
  String get walletErrImportedMnemonicNoBackup => '以恢復短語恢復的筆記帳戶無需在此備份';

  @override
  String get walletErrPrivateKeyWalletNoMnemonic => '以安全密鑰恢復的筆記帳戶沒有恢復短語';

  @override
  String get walletErrNoEncryptedMnemonic => '此筆記帳戶沒有本地加密的恢復短語資料';

  @override
  String get walletErrDecryptFailed => '解密失敗，請確認密碼正確';

  @override
  String get walletErrMissingAddress => '缺少筆記帳戶地址';

  @override
  String get walletErrGetPrivateKeyFailed => '無法取得安全密鑰，請確認密碼正確';

  @override
  String get exportMnemonicDocTitle => '鏈上筆記 — 恢復短語備份';

  @override
  String exportMnemonicDocTime(String time) {
    return '產生時間：$time';
  }

  @override
  String get exportMnemonicDocLabel => '恢復短語（請妥善保管）：';

  @override
  String get exportMnemonicDocSecurity =>
      '⚠️ 安全提示：\n1. 請將此恢復短語保存在安全的地方\n2. 不要與任何人分享\n3. 遺失後將無法恢復筆記帳戶與資料';

  @override
  String get exportMnemonicUseCopyOnPlatform => '目前平台請使用複製';

  @override
  String exportMnemonicSavedTo(String path) {
    return '已儲存：$path';
  }

  @override
  String get walletBootstrapCreating => '建立筆記帳戶中…';

  @override
  String get chainNameEvm => 'EVM 鏈（Ethereum/BSC/Polygon 等）';

  @override
  String get chainPkDescEvm => '以 0x 開頭的 64 位十六進位字串，總長度 66 字元';

  @override
  String get chainNameBitcoin => 'Bitcoin';

  @override
  String get chainPkDescBitcoin => 'WIF 格式，以 5、K 或 L 開頭，長度 51–52 字元';

  @override
  String get chainNameSolana => 'Solana';

  @override
  String get chainPkDescSolana => 'Base58 編碼，長度約 87–88 字元，不含 0、O、I、l';

  @override
  String get chainNameTron => 'Tron';

  @override
  String get chainPkDescTronHex => '64 位十六進位字串（無 0x 前綴）';

  @override
  String get chainNameCosmos => 'Cosmos';

  @override
  String get chainPkDescCosmosHex => '64 位十六進位字串（無 0x 前綴）';

  @override
  String walletPkSubtitleLength(int count) {
    return '$count 位字元';
  }

  @override
  String walletPkSubtitleStartsWith(String prefix) {
    return '以 $prefix 開頭';
  }

  @override
  String get walletImportSelectChainTitle => '選擇區塊鏈類型';

  @override
  String get walletImportEvmOnlyNotice => '暫不支援，請使用 EVM 安全密鑰匯入';

  @override
  String get walletImportPageSubtitle => '使用恢復短語或安全密鑰還原筆記帳戶';

  @override
  String get walletImportTabMnemonic => '恢復短語';

  @override
  String get walletImportTabPrivateKey => '安全密鑰';

  @override
  String get walletImportInputMethod => '輸入方式';

  @override
  String get walletImportInputSingle => '單字輸入';

  @override
  String get walletImportInputPasteFull => '整句貼上';

  @override
  String get walletImportWordCountLabel => '恢復短語數量';

  @override
  String walletImportWordCountN(int n) {
    return '$n 個詞';
  }

  @override
  String get walletImportWordCountDialogTitle => '選擇助記詞數量';

  @override
  String get walletImportWordCountDialogDesc => 'BIP39標準支援多種助記詞長度，安全性隨詞數增加而提升';

  @override
  String walletImportWordCountOptionLabel(int count) {
    return '$count個助記詞';
  }

  @override
  String get walletImportWordCountSecurityLabel => '安全級別：';

  @override
  String get walletImportWordCountSecurityStandard => '標準';

  @override
  String get walletImportWordCountSecurityEnhanced => '增強';

  @override
  String get walletImportWordCountSecurityAdvanced => '高級';

  @override
  String get walletImportWordCountSecurityProfessional => '專業';

  @override
  String get walletImportWordCountSecurityMaximum => '極高';

  @override
  String walletImportWordCountSwitched(int n) {
    return '已切換到$n個詞';
  }

  @override
  String get walletImportWordCountDialogTip =>
      '大多數錢包使用12個詞的助記詞。如果您不確定，請選擇12個詞。';

  @override
  String get walletImportEnterMnemonic => '請輸入恢復短語';

  @override
  String get walletImportMnemonicPasteTip => '提示：可貼上整句恢復短語，請使用上方「整句貼上」';

  @override
  String get walletImportPasteMnemonicPrompt => '請貼上恢復短語';

  @override
  String walletImportMnemonicHintWords(int count) {
    return '請貼上 $count 個恢復短語，以空格分隔';
  }

  @override
  String get walletImportMnemonicWordFieldHint => '單字';

  @override
  String get walletImportMnemonicParagraphExampleHint =>
      'word1 word2 word3 ...';

  @override
  String get walletImportPrivateKeyFieldHint => '0x... 或 64 位十六進位';

  @override
  String get walletImportPrivateKeyFieldHintShort => '0x...';

  @override
  String walletImportWordProgress(int current, int total) {
    return '目前詞數：$current / $total';
  }

  @override
  String get walletImportMnemonicSecurityTitle => '安全提示';

  @override
  String get walletImportMnemonicSecurityBody =>
      '• 請在安全網路環境操作\n• 恢復短語遺失無法找回\n• 切勿向他人透露恢復短語\n• 我們不會在伺服器儲存您的恢復短語';

  @override
  String get walletImportSelectChainSection => '選擇區塊鏈類型';

  @override
  String get walletImportTapSwitchChain => '點擊切換鏈類型';

  @override
  String get walletImportEnterPrivateKey => '請輸入安全密鑰';

  @override
  String get walletImportPkFormatExample => '安全密鑰格式範例';

  @override
  String get walletImportPkSevereTitle => '嚴重警告';

  @override
  String get walletImportPkSevereBody =>
      '• 安全密鑰是筆記帳戶最高權限\n• 取得安全密鑰者可完全管理您的筆記\n• 請勿在不安全裝置輸入安全密鑰\n• 請勿截圖或透過聊天軟體傳送安全密鑰';

  @override
  String get walletImportConfirm => '確認恢復';

  @override
  String walletImportMnemonicNeedCount(int count) {
    return '請輸入完整的 $count 個恢復短語';
  }

  @override
  String walletImportMnemonicWrongCount(int count, int current) {
    return '請輸入 $count 個恢復短語，目前 $current 個';
  }

  @override
  String get walletImportMnemonicInvalidWords => '恢復短語格式不正確，請使用小寫英文單字';

  @override
  String get walletImportPkEmpty => '請輸入安全密鑰';

  @override
  String get walletImportPkNeed0x => '安全密鑰應以 0x 開頭';

  @override
  String get walletImportPkNeedWif => '安全密鑰應以 5、K 或 L 開頭';

  @override
  String get walletImportPkWifLength => '安全密鑰長度應為 51–52 字元';

  @override
  String walletImportPkLengthExpected(int length) {
    return '安全密鑰長度應為 $length 字元';
  }

  @override
  String get walletImportPkInvalidFormat => '安全密鑰格式不正確';

  @override
  String get walletImportEvmOnly => '目前僅支援 EVM 安全密鑰匯入';

  @override
  String get walletImportDeriveAddressFailed => '無法由安全密鑰推算地址，請檢查格式';

  @override
  String get walletImportDuplicatePk => '此安全密鑰對應地址已存在，請勿重複恢復';

  @override
  String get walletImportDuplicateMnemonic => '此恢復短語對應筆記帳戶已恢復，請勿重複恢復';

  @override
  String get walletImportInvalidPrivateKeyRetry => '安全密鑰無效，請檢查後重試';

  @override
  String get walletImportInvalidMnemonicRetry => '恢復短語無效，請檢查後重試';

  @override
  String get clipboardEmpty => '剪貼簿為空';

  @override
  String get mnemonicViewLengthTitle => '恢復短語長度';

  @override
  String get mnemonicViewInputMode => '輸入方式';

  @override
  String get mnemonicViewSingleWord => '單字輸入';

  @override
  String get mnemonicViewFullPaste => '整段貼上';

  @override
  String get mnemonicViewImportCta => '使用恢復短語';

  @override
  String mnemonicViewEnterOrdered(int count) {
    return '請依序輸入 $count 個恢復短語';
  }

  @override
  String get mnemonicViewPasteHint => '請貼上完整恢復短語，詞與詞之間以空格分隔';

  @override
  String mnemonicCountMismatch(int expected, int current) {
    return '請輸入 $expected 個恢復短語，目前 $current 個';
  }

  @override
  String get mnemonicInvalidBip39 => '無效的恢復短語，請檢查拼寫';

  @override
  String get walletSelectorTitle => '我的筆記帳戶';

  @override
  String get walletSelectorSubtitle => '管理您的所有筆記帳戶';

  @override
  String walletNumberedName(int n) {
    return '筆記帳戶 $n';
  }

  @override
  String get walletDefaultCreatedNameFirst => '我的筆記帳戶';

  @override
  String walletDefaultCreatedNameNumbered(int n) {
    return '我的筆記帳戶$n';
  }

  @override
  String get walletDefaultPrivateKeyNameFirst => '我的安全密鑰筆記帳戶';

  @override
  String walletDefaultPrivateKeyNameNumbered(int n) {
    return '我的安全密鑰筆記帳戶$n';
  }

  @override
  String get walletBackupNotYet => '尚未備份筆記帳戶';

  @override
  String get walletBackupPromptLine1 => '尚未備份筆記帳戶';

  @override
  String get walletBackupPromptLine2 => '點此立即備份恢復短語';

  @override
  String get walletDeleteConfirmTitle => '確認刪除筆記帳戶';

  @override
  String get walletDeleteConfirmLine1 => '刪除後無法復原，請確認已備份恢復短語。';

  @override
  String get walletDeleteConfirmLine2Notes => '此筆記帳戶關聯的本機筆記資料也會一併刪除。';

  @override
  String get walletDeleteCannotCurrent => '⚠️ 無法刪除目前使用的筆記帳戶';

  @override
  String get walletDeleteLastHint => '刪除後將無筆記帳戶，將返回引導頁重新建立或恢復。';

  @override
  String get walletEditNameSubtitle => '為筆記帳戶設定容易辨識的名稱';

  @override
  String get walletNameFieldLabel => '筆記帳戶名稱';

  @override
  String get walletNameFieldHint => '輸入筆記帳戶名稱';

  @override
  String get networkNodeAdd => '新增節點';

  @override
  String get networkNodeTest => '測試';

  @override
  String get networkNodeSetDefault => '設為預設';

  @override
  String get networkNodeOnline => '線上';

  @override
  String get networkNodeOffline => '離線';

  @override
  String get networkNodeConnectionFailed => '節點連線失敗';

  @override
  String get networkRpcUrlInvalid => '請輸入有效的 HTTP 或 HTTPS RPC URL';

  @override
  String get networkNodeDuplicate => '此節點已存在';

  @override
  String get networkNodeNameRpcRequired => '請輸入節點名稱與 RPC URL';

  @override
  String get networkNodeAdded => '節點新增成功';

  @override
  String get networkRpcCopied => '已複製 RPC URL';

  @override
  String get networkNodeSwitched => '已切換至此節點';

  @override
  String get networkNodeDeleted => '節點已刪除';

  @override
  String get networkSettingsTitle => '網路設定';

  @override
  String get networkSettingsSubtitle => '設定區塊鏈網路節點';

  @override
  String networkLoadFailed(String message) {
    return '載入失敗：$message';
  }

  @override
  String get networkSectionMainnet => '主網';

  @override
  String get networkSectionTestnet => '測試網路';

  @override
  String get networkTestnetListHint =>
      '應用程式內資料來源（ChainDatas）中標示為 testnet 的網路會出現在此清單。';

  @override
  String networkCountNetworks(int count) {
    return '$count 個網路';
  }

  @override
  String get networkAboutNodesTitle => '關於網路節點';

  @override
  String get networkAboutNodesBullet1 => 'RPC 節點是連接區塊鏈網路的入口';

  @override
  String get networkAboutNodesBullet2 => '您可以新增自訂節點以提升速度或可靠性';

  @override
  String get networkAboutNodesBullet3 => '建議使用可信的公開節點或自行架設的節點';

  @override
  String get networkStatusConnectionOk => '連線正常';

  @override
  String get networkStatusConnectionError => '連線異常';

  @override
  String get networkStatusCustomized => '已自訂';

  @override
  String networkNodeCountLabel(int count) {
    return '$count 個節點';
  }

  @override
  String networkAllNodesTitle(int count) {
    return '所有節點（$count）';
  }

  @override
  String networkDetailHeaderNodeCount(int count) {
    return '共有 $count 個節點';
  }

  @override
  String get networkQuickAddTitle => '快速新增節點';

  @override
  String get networkQuickAddLine1 => '點選任一網路進入詳情頁，即可新增自訂 RPC 節點。';

  @override
  String get networkQuickAddLine2 => '可新增多個節點；系統會保留清單以供後續擴充（例如自動選擇最快節點）。';

  @override
  String get networkNodeProbeOk => '節點連線正常';

  @override
  String networkNodeProbeOkLatency(int ms) {
    return '節點連線正常，延遲 $ms ms';
  }

  @override
  String get networkCurrentNodeTitle => '目前使用的節點';

  @override
  String get networkNodeActiveBadge => '活躍';

  @override
  String get networkNoNodeSelected => '未選擇節點';

  @override
  String networkNodeLatencyMs(int ms) {
    return '延遲 $ms ms';
  }

  @override
  String get networkAddRpcDialogTitle => '新增 RPC 節點';

  @override
  String networkAddRpcDialogSubtitle(String networkName) {
    return '為 $networkName 網路新增自訂 RPC 節點';
  }

  @override
  String get networkNodeNameLabel => '節點名稱';

  @override
  String get networkNodeNameHint => '例如：自訂節點 1';

  @override
  String get networkRpcUrlLabel => 'RPC URL';

  @override
  String get networkRpcUrlHint => 'https://…';

  @override
  String get networkExampleRpcLabel => '範例 RPC URL';

  @override
  String get networkConfirmAddNode => '確認新增';

  @override
  String get networkTipsTitle => '使用提示';

  @override
  String get networkTipsLine1 => '建議新增多個節點作為備援';

  @override
  String get networkTipsLine2 => '測試節點以查看連線狀態與延遲';

  @override
  String get networkTipsLine3 => '延遲較低的節點通常可加快交易';

  @override
  String get networkTipsLine4 => '預設節點（內建）無法刪除';

  @override
  String get networkNodeInUseBadge => '使用中';

  @override
  String get networkCannotDeleteDefaultNode => '預設節點無法刪除';

  @override
  String get networkDeleteSwitchNodeFirst => '請先切換到其他節點再刪除';

  @override
  String homeFiatApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String homeUnitPrice(String price) {
    return '單價：$price';
  }

  @override
  String get homeUnitPriceUnavailable => '單價：--';

  @override
  String get homeTransactionHistory => '創建筆記記錄';

  @override
  String get homeTransactionHistoryNotConfigured => '創建筆記記錄功能未設定';

  @override
  String get transactionHistorySubtitle => '檢視您的所有創建筆記記錄';

  @override
  String get transactionHistoryStatTotal => '總計';

  @override
  String get transactionHistoryStatSuccess => '成功';

  @override
  String get transactionHistoryStatPending => '待確認';

  @override
  String get transactionHistoryStatFailed => '失敗';

  @override
  String get transactionHistoryFilterAll => '全部';

  @override
  String get transactionHistoryFilterSend => '創建筆記';

  @override
  String get transactionHistoryFilterReceive => '接收';

  @override
  String get transactionHistorySelectChain => '選擇網路';

  @override
  String get transactionHistoryCopied => '已複製到剪貼簿';

  @override
  String get transactionHistoryExplorerInvalidUrl => '無效的瀏覽器連結';

  @override
  String get transactionHistoryExplorerLaunchFailed => '無法開啟瀏覽器，請檢查系統設定';

  @override
  String transactionHistoryExplorerOpenError(String error) {
    return '開啟失敗：$error';
  }

  @override
  String get transactionHistoryRefreshed => '創建筆記記錄已更新';

  @override
  String get transactionHistoryTimeJustNow => '剛剛';

  @override
  String transactionHistoryTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分鐘前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小時前',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String get transactionHistoryEmptyTitle => '暫無創建筆記記錄';

  @override
  String get transactionHistoryEmptyHintFiltered => '沒有找到相符的創建筆記記錄';

  @override
  String get transactionHistoryEmptyHintAll => '目前沒有任何創建筆記記錄';

  @override
  String get transactionHistoryTypeSend => '創建筆記';

  @override
  String get transactionHistoryTypeReceive => '接收';

  @override
  String get transactionHistoryStatusSuccess => '成功';

  @override
  String get transactionHistoryStatusFailed => '失敗';

  @override
  String get transactionHistoryStatusPending => '待確認';

  @override
  String get transactionHistoryDetailFrom => '發送方';

  @override
  String get transactionHistoryDetailTo => '接收方';

  @override
  String get transactionHistoryDetailTxHash => '上鏈雜湊';

  @override
  String get transactionHistoryDetailBlock => '區塊高度';

  @override
  String transactionHistoryGasLine(String fee, String symbol) {
    return 'Gas: $fee $symbol';
  }

  @override
  String homeGasBalanceTitle(String symbol) {
    return '$symbol 燃料費餘額';
  }

  @override
  String get homeTotalAssets => '總餘額';

  @override
  String get homeRefreshBalance => '重新整理餘額';

  @override
  String get homeGetGas => '取得燃料費';

  @override
  String get homeGasHelp => '燃料費用於支付交易上鏈的 Gas 費用，請確保餘額充足';

  @override
  String getGasDialogTitle(String symbol) {
    return '取得 $symbol 燃料費';
  }

  @override
  String getGasDialogSubtitle(String chainName) {
    return '選擇一種方式為您的 $chainName 筆記帳戶充值';
  }

  @override
  String get getGasOptionReceiveTitle => '接收代幣';

  @override
  String get getGasBadgeRecommended => '推薦';

  @override
  String getGasReceiveHint(String symbol) {
    return '從其他筆記帳戶或交易所轉入 $symbol';
  }

  @override
  String get getGasWalletAddressLabel => '筆記帳戶地址';

  @override
  String get getGasShowQr => '二維碼';

  @override
  String get getGasHideQr => '隱藏';

  @override
  String getGasTransferWarning(String chainName) {
    return '請確保轉帳網路為 $chainName，否則筆記可能遺失';
  }

  @override
  String get getGasFaucetTitle => '測試網水龍頭';

  @override
  String get getGasBadgeFree => '免費';

  @override
  String getGasFaucetHint(String symbol) {
    return '從水龍頭免費領取測試網 $symbol';
  }

  @override
  String getGasFaucetOpen(int index) {
    return '前往水龍頭連結 $index';
  }

  @override
  String get getGasBuyExchangeTitle => '從交易所購買';

  @override
  String get getGasBadgeComingSoon => '即將推出';

  @override
  String getGasBuyExchangeHint(String symbol) {
    return '透過交易所購買 $symbol 並提領到筆記帳戶';
  }

  @override
  String get getGasDialogCancel => '取消';

  @override
  String get getGasAddressCopied => '地址已複製';

  @override
  String get getGasInvalidLink => '無效的連結';

  @override
  String get getGasCouldNotOpenLink => '無法開啟連結，請確認已安裝瀏覽器';

  @override
  String getGasOpenFailed(String error) {
    return '開啟失敗：$error';
  }

  @override
  String get homeRecentNotes => '最近筆記';

  @override
  String get homeRefreshRecentNotes => '重新整理最近筆記';

  @override
  String get homeLoadingOnChainNotes => '正在載入鏈上筆記';

  @override
  String get homeSyncingOnChainNotes => '正在同步鏈上筆記…';

  @override
  String get homeNoNotesInLastMonth => '最近一個月都沒有筆記了';

  @override
  String get homeCreateNewNotePrompt => '快來建立您的新筆記';

  @override
  String get notesAllChains => '全部鏈';

  @override
  String get notesSwitchedToAllChains => '已切換到全部鏈';

  @override
  String get notesFilterAll => '全部';

  @override
  String get notesFilterOnChain => '已上鏈';

  @override
  String get notesFilterOffChain => '未上鏈';

  @override
  String get notesSortNewest => '最新';

  @override
  String get notesSortUpdated => '更新';

  @override
  String get notesSortOldest => '最早';

  @override
  String get notesSortTitle => '標題';

  @override
  String notesTimelineNoteCount(int count) {
    return '$count 篇';
  }

  @override
  String get noteStatsTotalNotes => '總筆記';

  @override
  String get noteStatsOnChainCount => '已上鏈';

  @override
  String get noteStatsImages => '圖片數';

  @override
  String get noteStatsChars => '總字數';

  @override
  String get noteDeleteNote => '刪除筆記';

  @override
  String get noteDeleteConfirmTitle => '刪除筆記？';

  @override
  String get noteDeleteConfirmBody => '確定要刪除這則筆記嗎？刪除後無法復原。';

  @override
  String get noteDeletedSnackbar => '筆記已刪除';

  @override
  String noteDeleteFailed(String error) {
    return '刪除失敗：$error';
  }

  @override
  String noteUpdatedAt(String date) {
    return '更新於 $date';
  }

  @override
  String noteCreatedAt(String date) {
    return '建立於 $date';
  }

  @override
  String get noteNoContent => '暫無內容';

  @override
  String get noteEditorCreateNewNote => '建立新筆記';

  @override
  String noteEditorChainLine(String chainName) {
    return '$chainName 鏈';
  }

  @override
  String get noteEditorSelectChainToPublish => '選擇鏈後可上鏈';

  @override
  String get noteEditorSave => '儲存';

  @override
  String get noteEditorSaving => '儲存中';

  @override
  String get noteTitleLabel => '標題';

  @override
  String get noteTitleHint => '為筆記取個標題…';

  @override
  String get noteCoverImages => '封面圖片（可選）';

  @override
  String get noteCoverAdd => '新增封面';

  @override
  String get noteCoverUploading => '上傳中';

  @override
  String get noteCoverTapUpload => '點擊上傳封面圖片';

  @override
  String get noteCoverFormatsHint => '支援 JPG、PNG 等格式';

  @override
  String get noteRichTextGuideTitle => '富文字編輯功能';

  @override
  String get noteRichTextHeadingLabel => '標題：';

  @override
  String get noteRichTextHeadingBody => '點選工具列「標題」按鈕插入數字標題。';

  @override
  String get noteRichTextListLabel => '清單：';

  @override
  String get noteRichTextListBody => '插入專案符號或編號清單。';

  @override
  String get noteRichTextEmojiLabel => 'Emoji：';

  @override
  String get noteRichTextEmojiBody => '快速插入常用表情與狀態標記。';

  @override
  String get noteRichTextTemplateLabel => '範本：';

  @override
  String get noteRichTextTemplateBody => '選擇預設範本快速開始撰寫。';

  @override
  String get noteRichTextImageLabel => '圖片：';

  @override
  String get noteRichTextImageBody => '點選工具列圖片按鈕，直接插入到內文。';

  @override
  String get noteRichTextPreviewHint => '提示：切換到「預覽」可查看排版效果。';

  @override
  String get noteEditorContentPlaceholder =>
      '在這裡記錄想法、靈感、計畫…\n\n提示：使用工具列可快速插入：\n• 標題與清單\n• Emoji 與特殊符號\n• 快速範本\n• 圖片\n\n支援富文字格式，詳情頁會自動美化顯示！';

  @override
  String get noteTipsTitle => '創作提示';

  @override
  String get noteTipsBody =>
      '• 為筆記取個有意義的標題\n• 記錄想法、計畫或重要資訊\n• 可新增圖片讓內容更豐富\n• 儲存後可選擇上鏈永久保存';

  @override
  String get noteReadyTitle => '準備就緒';

  @override
  String get noteReadyBody => '內容已填寫，點選右上角「儲存」即可建立筆記。';

  @override
  String get noteTypeSectionLabel => '筆記類型：';

  @override
  String get notePublishToChain => '發布到鏈上';

  @override
  String get notePublishing => '上鏈中…';

  @override
  String get noteOnChainPublished => '已上鏈';

  @override
  String get selectBlockchainFirst => '請先選擇區塊鏈網路';

  @override
  String get noteImageAdded => '已新增圖片';

  @override
  String get noteImagePickFailed => '選擇圖片失敗';

  @override
  String get noteSavedToLocal => '已儲存到本機';

  @override
  String get notePublishFailedKeptDraft => '上鏈失敗，已儲存為草稿';

  @override
  String get noteSavedAsDraft => '已儲存為草稿';

  @override
  String get richTextPreviewMode => '預覽模式';

  @override
  String get richTextEditMode => '編輯模式';

  @override
  String get richTextPreview => '預覽';

  @override
  String get richTextEdit => '編輯';

  @override
  String richTextLineCount(int count) {
    return '$count 行';
  }

  @override
  String richTextCharCount(int count) {
    return '$count 字元';
  }

  @override
  String get richTextToolbarBottomHint => '提示：使用工具列快速插入格式，或手動輸入 emoji 與特殊符號。';

  @override
  String get richTextToolbarHeading => '標題';

  @override
  String get richTextTooltipInsertHeading => '插入標題';

  @override
  String get richTextTooltipBulletList => '插入清單';

  @override
  String get richTextTooltipNumberedList => '插入編號清單';

  @override
  String get richTextTooltipStatusMarkers => '插入狀態標記';

  @override
  String get richTextToolbarEmojiMenu => '表情';

  @override
  String get richTextTooltipInsertEmoji => '插入表情';

  @override
  String get richTextToolbarTemplate => '範本';

  @override
  String get richTextTooltipQuickTemplate => '快速範本';

  @override
  String get richTextTooltipAddImage => '新增圖片';

  @override
  String get richTextMdImageAlt => '圖片';

  @override
  String get richTextInsertNumberedHeading => '\n1️⃣ 標題\n';

  @override
  String get richTextInsertBulletLines => '\n• 清單項 1\n• 清單項 2\n• 清單項 3\n';

  @override
  String get richTextInsertNumberedLines => '\n1. 第一項\n2. 第二項\n3. 第三項\n';

  @override
  String get richTextInsertStatusMarkers => '\n🟢 已完成\n🔵 進行中\n🟡 待處理\n';

  @override
  String get richTextEmojiGroupNumberedTitle => '數字標題';

  @override
  String get richTextEmojiGroupStatus => '狀態標記';

  @override
  String get richTextEmojiGroupSymbols => '常用符號';

  @override
  String get richTextEmojiGroupEmoji => '表情';

  @override
  String get richTextEmojiHeadingWord => '標題';

  @override
  String get richTextEmojiBodyWord => '內容';

  @override
  String get richTextTplStandardNoteName => '📝 標準筆記';

  @override
  String get richTextTplStandardNoteBody =>
      '標題\n\n主要內容：\n• 要點 1\n• 要點 2\n• 要點 3\n\n總結：\n';

  @override
  String get richTextTplTaskName => '✅ 任務清單';

  @override
  String get richTextTplTaskBody =>
      '任務清單\n\n今日任務：\n✓ 已完成\n✗ 未完成\n→ 進行中\n\n備註：\n';

  @override
  String get richTextTplStudyName => '📚 學習筆記';

  @override
  String get richTextTplStudyBody =>
      '學習筆記 - 主題\n\n1️⃣ 關鍵概念\n• 概念 1：說明\n• 概念 2：說明\n\n2️⃣ 重點整理\n• 要點 1\n• 要點 2\n\n3️⃣ 實作應用\n';

  @override
  String get richTextTplIdeaName => '💡 靈感紀錄';

  @override
  String get richTextTplIdeaBody =>
      '💡 靈感紀錄\n\n想法：\n🟢 核心想法描述\n\n優勢：\n• 優點 1\n• 優點 2\n\n下一步：\n→ 行動計畫\n';

  @override
  String get richTextTplProjectName => '📊 專案規劃';

  @override
  String get richTextTplProjectBody =>
      '專案規劃\n\n🎯 目標：\n\n📝 計畫：\n1. 第一步\n2. 第二步\n3. 第三步\n\n⏰ 時間線：\n';

  @override
  String get gasPreviewTitle => 'Gas 費用預覽';

  @override
  String get gasPreviewSubtitle => '請選擇 Gas 速度一併確認上鏈。';

  @override
  String get gasPreviewLoading => '正在取得 Gas 費用…';

  @override
  String get gasPreviewPickSpeed => '選擇 Gas 速度';

  @override
  String get gasPreviewLiveRates => '即時費率';

  @override
  String get gasSpeedSlow => '慢速';

  @override
  String get gasSpeedStandard => '標準';

  @override
  String get gasSpeedFast => '快速';

  @override
  String get gasTimeSlow => '約 3–5 分鐘';

  @override
  String get gasTimeStandard => '約 1–2 分鐘';

  @override
  String get gasTimeFast => '約 15–30 秒';

  @override
  String get gasDescSlow => 'baseFee×1.1；小費 = max(30 Gwei, 網路建議) + 3 Gwei';

  @override
  String get gasDescStandard => 'baseFee×1.25；小費 = max(30 Gwei, 網路建議) + 8 Gwei';

  @override
  String get gasDescFast => 'baseFee×1.5；小費 = max(30 Gwei, 網路建議) + 20 Gwei';

  @override
  String get gasLabelGasPrice => 'Gas 價格';

  @override
  String get gasLabelEstCost => '預計費用';

  @override
  String get gasRecommendedBadge => '推薦';

  @override
  String gasPreviewGweiMax(String value) {
    return '$value Gwei（上限）';
  }

  @override
  String get gasFeeBreakdownTitle => '費用明細';

  @override
  String get gasFeeRowBase => '基礎費用';

  @override
  String get gasFeeRowPriority => '優先費用';

  @override
  String get gasFeeRowNoteSize => '筆記大小';

  @override
  String get gasFeeRowTotal => '總費用';

  @override
  String gasFeeNoteSizeKb(String kb) {
    return '$kb KB';
  }

  @override
  String get gasWarningTitle => '溫馨提示';

  @override
  String get gasWarningBody =>
      '• Gas 費用由區塊鏈網路收取，與應用程式無關\n• 實際費用可能因網路壅塞略有浮動\n• 上鏈後的筆記無法刪除或修改';

  @override
  String get gasConfirmOnChain => '確認上鏈';

  @override
  String get gasOnChainConfirmDialogTitle => '上鏈後無法修改';

  @override
  String get gasOnChainConfirmDialogBody =>
      '目前筆記將寫入區塊鏈（IPFS + 鏈上存證），\n一經送出即無法刪除或修改，請確認內容無誤後再繼續。';

  @override
  String get gasOnChainConfirmDialogQuestion => '是否確認上鏈？';

  @override
  String get onChainConfirmParamSummarySectionTitle => '參數摘要';

  @override
  String get noteOnChainParamJsonKeyNetwork => '網路';

  @override
  String get noteOnChainParamJsonKeyChainId => '鏈 ID';

  @override
  String get noteOnChainParamJsonKeyFeeToken => 'Gas 支付代幣';

  @override
  String get noteOnChainParamJsonKeySender => '發起地址（你的筆記帳戶）';

  @override
  String get noteOnChainParamJsonKeyContract => '合約地址';

  @override
  String get noteOnChainParamJsonKeyContractName => '合約名稱';

  @override
  String get noteOnChainParamJsonKeyFunction => '呼叫方法';

  @override
  String get noteOnChainParamJsonKeyNoteTitle => '筆記標題';

  @override
  String get noteOnChainParamJsonKeyContentSha256 => '正文指紋 SHA-256';

  @override
  String get noteOnChainParamJsonGroupMintCall => '上鏈調用（合約參數）';

  @override
  String get noteOnChainParamJsonGroupContext => '當前可核對資訊';

  @override
  String get noteOnChainParamJsonValueUriPending =>
      '安全驗證確認並上傳至 IPFS 後填入實際 ipfs:// 位址';

  @override
  String get noteOnChainConfirmPageTitle => '確認筆記上鏈';

  @override
  String get noteOnChainConfirmPageSubtitle => '將筆記永久儲存到區塊鏈';

  @override
  String get noteOnChainConfirmNoExplorer => '目前網路未設定區塊瀏覽器，無法查看合約';

  @override
  String get noteOnChainConfirmMintStatusUncertain => '上鏈狀態異常，請稍後在筆記或瀏覽器中核對';

  @override
  String get noteOnChainConfirmSignButton => '確認並安全驗證';

  @override
  String get noteOnChainConfirmTipTitle => '上鏈提示';

  @override
  String get noteOnChainConfirmTipBody =>
      '• 上鏈後無法修改或刪除筆記\n• 筆記將永久上鏈，歸你所有\n• 需要支付少量 Gas 費用，僅一次';

  @override
  String get noteOnChainConfirmNoteContentSection => '筆記內容';

  @override
  String get noteOnChainConfirmNoteTitleLabel => '標題';

  @override
  String get noteOnChainConfirmContentPreview => '內容預覽';

  @override
  String get noteOnChainConfirmNoteHashLabel => '筆記雜湊 (SHA-256)';

  @override
  String get noteOnChainConfirmChainDetailsSection => '上鏈詳情';

  @override
  String get noteOnChainConfirmMyWallet => '我的筆記帳戶';

  @override
  String get noteOnChainConfirmTargetContract => '目標合約';

  @override
  String get noteOnChainConfirmContractOwnershipHint =>
      '合約負責鑄造筆記（NFT），筆記（NFT）最終歸屬於你的筆記帳戶，你擁有筆記的永久所有權';

  @override
  String noteOnChainConfirmNoteRecipientAddress(String address) {
    return '筆記接收地址：$address';
  }

  @override
  String get noteOnChainConfirmNetworkFee => '網路費用';

  @override
  String get noteOnChainConfirmGasPriceLabel => 'Gas 單價';

  @override
  String get noteOnChainConfirmGasLimitLabel => 'Gas 上限';

  @override
  String get noteOnChainConfirmOnChainFee => '上鏈費用';

  @override
  String get noteOnChainConfirmGasOnlyHint => '僅需支付 Gas';

  @override
  String get noteOnChainConfirmAdvancedSection => '進階詳情';

  @override
  String get noteOnChainConfirmNonceLabel => 'Nonce';

  @override
  String get noteOnChainConfirmNetworkLabel => '網路';

  @override
  String get noteOnChainConfirmGasSlow => '慢速';

  @override
  String get noteOnChainConfirmGasNormal => '標準';

  @override
  String get noteOnChainConfirmGasFast => '快速';

  @override
  String get noteOnChainConfirmGasTimeSlow => '約 5 分鐘';

  @override
  String get noteOnChainConfirmGasTimeNormal => '約 1 分鐘';

  @override
  String get noteOnChainConfirmGasTimeFast => '約 15 秒';

  @override
  String get saveOptionsTitle => '選擇儲存方式';

  @override
  String get saveOptionsSubtitle => '依需求選擇合適的儲存方式';

  @override
  String get saveOnChainTitle => '上鏈儲存';

  @override
  String get saveOnChainDescription => '永久儲存在區塊鏈，不可篡改';

  @override
  String get saveOnChainFeature1 => '永久儲存';

  @override
  String get saveOnChainFeature2 => '可驗證';

  @override
  String get saveOnChainFeature3 => '去中心化';

  @override
  String get ipfsUploadConfirmTitle => '上傳到 IPFS';

  @override
  String get ipfsUploadConfirmBody =>
      '目前筆記含有本機圖片，上鏈前需先上傳至去中心化儲存（IPFS）。上傳後可在後續步驟寫入區塊鏈。\n\n是否將相關內容上傳到 IPFS 並繼續？';

  @override
  String get saveBadgeSecure => '安全';

  @override
  String get saveDraftTitle => '儲存為草稿';

  @override
  String get saveDraftDescription => '稍後再編輯，不佔用鏈上資源';

  @override
  String get saveDraftFeature1 => '隨時編輯';

  @override
  String get saveDraftFeature2 => '本機儲存';

  @override
  String get saveDraftFeature3 => '快速儲存';

  @override
  String get saveBadgeRecommended => '推薦';

  @override
  String get saveLocalTitle => '儲存到本機';

  @override
  String get saveLocalDescription => '完成編輯，僅儲存在裝置上';

  @override
  String get saveLocalFeature1 => '離線可用';

  @override
  String get saveLocalFeature2 => '即時儲存';

  @override
  String get saveLocalFeature3 => '零費用';

  @override
  String saveWillPublishToChain(String chainName) {
    return '將儲存到 $chainName';
  }

  @override
  String get guideWelcomeTitle => '歡迎使用鏈上筆記';

  @override
  String get guideWelcomeSubtitle => '開始之前，讓我們設定您的數位筆記帳戶';

  @override
  String get guideSecurityTitle => '您的資料，您做主';

  @override
  String get guideSecurityBody =>
      '筆記帳戶安全密鑰完全由您掌控，我們不會在伺服器上儲存任何敏感資訊。請務必妥善保管恢復短語與安全密鑰。';

  @override
  String get guideCreateWalletTitle => '建立新筆記帳戶';

  @override
  String get guideCreateWalletSubtitle => '全新開始，系統將為您產生新的筆記帳戶地址與恢復短語';

  @override
  String get guideRecommendedNewUser => '推薦新使用者';

  @override
  String get guideImportWalletTitle => '恢復現有筆記帳戶';

  @override
  String get guideImportWalletSubtitle => '使用恢復短語或安全密鑰恢復您已有的筆記帳戶';

  @override
  String get guideTagMnemonic => '恢復短語';

  @override
  String get guideTagPrivateKey => '安全密鑰';

  @override
  String get guideICloudRestoreTitle => '從 iCloud 還原';

  @override
  String get guideICloudRestoreSubtitle => '若您先前在 iCloud 備份過筆記帳戶，可快速還原';

  @override
  String get guideBadgeIosOnly => '僅限 iOS 裝置';

  @override
  String get guideGoogleRestoreTitle => '從 Google Drive 還原';

  @override
  String get guideGoogleRestoreSubtitle => '若您先前在 Google Drive 備份過筆記帳戶，可快速還原';

  @override
  String get guideBadgeAllDevices => '支援所有裝置';

  @override
  String get guideFooterHint => '選擇任一方式繼續使用鏈上筆記\n您的安全密鑰將安全儲存在本機裝置中';

  @override
  String get guideProviderICloud => 'iCloud';

  @override
  String get guideProviderGoogleDrive => 'Google Drive';

  @override
  String get guideLoadingWalletMessage => '載入筆記帳戶…';

  @override
  String googlePlayReviewModeTapHint(int remaining) {
    return '再點擊 $remaining 次進入審核模式';
  }

  @override
  String get helpCenter => '說明中心';

  @override
  String get helpCenterSubtitle => '常見問題與使用指南';

  @override
  String get helpSectionQuickGuide => '快速指南';

  @override
  String get helpSectionFaq => '常見問題';

  @override
  String get helpSearchHint => '搜尋問題…';

  @override
  String get helpCategoryAll => '全部';

  @override
  String get helpCategoryBasics => '基礎使用';

  @override
  String get helpCategoryBlockchain => '區塊鏈';

  @override
  String get helpCategoryWalletSecurity => '筆記帳戶安全';

  @override
  String get helpCategoryWalletMgmt => '筆記帳戶管理';

  @override
  String get helpCategoryAdvanced => '進階功能';

  @override
  String get helpCategoryCommon => '常見問題';

  @override
  String get helpComingSoon => '敬請期待';

  @override
  String get helpEmptyTitle => '找不到相關問題';

  @override
  String get helpEmptySubtitle => '試試其他關鍵字或聯絡客服';

  @override
  String get helpContactTitle => '聯絡客服';

  @override
  String get helpContactSubtitle => '找不到答案？請寄信給我們';

  @override
  String get helpContactSendFeedback => '傳送意見';

  @override
  String get helpContactYourEmailOptional => '您的電子郵件（選填）';

  @override
  String get helpContactEmailHint => '';

  @override
  String get helpContactMessageLabel => '意見內容';

  @override
  String get helpContactMessageHint => '請描述您遇到的問題或建議…';

  @override
  String get helpContactSending => '傳送中…';

  @override
  String get helpContactSend => '傳送';

  @override
  String get helpCopySupportEmail => '已複製電子郵件地址';

  @override
  String get helpFeedbackEmpty => '請輸入意見內容';

  @override
  String get helpFeedbackThanks => '感謝您的意見！';

  @override
  String get helpFeedbackMailFailed => '無法開啟郵件，請稍後再試';

  @override
  String get helpFeedbackMailSubject => '使用者意見';

  @override
  String get helpQuickGuide1Title => '快速入門';

  @override
  String get helpQuickGuide1Desc => '5 分鐘了解鏈上筆記的基本功能';

  @override
  String get helpQuickGuide2Title => '建立第一篇筆記';

  @override
  String get helpQuickGuide2Desc => '建立並上鏈儲存筆記的步驟說明';

  @override
  String get helpQuickGuide3Title => '備份恢復短語';

  @override
  String get helpQuickGuide3Desc => '確保您的筆記與資料安全';

  @override
  String get helpQuickGuide4Title => '管理多個筆記帳戶';

  @override
  String get helpQuickGuide4Desc => '建立、恢復與切換筆記帳戶';

  @override
  String get helpFaq1Question => '什么是鏈上笔记？';

  @override
  String get helpFaq1Answer =>
      '鏈上笔记是一个基于區塊鏈技术的笔记应用。您可以将笔记永久保存到區塊鏈上，實現数据的不可篡改和永久保存。笔记一旦上鏈，任何人都无法修改或删除，确保内容的真实性和可追溯性。';

  @override
  String get helpFaq2Question => '如何创建一条新笔记？';

  @override
  String get helpFaq2Answer =>
      '您可以通過以下方式创建笔记：\n1. 在首页點擊“创建笔记”按钮\n2. 在笔记頁面點擊右下角的“+”按钮\n3. 创建后可以添加标题、内容和图片';

  @override
  String get helpFaq3Question => '笔记有哪些保存方式？';

  @override
  String get helpFaq3Answer =>
      '系统提供三种保存方式：\n1. 保存为草稿：本地保存，可随时编辑\n2. 保存到本地：完成编辑，本地存储\n3. 上鏈保存：永久保存到區塊鏈，不可修改\n\n建议先保存为草稿，确认内容无误后再選择上鏈保存。';

  @override
  String get helpFaq4Question => '什么是上鏈保存？需要付费吗？';

  @override
  String get helpFaq4Answer =>
      '上鏈保存是指将笔记内容通過區塊鏈技术永久存储。上鏈需要支付 Gas 费用（網路手续费），这是由區塊鏈網路收取的，并非应用费用。不同區塊鏈網路的 Gas 费用不同，通常 L2 網路（如 Arbitrum、Optimism）的费用更低。';

  @override
  String get helpFaq5Question => '支持哪些區塊鏈網路？';

  @override
  String get helpFaq5Answer =>
      '目前支持 8 条主流區塊鏈：\n• Ethereum（以太坊主网）\n• BSC（幣安智能鏈）\n• Polygon（马蹄鏈）\n• Arbitrum（L2 網路）\n• Optimism（L2 網路）\n• Avalanche（雪崩鏈）\n• Fantom（FTM 鏈）\n• Base（Base 鏈）\n\n您可以在首页随时切换網路。';

  @override
  String get helpFaq6Question => '如何驗證笔记是否真的上鏈了？';

  @override
  String get helpFaq6Answer =>
      '笔记上鏈后会生成區塊鏈哈希值（Hash），您可以：\n1. 在笔记详情页查看哈希值\n2. 點擊“驗證”按钮查看完整的區塊鏈信息\n3. 复制哈希值到对应鏈的區塊鏈瀏覽器查询\n\n系统会显示该笔记在區塊鏈上的完整記錄。';

  @override
  String get helpFaq7Question => '什么是恢復短語？为什么要备份？';

  @override
  String get helpFaq7Answer =>
      '恢復短語是恢復筆記帳戶的唯一憑證，通常由 12 個英文單詞組成。它是您筆記帳戶的「主密鑰」。\n\n重要性：\n• 恢復短語遺失 = 筆記帳戶永久遺失\n• 恢復短語外洩 = 筆記可能永久遺失或被他人管理\n• 應用程式無法幫您找回恢復短語\n\n務必妥善保管，建議抄寫在紙上保存在安全的地方。';

  @override
  String get helpFaq8Question => '如何备份恢復短語？';

  @override
  String get helpFaq8Answer =>
      '备份恢復短語的步骤：\n1. 進入“我的”頁面\n2. 點擊“备份恢復短語”\n3. 阅读安全提示\n4. 抄写 12 个恢復短語\n5. 按顺序驗證恢復短語\n6. 完成备份\n\n注意：请在安全的环境下备份，确保无人窥视。';

  @override
  String get helpFaq9Question => '安全密鑰和恢復短語有什麼區別？';

  @override
  String get helpFaq9Answer =>
      '恢復短語和安全密鑰都可以恢復筆記帳戶，但有所不同：\n\n恢復短語：\n• 12 個英文單詞\n• 易於抄寫和記憶\n• 可以派生多個安全密鑰\n• 推薦的備份方式\n\n安全密鑰：\n• 64 位十六進制字串\n• 難以記憶\n• 對應單個地址\n• 適合進階用戶';

  @override
  String get helpFaq10Question => '如何切换筆記帳戶？';

  @override
  String get helpFaq10Answer =>
      '切换筆記帳戶的方法：\n1. 點擊首页顶部的筆記帳戶地址\n2. 在弹出的筆記帳戶選择器中選择要切换的筆記帳戶\n3. 或點擊“筆記帳戶管理”建立/恢復新筆記帳戶\n\n系统支持管理多个筆記帳戶，可随时切换。';

  @override
  String get helpFaq11Question => '如何查看不同鏈的地址？';

  @override
  String get helpFaq11Answer =>
      '在“我的筆記帳戶”頁面：\n1. 點擊筆記帳戶卡片右侧的下拉箭头\n2. 会展開显示所有支持的 8 条鏈\n3. 每条鏈都显示对应的地址\n4. 點擊地址可以快速复制\n\n注意：同一个筆記帳戶在不同鏈上的地址是相同的（EVM 兼容鏈）。';

  @override
  String get helpFaq12Question => '如何自定义 RPC 节点？';

  @override
  String get helpFaq12Answer =>
      '自定义 RPC 节点的步骤：\n1. 進入“我的”→“網路設定”\n2. 選择要配置的網路\n3. 點擊“添加节点”按钮\n4. 输入节点名称和 RPC URL\n5. 测试连接\n6. 设为默认节点\n\n自定义节点可以提高连接速度和稳定性。';

  @override
  String get helpFaq13Question => '富文本编辑器支持哪些格式？';

  @override
  String get helpFaq13Answer =>
      '富文本编辑器支持多种格式：\n• 粗体、斜体、下划线\n• 标题（H1-H3）\n• 有序列表、无序列表\n• 引用块\n• 代码块\n• 图片上传\n\n使用工具栏按钮即可快速格式化文本。';

  @override
  String get helpFaq14Question => '上鏈后的笔记可以修改或删除吗？';

  @override
  String get helpFaq14Answer =>
      '不可以。这正是區塊鏈技术的特点：\n\n上鏈后：\n• 内容永久保存\n• 无法修改\n• 无法删除\n• 任何人都无法篡改\n\n因此建议：\n1. 先保存为草稿反复修改\n2. 确认无误后再上鏈\n3. 敏感信息不要上鏈';

  @override
  String get helpFaq15Question => '为什么上鏈需要等待？';

  @override
  String get helpFaq15Answer =>
      'Gas 费用确认后，笔记会提交到區塊鏈網路。等待时间取决于：\n\n1. 網路拥堵程度\n2. 您選择的 Gas 速度\n   • 快速：15-30 秒\n   • 标准：1-2 分鐘\n   • 慢速：3-5 分鐘\n3. 区块确认时间\n\n通常 1-2 分鐘即可完成。';

  @override
  String get helpFaq16Question => '忘记密码怎么办？';

  @override
  String get helpFaq16Answer =>
      '如果忘记密码：\n\n1. 可以使用恢復短語重新恢復筆記帳戶\n2. 恢復後重新設定密码\n3. 原有的笔记数据会保留\n\n重要提醒：\n• 密码用于本地加密\n• 恢復短語是最终凭证\n• 务必备份恢復短語';

  @override
  String helpFeedbackMailBody(String email, String message) {
    return '聯絡電子郵件：$email\n\n$message';
  }

  @override
  String get termsOfServiceLastUpdatedLabel => '最近更新';

  @override
  String get termsOfServiceIntroTitle => '重要提示';

  @override
  String termsOfServiceIntroBody(String privacyDoc) {
    return '請仔細閱讀本服務條款及$privacyDoc。使用本服務即表示您理解並同意相關規則。若不同意，請勿使用本服務。';
  }

  @override
  String get termsOfServiceHelpTitle => '需要協助？';

  @override
  String get termsOfServiceHelpBody =>
      '若對本條款有疑問，請前往應用程式內說明中心，或透過設定中的意見回饋、電子郵件與我們聯絡。我們將於合理時間內盡力答覆。';

  @override
  String get termsOfServiceHelpMailFeedback => '電子郵件意見回饋';

  @override
  String get termsOfServiceSection01Title => '1. 接受服務條款';

  @override
  String termsOfServiceSection01Body(String appTitle) {
    return '歡迎使用「$appTitle」（以下簡稱「本服務」）。使用前請仔細閱讀本服務條款（以下簡稱「本條款」）。\n您點選同意、註冊、登入或實際使用本服務，即視為已閱讀並同意受本條款約束。若不同意，請停止使用本服務。\n我們可能適時修訂本條款，修訂後經應用程式內公告或更新後繼續使用即視為接受修訂版本。';
  }

  @override
  String get termsOfServiceSection02Title => '2. 服務說明';

  @override
  String get termsOfServiceSection02Body =>
      '本服務為結合本機儲存與區塊鏈能力的筆記類應用：您可在裝置上建立、編輯與管理筆記，並可依自身選擇進行與鏈上相關的操作（例如交易、雜湊或中繼資料等，具體以應用程式內流程與提示為準）。\n目前實作特點包括（可能隨版本更新）：\n• 本機儲存：筆記等資料主要保存在您的裝置（如本機資料庫）；解除安裝應用程式可能導致本機資料遺失，請自行備份。\n• 鏈上相關能力：您可自願發起鏈上操作以實現存證、同步或展示等目的；鏈上紀錄通常公開且難以刪除。\n• 多鏈支援：支援多條 EVM 相容網路，具體以應用程式內清單為準。\n• 筆記帳戶：由您在裝置內產生或匯入金鑰材料；金鑰與恢復短語由您本人保管。\n本服務僅提供技術工具與中立的軟體能力，不對您筆記內容的合法性、準確性、完整性或適用於任何特定目的作擔保。';

  @override
  String get termsOfServiceSection03Title => '3. 使用者帳號與安全';

  @override
  String get termsOfServiceSection03Body =>
      '3.1 筆記帳戶與憑證：建立或恢復筆記帳戶後，系統會在裝置端管理位址與金鑰材料。恢復短語、安全密鑰是恢復筆記的唯一起效憑據之一，請務必離線備份並妥善保密。\n3.2 安全責任：凡使用您裝置上已解鎖的應用程式與筆記帳戶所進行之操作，均視為由您或您授權環境下進行；因洩露恢復短語／安全密鑰、裝置遺失、惡意軟體、釣魚或未依提示操作導致之損失，由您自行承擔。\n3.3 安全建議：\n• 切勿向任何人洩露恢復短語或安全密鑰\n• 為應用程式設定強度高之密碼並啟用系統提供的鎖定畫面／生物辨識（若可用）\n• 在可信網路環境下備份恢復短語，並驗證備份正確性\n• 警惕仿冒應用程式與釣魚連結\n3.4 我們及工作人員不會以任何理由向您索取完整恢復短語或安全密鑰。如遇此類請求，請拒絕並透過官方管道回饋。';

  @override
  String get termsOfServiceSection04Title => '4. 區塊鏈交易與費用';

  @override
  String termsOfServiceSection04Body(String appTitle) {
    return '4.1 Gas 與網路費：在鏈上發起交易須向區塊鏈網路支付手續費（Gas 等）。費用由網路收取，與「$appTitle」作為軟體提供方無商業上之代收關係；費率與額度由網路與當時壅塞狀況決定。\n4.2 確認時間：交易須經網路確認，時間取決於網路狀態與您選擇之費率策略；我們不保證具體確認時長。\n4.3 失敗與扣費：因餘額不足、RPC 異常、使用者撤銷、合約回滾等原因可能導致交易失敗；部分情況下已消耗之網路費仍無法退還，以網路規則為準。\n4.4 不可逆性：鏈上交易一經足夠確認，通常不可撤銷或篡改。請在簽章與廣播前核對網路、金額與合約互動內容。\n4.5 您對您主動發起之全部鏈上操作及相應後果自行負責。因區塊鏈協定、第三方節點、智慧型合約或您自身操作失誤造成之損失，我們於法律法規允許範圍內不承擔責任。';
  }

  @override
  String get termsOfServiceSection05Title => '5. 使用者行為規範';

  @override
  String get termsOfServiceSection05Body =>
      '使用本服務時，您不得：\n• 製作、上傳、傳播違法違規、侵權、誹謗、猥褻、暴力、仇恨或侵害他人合法權益之內容\n• 利用本服務從事詐欺、洗錢、非法募資、侵犯智慧財產權或其他監管機構禁止之行為\n• 對本服務或相關基礎設施進行未經授權之存取、探測、干擾或破壞\n• 大量爬取、濫用介面或影響其他使用者正常使用（除非我們書面允許）\n• 利用本服務大量傳送騷擾或未經授權之商業訊息\n若您違反前款，我們得視情節採取警示、限制功能、中止或終止向您提供服務等措施，並得於依法或依監管部門要求時配合提供必要資訊。';

  @override
  String get termsOfServiceSection06Title => '6. 智慧財產權';

  @override
  String get termsOfServiceSection06Body =>
      '6.1 本服務本身：包括但不限於用戶端軟體、介面設計、標識與文件之著作權、商標權等歸我們或權利人所有。未經許可，您不得複製、反向工程、破解或商業性再發行本服務核心程式碼（法律允許之合理使用除外）。\n6.2 您的內容：您對自行創作之筆記等內容保留權利；本條款不將該等權利移轉予我們。\n6.3 為向您提供同步、展示、備份、鏈上提交等技術實作所必要範圍內，您授予我們非獨占、可撤回（於服務條款允許終止使用範圍內）、免授權金之使用授權，僅限於運行與改善本服務之目的。\n6.4 未經書面許可，您不得以容易引起混淆之方式使用我們的商標、應用程式名稱或圖示。';

  @override
  String get termsOfServiceSection07Title => '7. 免責聲明';

  @override
  String get termsOfServiceSection07Body =>
      '7.1 「現狀」提供：於適用法律允許之最大範圍內，本服務依「現狀」及「可用」基礎提供。我們不對服務持續不中斷、無錯誤、滿足您所有需求或與其他軟硬體完全相容作明示或默示擔保。\n7.2 資料與安全：我們會採取合理技術與管理措施，但無法保證因不可抗力、裝置遺失、病毒、第三方攻擊或區塊鏈／IPFS 等外部系統導致之資料外洩、遺失或服務中斷不會發生。\n7.3 第三方：本服務可能依賴區塊鏈節點、閘道、去中心化儲存、推播等第三方服務；對其可用性、準確性或合規性我們不作擔保，相關風險由您自行評估。\n7.4 鏈上筆記與協定風險：鏈上筆記及相關協定具有網路異常、合約漏洞、治理分叉等固有風險；您應自行了解並承擔。\n7.5 責任限制：除法律強制規定外，我們對任何間接、附帶、懲罰性或後果性損害不承擔責任；我們之總賠償額以您就爭議服務向我們已實際支付金額為上限（若為零則以零為限）。';

  @override
  String get termsOfServiceSection08Title => '8. 服務變更、中止與終止';

  @override
  String get termsOfServiceSection08Body =>
      '8.1 我們得因業務調整、合規要求或技術原因修改、暫停或終止部分或全部功能；將於可行時透過應用程式內提示等方式告知。\n8.2 您可隨時停止使用並解除安裝本服務；重要資料請務必提前自行匯出或備份。\n8.3 若您嚴重違反本條款，我們得中止或終止向您提供服務。\n8.4 服務終止後，除法律另有要求外，我們沒有義務繼續保存或向您返還已儲存在鏈上、第三方網路或您本機已由您處置之資料。';

  @override
  String get termsOfServiceSection09Title => '9. 法律適用與爭議解決';

  @override
  String get termsOfServiceSection09Body =>
      '9.1 本條款之訂立、效力、解釋與履行適用中華人民共和國大陸地區法律（僅為本條款目的，不包括衝突法規則導致適用域外法之情形，法律法規另有規定者除外）。\n9.2 因本條款引起之爭議，雙方應先行友好協商。\n9.3 協商不成者，任何一方得向有管轄權之人民法院提起訴訟（可約定為我們主要辦事機構所在地法院，如與強制性管轄規則衝突，以法律為準）。';

  @override
  String get termsOfServiceSection10Title => '10. 其他';

  @override
  String termsOfServiceSection10Body(String privacyDoc) {
    return '10.1 完整協議：本條款與$privacyDoc（如有）及應用程式內專項規則共同構成您使用本服務之主要規則；衝突時，就專項事項以專項規則為準（不得違反強制性法律）。\n10.2 可分割：若某條款被認定無效或不可執行，其餘條款仍為有效，且應於合法範圍內盡可能接近原意作出解釋。\n10.3 不棄權：我們未及時行使權利不構成對該權利之放棄。\n10.4 聯絡我們：除法律法規另有強制性管道外，您可透過應用程式內「說明中心」或意見回饋就本條款提出詢問。';
  }

  @override
  String termsOfServiceFooterLine1(String appTitle) {
    return '感謝您信任並使用$appTitle。';
  }

  @override
  String get connectEvmAccountFirst => '請先連接 EVM 筆記帳戶';

  @override
  String get createAccountFailedRetry => '建立筆記帳戶失敗，請稍後重試';

  @override
  String createAccountFailedWithError(String error) {
    return '建立筆記帳戶失敗：$error';
  }

  @override
  String get transactionHistoryConnectEvm => '請選擇網路並確保已連接 EVM 筆記帳戶';

  @override
  String get transactionHistoryUnsupportedNetwork =>
      '目前網路暫不支援創建筆記記錄列表（請切換至常見 EVM 網路）';

  @override
  String get securityVerificationFailed => '安全驗證失敗';

  @override
  String get walletImportPrivateKeyHint => '請輸入您的安全密鑰，請勿洩露給他人';

  @override
  String get walletImportPrivateKeySubmit => '匯入安全密鑰';
}
