// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '온체인 노트';

  @override
  String get tabHome => '홈';

  @override
  String get tabNotes => '노트';

  @override
  String get tabProfile => '내 정보';

  @override
  String get myNotes => '내 노트';

  @override
  String notesCount(int count) {
    return '노트 $count개';
  }

  @override
  String get createNote => '노트 만들기';

  @override
  String get selectNetwork => '네트워크 선택';

  @override
  String get selectNetworkSubtitle => '사용할 블록체인 네트워크를 선택하세요';

  @override
  String get chainSelectorMainnetTab => '메인넷';

  @override
  String get chainSelectorTestnetTab => '테스트넷';

  @override
  String get chainSelectorFooterHint => '네트워크를 바꾸면 노트는 해당 블록체인에 저장됩니다.';

  @override
  String get chainSelectorTestnetNoticeTitle => '테스트넷 안내';

  @override
  String get chainSelectorTestnetNoticeBody =>
      '테스트넷은 개발·테스트용이며 토큰에 실제 가치가 없습니다.';

  @override
  String get chainSelectorAllChainsTitle => '모든 체인';

  @override
  String get chainSelectorAllChainsSubtitle => '모든 체인의 노트 표시';

  @override
  String chainSelectorChainIdLabel(int chainId) {
    return '체인 ID: $chainId';
  }

  @override
  String get chainSelectorCurrentBadge => '현재';

  @override
  String chainSelectorGasLabel(String cost) {
    return 'Gas: $cost';
  }

  @override
  String get chainGasCostLevelMedium => '보통';

  @override
  String get chainSelectorTestnetChainWarning => '테스트넷 · 실제 가치 없음';

  @override
  String get viewAll => '전체 보기';

  @override
  String get aboutUs => '소개';

  @override
  String get aboutPageTagline => '영구 보관 · 변조 불가 · 완전한 통제';

  @override
  String splashVersionLabel(String version) {
    return '버전 $version';
  }

  @override
  String get aboutPageVersionSection => '버전 정보';

  @override
  String get aboutPageCurrentVersion => '현재 버전';

  @override
  String get photosPermissionDeniedSnack =>
      '사진 보관함 접근 권한이 필요합니다. 설정에서 허용한 뒤 다시 시도해 주세요.';

  @override
  String get pressBackAgainToExitApp => '한 번 더 누르면 앱이 종료됩니다';

  @override
  String noteEditorOnChainTypeConfirmedSnack(String publishAction) {
    return '온체인 저장을 확인했습니다. 노트를 저장하거나 \"$publishAction\"을(를) 눌러 계속하세요.';
  }

  @override
  String get actionShow => '표시';

  @override
  String get actionHide => '숨기기';

  @override
  String get actionSaveToFile => '파일로 저장';

  @override
  String get mnemonicExportSecurityConfirmTitle => '보안 확인';

  @override
  String get mnemonicExportAckSaved => '복구 문구를 안전한 곳에 백업했습니다';

  @override
  String get mnemonicExportAckUnderstandLoss =>
      '복구 문구를 잃으면 노트 계정을 복구할 수 없음을 이해합니다';

  @override
  String get mnemonicExportAckNoShare => '복구 문구를 누구와도 공유하지 않겠습니다';

  @override
  String get mnemonicExportSafetyTipsTitle => '안전 팁';

  @override
  String get mnemonicExportSafetyTipPaper => '복구 문구를 종이에 적어 안전한 곳에 보관하세요';

  @override
  String get mnemonicExportSafetyTipNoScreenshot =>
      '스크린샷이나 인터넷에 연결된 기기에 저장하지 마세요';

  @override
  String get mnemonicExportSafetyTipCheckBackup => '백업이 온전한지 정기적으로 확인하세요';

  @override
  String get mnemonicExportFinishCta => '안전하게 백업했습니다';

  @override
  String get aboutPageReleaseDate => '출시일';

  @override
  String get aboutPageBuildNumber => '빌드 번호';

  @override
  String get aboutPageCoreFeatures => '핵심 기능';

  @override
  String get aboutFeatureOnChainTitle => '온체인 저장';

  @override
  String get aboutFeatureOnChainDesc => 'SHA-256 해시를 온체인에, 영구적으로 변조 불가.';

  @override
  String get aboutFeatureSecureTitle => '데이터 보안';

  @override
  String get aboutFeatureSecureDesc => '종단간 암호화, 키는 사용자가 보유.';

  @override
  String get aboutFeatureSyncTitle => '즉시 동기화';

  @override
  String get aboutFeatureSyncDesc => '여러 기기 실시간 동기화, 어디서나 접근.';

  @override
  String get aboutFeatureControlTitle => '완전한 통제';

  @override
  String get aboutFeatureControlDesc => '탈중앙 구조, 데이터는 사용자의 것.';

  @override
  String get aboutPageTechStack => '기술 스택';

  @override
  String get aboutPageContactUs => '문의';

  @override
  String get aboutPageOfficialWebsite => '공식 웹사이트';

  @override
  String get aboutPageContactEmail => '문의 이메일';

  @override
  String get aboutPageOpenSource => '오픈 소스';

  @override
  String get aboutPageCreditsMadeWith => 'Made with ';

  @override
  String aboutPageCopyrightNotice(String yearBrand) {
    return '© $yearBrand. 무단 복제·전재를 금합니다.';
  }

  @override
  String get walletManagement => '노트 계정 관리';

  @override
  String get walletCannotDeleteSwitchFirst =>
      '사용 중인 노트 계정은 삭제할 수 없습니다. 다른 노트 계정으로 먼저 전환하세요.';

  @override
  String get walletViewMnemonicCompleteBackupFirst =>
      '복구 구문 또는 개인 키를 보기 전에 복구 구문 백업 절차를 완료하세요.';

  @override
  String get walletDemoPrimaryName => '내 주 노트 계정';

  @override
  String get walletAddressListTitle => '노트 계정 주소 목록';

  @override
  String get copyAddressButton => '주소 복사';

  @override
  String get labelCopied => '복사됨';

  @override
  String get walletManagementDeleteIrreversible =>
      '되돌릴 수 없습니다. 복구 구문 또는 개인 키를 백업했는지 확인하세요.';

  @override
  String get walletManagementDeleteWarningTitle => '경고: 삭제 후 복구할 수 없습니다';

  @override
  String get walletManagementDeleteAssetsLoss =>
      '복구 구문 또는 보안 키를 보관하지 않으면 노트에 영구적으로 접근하지 못할 수 있습니다.';

  @override
  String get walletCreateSystemDescription => '새 노트 계정 주소와 복구 구문이 생성됩니다';

  @override
  String get walletCreateBackupReminderBody =>
      '생성 후 즉시 복구 구문을 백업하세요. 노트 계정을 복구할 수 있는 유일한 수단입니다.';

  @override
  String get walletCreateGenerateSubtitle => '새 노트 계정 생성';

  @override
  String get walletAddressCopied => '주소가 복사되었습니다';

  @override
  String get walletNameRequired => '노트 계정 이름을 입력하세요';

  @override
  String get walletNameUpdated => '노트 계정 이름이 변경되었습니다';

  @override
  String get walletKeepAtLeastOne => '노트 계정은 최소 하나 이상 유지해야 합니다';

  @override
  String get walletCannotDeleteCurrent => '사용 중인 노트 계정은 삭제할 수 없습니다';

  @override
  String get walletDeleted => '노트 계정이 삭제되었습니다';

  @override
  String get walletCreated => '노트 계정이 생성되었습니다';

  @override
  String get walletImportMnemonicOrKeyRequired => '복구 구문 또는 개인 키를 입력하세요';

  @override
  String get walletImportSuccess => '노트 계정을 복원습니다';

  @override
  String get walletImportedCannotViewMnemonic => '복원한 노트 계정의 복구 구문은 볼 수 없습니다';

  @override
  String get walletMarkedBackedUp => '백업됨으로 표시되었습니다';

  @override
  String get walletSwitched => '노트 계정이 전환되었습니다';

  @override
  String get viewMnemonic => '복구 구문 보기';

  @override
  String get viewPrivateKey => '보안 키 보기';

  @override
  String get privateKeyExportSelectNetworkHint => '볼 네트워크를 선택하세요';

  @override
  String get privateKeyExportKeepKeySafeHint => '보안 키를 안전하게 보관하세요';

  @override
  String get privateKeyExportSecurityWarningTitle => '보안 경고';

  @override
  String get privateKeyExportWarnBullet1 => '보안 키는 노트를 관리하는 최고 권한 자격 증명입니다';

  @override
  String get privateKeyExportWarnBullet2 => '보안 키를 얻은 사람은 노트를 완전히 관리할 수 있습니다';

  @override
  String get privateKeyExportWarnBullet3 => '주변 환경이 안전하고 누가 보고 있지 않은지 확인하세요';

  @override
  String get privateKeyExportWarnBullet4 => '스크린샷, 촬영, 네트워크 전송을 절대 하지 마세요';

  @override
  String get privateKeyExportSupportedNetworksTitle => '지원 네트워크';

  @override
  String privateKeyExportNetworkCount(int count) {
    return '네트워크 $count개';
  }

  @override
  String get privateKeyExportViewSafetyTitle => '보안 키 안전 안내';

  @override
  String get privateKeyExportViewBullet1 => '주변이 안전하고 화면을 들여다보는 사람이 없는지 확인하세요';

  @override
  String get privateKeyExportViewBullet2 => '공공장소나 신뢰할 수 없는 네트워크에서는 보지 마세요';

  @override
  String get privateKeyExportViewBullet3 => '확인이 끝나면 가능한 한 빨리 이 페이지를 닫으세요';

  @override
  String get privateKeyExportKeySectionTitle => '보안 키';

  @override
  String get privateKeyExportBip44Hint =>
      'BIP44 이더리움 경로로 파생된 보안 키는 EVM 메인넷에서 동일하며 네트워크 이름만 다릅니다.';

  @override
  String get privateKeyExportMaskedPlaceholder =>
      '0x•••••••••••••••••••••••••••••••••';

  @override
  String get privateKeyExportDoNotShareInline =>
      '보안 키를 누구에게도 알려주거나 네트워크로 전송하지 마세요';

  @override
  String privateKeyExportNetworkAddressLabel(String networkName) {
    return '$networkName 네트워크 주소';
  }

  @override
  String get privateKeyExportImportantReminderTitle => '중요 안내';

  @override
  String get privateKeyExportReminderBullet1 =>
      '보안 키 보유 = 해당 주소의 노트를 완전히 관리할 수 있음';

  @override
  String get privateKeyExportReminderBullet2 =>
      '유출 시 노트는 영구적으로 잃을 수 있으며 복구할 수 없습니다';

  @override
  String get privateKeyExportReminderBullet3 => '공식 팀은 보안 키 제공을 요청하지 않습니다';

  @override
  String get privateKeyExportReminderBullet4 =>
      '보안 키보내기보다 복구 문구로 백업하는 것을 권장합니다';

  @override
  String get privateKeyExportBackToList => '목록으로';

  @override
  String get privateKeyExportCopySecurityKey => '보안 키 복사';

  @override
  String get mnemonicManagePageTitle => '복구 구문';

  @override
  String get mnemonicManagePageSubtitle => '복구 구문은 안전하게 보관하고 유출하지 마세요';

  @override
  String get mnemonicBackupFlowTitle => '복구 구문 백업';

  @override
  String mnemonicBackupFlowStepProgress(int step, int total) {
    return '$step단계 / 총 $total단계';
  }

  @override
  String get mnemonicBackupFlowLoadFailed => '불러오기 실패';

  @override
  String get mnemonicBackupFlowCTAUnderstoodStart => '이해했습니다. 백업 시작';

  @override
  String get mnemonicBackupFlowCTACopiedContinue => '적었습니다. 검증 계속';

  @override
  String get mnemonicBackupFlowCTAVerifiedContinue => '검증 완료, 계속';

  @override
  String get mnemonicBackupFlowCTAPleaseVerify => '검증을 먼저 완료하세요';

  @override
  String get mnemonicBackupFlowCTAFinish => '백업 완료';

  @override
  String get mnemonicBackupFlowCTANext => '다음';

  @override
  String get mnemonicBackupFlowFooterCopyHint => '모든 단어를 올바르게 적었는지 확인한 뒤 계속하세요';

  @override
  String get mnemonicBackupFlowStep1Heading => '시작하기 전에';

  @override
  String get mnemonicBackupFlowStep1Subheading => '아래 보안 안내를 꼼꼼히 읽어 주세요';

  @override
  String get mnemonicBackupFlowSecurityTipsTitle => '중요한 보안 안내';

  @override
  String get mnemonicBackupFlowSecurityTip1 =>
      '복구 구문은 이 노트 계정을 복구할 수 있는 유일한 수단입니다';

  @override
  String get mnemonicBackupFlowSecurityTip2 => '복구 구문을 아는 사람은 노트를 관리할 수 있습니다';

  @override
  String get mnemonicBackupFlowSecurityTip3 =>
      '복구 구문을 잃으면 노트 계정을 영구적으로 복구할 수 없습니다';

  @override
  String get mnemonicBackupFlowBackupAdviceTitle => '안전하게 백업하는 방법';

  @override
  String get mnemonicBackupFlowBackupAdvice1 => '종이에 적어 안전한 곳에 보관하세요';

  @override
  String get mnemonicBackupFlowBackupAdvice2 => '스크린샷이나 인터넷에 연결된 기기에 저장하지 마세요';

  @override
  String get mnemonicBackupFlowBackupAdvice3 => '네트워크로 보내거나 누구와도 공유하지 마세요';

  @override
  String get mnemonicBackupFlowBackupAdvice4 => '여러 곳에 나누어 보관하는 것을 권장합니다';

  @override
  String get mnemonicBackupFlowProcessTitle => '백업 절차';

  @override
  String get mnemonicBackupFlowProcess1 => '복구 구문을 확인하고 적어 두기';

  @override
  String get mnemonicBackupFlowProcess2 => '검증으로 백업이 맞는지 확인';

  @override
  String get mnemonicBackupFlowProcess3 => '백업을 마치고 노트 보호';

  @override
  String get mnemonicBackupFlowYourMnemonicTitle => '내 복구 구문';

  @override
  String get mnemonicBackupFlowYourMnemonicSubtitle => '순서대로 적고 안전하게 보관하세요';

  @override
  String mnemonicBackupFlowWordCount(int count) {
    return '단어 $count개';
  }

  @override
  String get mnemonicBackupFlowPleaseNoteTitle => '참고';

  @override
  String get mnemonicBackupFlowStep2NoteBody =>
      '스크린샷이나 복사보다 종이에 적는 것을 권장합니다. 눈 아이콘으로 표시/숨김을 바꿀 수 있습니다.';

  @override
  String get mnemonicBackupFlowVerifyTitle => '복구 구문 검증';

  @override
  String get mnemonicBackupFlowVerifySubtitle => '올바른 단어를 선택해 백업이 맞는지 확인하세요';

  @override
  String mnemonicBackupFlowVerifyWordQuestion(int position) {
    return '$position번째 단어는 무엇인가요?';
  }

  @override
  String get mnemonicBackupFlowVerifySuccessTitle => '검증 성공';

  @override
  String get mnemonicBackupFlowVerifySuccessBody => '복구 구문을 올바르게 백업했습니다';

  @override
  String get mnemonicBackupFlowDoneTitle => '백업 완료!';

  @override
  String get mnemonicBackupFlowDoneSubtitle => '복구 구문이 안전하게 백업되었습니다';

  @override
  String get mnemonicBackupFlowDoneSectionTitle => '완료됨';

  @override
  String get mnemonicBackupFlowDoneCheck1 => '복구 구문 확인 및 기록';

  @override
  String get mnemonicBackupFlowDoneCheck2 => '검증 테스트 통과';

  @override
  String get mnemonicBackupFlowDoneCheck3 => '복구 구문 안전 보관';

  @override
  String get mnemonicBackupFlowDoneSecurityTitle => '보안 알림';

  @override
  String get mnemonicBackupFlowDoneSecurity1 => '복구 구문을 안전한 물리적 장소에 보관하세요';

  @override
  String get mnemonicBackupFlowDoneSecurity2 => '누구에게도 복구 구문을 알리지 마세요';

  @override
  String get mnemonicBackupFlowDoneSecurity3 => '공식 팀은 절대 복구 구문을 요구하지 않습니다';

  @override
  String get mnemonicBackupFlowDoneSecurity4 => '정기적으로 백업이 온전히 읽히는지 확인하세요';

  @override
  String get mnemonicBackupFlowFinalEncouragementTitle =>
      '이제 노트 계정을 안심하고 사용하세요!';

  @override
  String get mnemonicBackupFlowFinalEncouragementBody => '노트는 복구 구문으로 보호됩니다';

  @override
  String get switchWallet => '전환';

  @override
  String get viewAddresses => '주소 보기';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String get createWallet => '노트 계정 만들기';

  @override
  String get importWallet => '노트 계정 복원';

  @override
  String get mnemonicOrPrivateKey => '복구 구문 또는 개인 키';

  @override
  String get close => '닫기';

  @override
  String get copy => '복사';

  @override
  String get mnemonicCopied => '복구 구문이 복사되었습니다';

  @override
  String get privateKeyCopied => '개인 키가 복사되었습니다';

  @override
  String get backedUp => '백업됨';

  @override
  String get editWalletName => '노트 계정 이름 편집';

  @override
  String get deleteWallet => '노트 계정 삭제';

  @override
  String get confirmDeleteWallet => '노트 계정 삭제 확인';

  @override
  String get newWalletCreated => '새 노트 계정이 생성되었습니다';

  @override
  String get cannotDeleteCurrentWallet => '사용 중인 노트 계정은 삭제할 수 없습니다';

  @override
  String get edit => '편집';

  @override
  String get createNewWallet => '새 노트 계정 만들기';

  @override
  String get editWalletNameTitle => '노트 계정 이름 변경';

  @override
  String get noteNotFoundBack => '노트를 찾을 수 없습니다. 돌아가세요';

  @override
  String get createNoteNotImplemented => '노트 만들기 (미구현)';

  @override
  String get newWalletCreateSuccess => '새 노트 계정이 성공적으로 생성되었습니다!';

  @override
  String restoringFromProvider(String provider) {
    return '$provider에서 노트 계정 복원 중...';
  }

  @override
  String restoredFromProvider(String provider) {
    return '$provider에서 노트 계정을 복원했습니다!';
  }

  @override
  String noBackupFoundProvider(String provider) {
    return '$provider 백업을 찾을 수 없습니다. 다른 방법을 시도하세요';
  }

  @override
  String get walletAddressCopiedShort => '노트 계정 주소가 복사되었습니다';

  @override
  String switchedToChain(String chain) {
    return '$chain(으)로 전환되었습니다';
  }

  @override
  String get fillAllFields => '모든 항목을 입력하세요';

  @override
  String get passwordMismatch => '새 비밀번호가 일치하지 않습니다';

  @override
  String get passwordMinLength => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get passwordChangeSuccess => '비밀번호가 변경되었습니다';

  @override
  String get enterValidEmail => '유효한 이메일을 입력하세요';

  @override
  String get verificationCodeSent => '인증 코드가 전송되었습니다';

  @override
  String get enterSixDigitCode => '6자리 인증 코드를 입력하세요';

  @override
  String get emailBindSuccess => '이메일이 연결되었습니다';

  @override
  String get emailUnbound => '이메일 연결이 해제되었습니다';

  @override
  String get logoutNotConnected => '로그아웃 (미연결)';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get confirm => '확인';

  @override
  String get bindEmail => '이메일 연결';

  @override
  String get editNoteOpenByRoute => '경로를 통해 편집 페이지를 여세요';

  @override
  String get imageUploadNotConnected => '이미지 업로드가 스토리지에 연결되지 않음';

  @override
  String get imageRemoved => '이미지가 제거되었습니다';

  @override
  String get titleContentRequired => '제목과 내용을 입력하세요';

  @override
  String get submittedToChain => '체인에 제출되었습니다';

  @override
  String get onChainNoteCannotChangeType => '온체인 노트는 유형을 변경할 수 없습니다';

  @override
  String get setToLocalNote => '로컬 노트로 설정됨 (체인에 올라가지 않음)';

  @override
  String get setToDraft => '초안으로 설정됨';

  @override
  String get editNote => '노트 편집';

  @override
  String get noteDetailEditDisabledOnChain => '온체인 노트는 편집할 수 없습니다';

  @override
  String get noteTypeDraft => '초안';

  @override
  String get noteTypeLocal => '로컬';

  @override
  String get noteTypeOnChain => '온체인';

  @override
  String get blockchainVerify => '블록체인에서 확인';

  @override
  String get blockchainVerifyTitle => '블록체인 확인';

  @override
  String getGas(String symbol) {
    return '$symbol 가스 받기';
  }

  @override
  String get addressCopied => '주소가 복사되었습니다';

  @override
  String get redirectingToFaucet => '파우셋 사이트로 이동 중...';

  @override
  String get noFaucetForNetwork => '이 네트워크에는 파우셋이 없습니다';

  @override
  String get loginNotImplemented => '로그인 기능 미구현';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get forgotPasswordNotImplemented => '비밀번호 찾기 미구현';

  @override
  String get noAccountYet => '아직 노트 계정이 없나요?';

  @override
  String get registerNotImplemented => '회원가입 미구현';

  @override
  String get registerNow => '지금 회원가입';

  @override
  String get mnemonicVerifySuccess => '복구 구문 검증 성공, 복원는 외부에서 처리됩니다';

  @override
  String get privateKeyVerifySuccess => '개인 키 검증 성공, 복원는 외부에서 처리됩니다';

  @override
  String get importSuccess => '복원 성공!';

  @override
  String get cleared => '비움';

  @override
  String get back => '뒤로';

  @override
  String get current => '현재';

  @override
  String get imported => '가져옴';

  @override
  String get defaultBadge => '기본';

  @override
  String get clearSearch => '검색 지우기';

  @override
  String get searchNotesHint => '노트 검색...';

  @override
  String get noMatchNotes => '일치하는 노트가 없습니다';

  @override
  String get noOnChainNotes => '온체인 노트가 아직 없습니다';

  @override
  String get noOffChainNotes => '오프체인 노트가 아직 없습니다';

  @override
  String get noNotes => '노트가 아직 없습니다';

  @override
  String get tryOtherSearch => '다른 검색어를 시도하세요';

  @override
  String get startCreateFirstNote => '첫 노트를 만들어 보세요';

  @override
  String get profileNotConnected => '연결 안 됨';

  @override
  String get profileSectionAccount => '노트 계정';

  @override
  String get profileNetworkSettingsSubtitle => 'RPC 및 노드 구성';

  @override
  String get profileSectionSecurity => '보안';

  @override
  String get profileChangePasswordSubtitle => '노트 계정 보호';

  @override
  String get profileBindEmailNotBound => '미연결';

  @override
  String get profileBindEmailBadgeBound => '연결됨';

  @override
  String get profileSectionPreferences => '환경설정';

  @override
  String get profileNotifications => '알림';

  @override
  String get profileDarkMode => '다크 모드';

  @override
  String get profileLanguage => '언어';

  @override
  String get profileSectionMore => '더보기';

  @override
  String get profileTestPage => '테스트 페이지';

  @override
  String get profileTestPageSubtitle => '기능 테스트';

  @override
  String get profileTerms => '서비스 약관';

  @override
  String get profilePrivacy => '개인정보 처리방침';

  @override
  String get profileRateUs => '평가하기';

  @override
  String get profileShare => '친구에게 공유';

  @override
  String profileShareMessage(String url) {
    return '온체인 노트 앱을 쓰고 있어요. 한번 써 보세요:\n$url';
  }

  @override
  String get profileLogoutLabel => '로그아웃';

  @override
  String get profileLogoutPending => '로그아웃 (준비 중)';

  @override
  String profilePageFooter(String appTitle, String version, String year) {
    return '$appTitle v$version\n© $year 무단 전재를 금합니다.';
  }

  @override
  String get profileAvatarFallback => 'ME';

  @override
  String get profileDefaultWalletName => '내 노트 계정';

  @override
  String get profileUserActive => '활성 사용자';

  @override
  String get profileUserNormal => '일반 사용자';

  @override
  String get profileStatNotes => '노트 수';

  @override
  String get profileStatOnChain => '온체인';

  @override
  String get profileStatDays => '일수';

  @override
  String get profileBindEmailDialogSubtitle => '이메일과 인증 코드를 입력하세요.';

  @override
  String get profileBindEmailFieldEmail => '이메일 주소';

  @override
  String get profileBindEmailFieldCode => '인증 코드';

  @override
  String get profileSendVerificationCode => '코드 보내기';

  @override
  String profileResendCodeInSeconds(int seconds) {
    return '$seconds초 후 재전송';
  }

  @override
  String get profileUnbindEmail => '이메일 연결 해제';

  @override
  String get languageSelectTitle => '언어';

  @override
  String get languageSelectSubtitle => '원하는 표시 언어를 선택하세요';

  @override
  String get languageNoticeHint => '알림:';

  @override
  String get languageNoticeBody =>
      '간체·번체 중국어, 영어, 일본어, 한국어를 지원합니다. 다른 언어는 순차 지원 예정입니다.';

  @override
  String get languageCurrentBadge => '현재';

  @override
  String get languageSnackbarComingSoon => '곧 지원 예정';

  @override
  String languageSwitchedTo(String name) {
    return '$name(으)로 변경되었습니다';
  }

  @override
  String get languageFooterMore => '더 많은 언어 지원 예정';

  @override
  String get changePasswordSameAsOld => '새 비밀번호는 이전 비밀번호와 같을 수 없습니다';

  @override
  String get changePasswordLength632 => '새 비밀번호는 6~32자여야 합니다';

  @override
  String get walletNoSavedKey => '저장된 키가 없습니다. 먼저 노트 계정을 만드세요';

  @override
  String get changePasswordWrongOrFailed => '이전 비밀번호가 올바르지 않거나 작업에 실패했습니다';

  @override
  String get passwordMaxLength32 => '비밀번호는 최대 32자입니다';

  @override
  String get passwordMeetAllRequirements => '모든 비밀번호 조건을 만족하세요';

  @override
  String encryptionInitFailed(String error) {
    return '암호화 초기화 실패: $error';
  }

  @override
  String get passwordVerifyForgotGoReset => '비밀번호를 잊으셨나요? 재설정';

  @override
  String get passwordStrengthWeak => '약함';

  @override
  String get passwordStrengthMedium => '보통';

  @override
  String get passwordStrengthStrong => '강함';

  @override
  String get changePasswordPageTitle => '비밀번호 변경';

  @override
  String get changePasswordPageSubtitle => '노트 계정 보호';

  @override
  String get changePasswordSecurityHintTitle => '보안 안내';

  @override
  String get changePasswordSecurityHintBody =>
      '• 정기적으로 비밀번호를 변경하세요\n• 문자와 숫자를 포함한 강한 비밀번호를 사용하세요\n• 생일이나 전화번호는 피하세요';

  @override
  String get changePasswordOldLabel => '현재 비밀번호';

  @override
  String get changePasswordOldHint => '현재 비밀번호 입력';

  @override
  String get changePasswordNewLabel => '새 비밀번호';

  @override
  String get changePasswordNewHint => '새 비밀번호 입력';

  @override
  String get changePasswordStrengthLabel => '비밀번호 강도:';

  @override
  String get changePasswordMatchOk => '일치합니다';

  @override
  String get changePasswordMatchBad => '일치하지 않습니다';

  @override
  String get changePasswordConfirmLabel => '새 비밀번호 확인';

  @override
  String get changePasswordConfirmHint => '다시 입력';

  @override
  String get changePasswordRuleLength => '6~32자';

  @override
  String get changePasswordRuleCase => '대·소문자 포함';

  @override
  String get changePasswordRuleDigit => '숫자 포함';

  @override
  String get changePasswordClear => '지우기';

  @override
  String get changePasswordSubmit => '변경 확인';

  @override
  String get validatorOldPasswordRequired => '현재 비밀번호를 입력하세요';

  @override
  String get validatorNewPasswordRequired => '새 비밀번호를 입력하세요';

  @override
  String get validatorNewPasswordMin6 => '최소 6자';

  @override
  String get validatorNewPasswordMax32 => '최대 32자';

  @override
  String get validatorConfirmRequired => '새 비밀번호를 확인하세요';

  @override
  String get validatorConfirmMismatch => '입력이 일치하지 않습니다';

  @override
  String get changePasswordRulesTitle => '비밀번호 요구사항';

  @override
  String get loginWelcomeTitle => '다시 오신 것을 환영합니다';

  @override
  String get loginSubtitle => '노트 계정에 로그인하세요';

  @override
  String get loginEmailOrUsernameLabel => '이메일 또는 사용자 이름';

  @override
  String get loginEmailOrUsernameHint => '이메일 또는 사용자 이름을 입력하세요';

  @override
  String get validatorLoginIdRequired => '이메일 또는 사용자 이름을 입력하세요';

  @override
  String get loginPasswordFieldLabel => '비밀번호';

  @override
  String get loginPasswordFieldHint => '비밀번호를 입력하세요';

  @override
  String get validatorLoginPasswordRequired => '비밀번호를 입력하세요';

  @override
  String get validatorLoginPasswordMin6 => '비밀번호는 최소 6자';

  @override
  String get loginButton => '로그인';

  @override
  String get createWalletPasswordPageTitle => '노트 노트 계정 비밀번호 설정';

  @override
  String get createWalletPasswordSubtitle => '노트를 안전하게 보호';

  @override
  String get createWalletPasswordWhyTitle => '왜 비밀번호가 필요한가요?';

  @override
  String get createWalletPasswordWhyBody =>
      '노트 계정 비밀번호는 보안 키와 복구 구문을 암호화하여 본인만 노트에 접근할 수 있게 합니다. 분실 시 복구할 수 없으니 반드시 기억하세요.';

  @override
  String get walletPasswordFieldLabel => '노트 노트 계정 비밀번호';

  @override
  String get walletPasswordFieldHint => '6~32자 입력';

  @override
  String get walletConfirmPasswordFieldLabel => '비밀번호 확인';

  @override
  String get walletConfirmPasswordFieldHint => '다시 입력';

  @override
  String get walletPasswordImportantNotice => '중요 안내';

  @override
  String get walletPasswordWarnBullets =>
      '• 비밀번호는 노트 계정을 보호합니다\n• 기억하기 쉽고 추측하기 어렵게\n• 문자·숫자·기호 혼합 권장\n• 분실 시 복구 불가';

  @override
  String get createWalletPasswordSubmitCreate => '확인 후 노트 계정 만들기';

  @override
  String get createWalletPasswordSubmitReset => '확인 후 비밀번호 재설정';

  @override
  String get createWalletPasswordFooterAck => '확인 시 비밀번호의 중요성을 이해한 것으로 간주됩니다';

  @override
  String get walletPasswordRulesHeader => '요구사항:';

  @override
  String get walletPasswordRuleLength632 => '6~32자';

  @override
  String get walletPasswordRuleLetter => '문자 포함';

  @override
  String get walletPasswordRuleNumberRecommended => '숫자 포함(권장)';

  @override
  String get walletPasswordRuleMatch => '두 번 입력 일치';

  @override
  String get walletBootstrapImporting => '노트 계정 가져오는 중...';

  @override
  String get walletBootstrapInitializing => '노트 계정 초기화 중...';

  @override
  String get passwordVerifyTitle => '비밀번호 확인';

  @override
  String get passwordVerifyDescription => '보안을 위해 노트 노트 계정 비밀번호를 입력하세요';

  @override
  String get passwordVerifyDescExportMnemonic =>
      '복구 구문을 보거나 내보내기 전에 노트 노트 계정 비밀번호를 입력하세요';

  @override
  String get passwordVerifyDescExportPrivateKey =>
      '보안 키를 보기 전에 노트 노트 계정 비밀번호를 입력하세요';

  @override
  String get passwordVerifyDescImportWallet => '노트 계정 복원 전에 비밀번호를 확인하세요';

  @override
  String get passwordVerifyDescBackupMnemonic =>
      '복구 구문 백업 전에 노트 노트 계정 비밀번호를 입력하세요';

  @override
  String get passwordVerifyDescCreateWallet => '노트 계정 생성 전에 비밀번호를 확인하세요';

  @override
  String get passwordVerifyDescDeleteWallet => '노트 계정 삭제 전에 비밀번호를 확인하세요';

  @override
  String get passwordVerifyDescMintNft => 'NFT 민팅을 위해 노트 노트 계정 비밀번호가 필요합니다';

  @override
  String get passwordVerifyWalletPasswordLabel => '노트 노트 계정 비밀번호';

  @override
  String get passwordVerifyWalletPasswordHint => '노트 노트 계정 비밀번호 입력';

  @override
  String get validatorWalletPasswordRequired => '비밀번호를 입력하세요';

  @override
  String get passwordVerifyNoEncryptedData =>
      '암호화 데이터를 찾을 수 없습니다. 비밀번호를 다시 설정하세요';

  @override
  String passwordVerifyFailedWithError(String error) {
    return '확인 실패: $error';
  }

  @override
  String passwordVerifyLockoutMinutes(int minutes) {
    return '시도 횟수가 너무 많습니다. $minutes분 후 다시 시도하세요';
  }

  @override
  String passwordVerifyLockoutHours(int hours) {
    return '시도 횟수가 너무 많습니다. $hours시간 후 다시 시도하세요';
  }

  @override
  String passwordVerifyWrongWithCount(int current, int max) {
    return '비밀번호 오류 ($current/$max)';
  }

  @override
  String passwordVerifyAttemptsBanner(int count, int remaining) {
    return '오류 $count회, 남은 기회 $remaining회';
  }

  @override
  String passwordVerifyLockBanner(String time) {
    return '시도 횟수가 너무 많습니다. $time 후 다시 시도하세요';
  }

  @override
  String passwordVerifyDurationHoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String passwordVerifyDurationMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get passwordVerifySecurityTipsTitle => '보안 안내';

  @override
  String passwordVerifySecurityTipsBody(int maxAttempts) {
    return '• 비밀번호 6~32자\n• 주변 환경을 확인하세요\n• $maxAttempts회 오류 시 일시 잠금';
  }

  @override
  String get paste => '붙여넣기';

  @override
  String get loadingDefault => '로딩 중…';

  @override
  String get walletLoadingTagline => 'BlockNote · 보안 · 신뢰 · 영구 보존';

  @override
  String get walletLoadingStepConnecting => '네트워크에 연결하는 중…';

  @override
  String get walletLoadingStepVerifying => '노트 계정 정보 확인 중…';

  @override
  String get walletLoadingStepSyncing => '노트 데이터 동기화 중…';

  @override
  String get walletLoadingStepComplete => '거의 완료되었습니다';

  @override
  String get retry => '다시 시도';

  @override
  String loadFailedWithError(String error) {
    return '불러오기 실패: $error';
  }

  @override
  String get selectEvmChainFirst => '먼저 EVM을 지원하는 네트워크를 선택하세요';

  @override
  String get noteNotFoundShort => '노트를 찾을 수 없습니다';

  @override
  String get createOrSelectWalletFirst => '노트 계정을 만들거나 선택하세요';

  @override
  String get privateKeyDecryptFailedHint =>
      '보안 키를 가져올 수 없습니다. 비밀번호를 확인하세요. 변경했다면 복구 구문을 다시 가져오세요';

  @override
  String get uploadingIpfsAndMinting => 'IPFS 업로드 및 민팅 중…';

  @override
  String ipfsFileUploadFailed(String details) {
    return 'IPFS 파일 업로드 실패: $details';
  }

  @override
  String onChainSuccessTx(String txHash) {
    return '온체인 성공: $txHash';
  }

  @override
  String get draftSavedIpfsRetry =>
      '초안으로 저장하고 IPFS 이미지로 바꿨습니다. 나중에 다시 시도할 수 있습니다';

  @override
  String mintFailedGasDebug(String detail) {
    return '잔액 부족(Gas)\n$detail';
  }

  @override
  String get mintFailedGasUser => 'Gas를 지불할 잔액이 부족합니다. 충전 후 다시 시도하세요';

  @override
  String mintFailedGeneric(String error) {
    return '게시 실패: $error';
  }

  @override
  String get walletErrNoWalletYet => '먼저 노트 계정을 만들거나 가져오세요';

  @override
  String get walletErrUnrecognizedAccount => '현재 노트 계정을 인식할 수 없습니다';

  @override
  String get walletErrWalletDataNotFound => '노트 계정 데이터를 찾을 수 없습니다';

  @override
  String get walletErrImportedMnemonicNoExport =>
      '복구 구문으로 복원한 노트 계정은 여기서 다시 내보낼 수 없습니다';

  @override
  String get walletErrImportedMnemonicNoBackup =>
      '복구 구문으로 복원한 노트 계정은 여기서 백업할 필요가 없습니다';

  @override
  String get walletErrPrivateKeyWalletNoMnemonic =>
      '보안 키로 복원한 노트 계정에는 복구 구문이 없습니다';

  @override
  String get walletErrNoEncryptedMnemonic => '이 노트 계정에 로컬 암호화 복구 구문이 없습니다';

  @override
  String get walletErrDecryptFailed => '복호화에 실패했습니다. 비밀번호를 확인하세요';

  @override
  String get walletErrMissingAddress => '노트 계정 주소가 없습니다';

  @override
  String get walletErrGetPrivateKeyFailed => '보안 키를 가져오지 못했습니다. 비밀번호를 확인하세요';

  @override
  String get exportMnemonicDocTitle => '온체인 노트 — 복구 구문 백업';

  @override
  String exportMnemonicDocTime(String time) {
    return '생성 시각: $time';
  }

  @override
  String get exportMnemonicDocLabel => '복구 구문 (안전하게 보관):';

  @override
  String get exportMnemonicDocSecurity =>
      '⚠️ 보안 안내:\n1. 안전한 장소에 보관하세요\n2. 누구와도 공유하지 마세요\n3. 분실 시 복구할 수 없습니다';

  @override
  String get exportMnemonicUseCopyOnPlatform => '이 플랫폼에서는 복사를 사용하세요';

  @override
  String exportMnemonicSavedTo(String path) {
    return '저장됨: $path';
  }

  @override
  String get walletBootstrapCreating => '노트 계정 생성 중…';

  @override
  String get chainNameEvm => 'EVM (Ethereum / BSC / Polygon 등)';

  @override
  String get chainPkDescEvm => '0x로 시작하는 64자리 16진수, 총 66자';

  @override
  String get chainNameBitcoin => 'Bitcoin';

  @override
  String get chainPkDescBitcoin => 'WIF 형식, 5·K·L로 시작, 51–52자';

  @override
  String get chainNameSolana => 'Solana';

  @override
  String get chainPkDescSolana => 'Base58, 약 87–88자, 0·O·I·l 없음';

  @override
  String get chainNameTron => 'Tron';

  @override
  String get chainPkDescTronHex => '64자리 16진수(0x 없음)';

  @override
  String get chainNameCosmos => 'Cosmos';

  @override
  String get chainPkDescCosmosHex => '64자리 16진수(0x 없음)';

  @override
  String walletPkSubtitleLength(int count) {
    return '$count자';
  }

  @override
  String walletPkSubtitleStartsWith(String prefix) {
    return '$prefix(으)로 시작';
  }

  @override
  String get walletImportSelectChainTitle => '블록체인 유형 선택';

  @override
  String get walletImportEvmOnlyNotice => '아직 미지원입니다. EVM 보안 키 복원를 사용하세요';

  @override
  String get walletImportPageSubtitle => '복구 구문 또는 보안 키로 노트 계정 복구';

  @override
  String get walletImportTabMnemonic => '복구 구문';

  @override
  String get walletImportTabPrivateKey => '보안 키';

  @override
  String get walletImportInputMethod => '입력 방식';

  @override
  String get walletImportInputSingle => '단어 하나씩';

  @override
  String get walletImportInputPasteFull => '전체 붙여넣기';

  @override
  String get walletImportWordCountLabel => '복구 구문 단어 수';

  @override
  String walletImportWordCountN(int n) {
    return '$n개 단어';
  }

  @override
  String get walletImportWordCountDialogTitle => '니모닉 단어 수 선택';

  @override
  String get walletImportWordCountDialogDesc =>
      'BIP39는 여러 길이를 지원하며, 단어 수가 많을수록 보안이 강화됩니다.';

  @override
  String walletImportWordCountOptionLabel(int count) {
    return '$count개 니모닉';
  }

  @override
  String get walletImportWordCountSecurityLabel => '보안 수준: ';

  @override
  String get walletImportWordCountSecurityStandard => '표준';

  @override
  String get walletImportWordCountSecurityEnhanced => '강화';

  @override
  String get walletImportWordCountSecurityAdvanced => '고급';

  @override
  String get walletImportWordCountSecurityProfessional => '전문';

  @override
  String get walletImportWordCountSecurityMaximum => '최고';

  @override
  String walletImportWordCountSwitched(int n) {
    return '$n개 단어로 전환했습니다';
  }

  @override
  String get walletImportWordCountDialogTip =>
      '대부분의 지갑은 12개 단어를 사용합니다. 확실하지 않으면 12개를 선택하세요.';

  @override
  String get walletImportEnterMnemonic => '복구 구문 입력';

  @override
  String get walletImportMnemonicPasteTip =>
      '팁: 전체 문장을 붙여넣을 수 있습니다. 위에서 «전체 붙여넣기»를 선택하세요';

  @override
  String get walletImportPasteMnemonicPrompt => '복구 구문 붙여넣기';

  @override
  String walletImportMnemonicHintWords(int count) {
    return '공백으로 구분해 $count개 단어 붙여넣기';
  }

  @override
  String get walletImportMnemonicWordFieldHint => '단어';

  @override
  String get walletImportMnemonicParagraphExampleHint =>
      'word1 word2 word3 ...';

  @override
  String get walletImportPrivateKeyFieldHint => '0x... 또는 64자리 16진수';

  @override
  String get walletImportPrivateKeyFieldHintShort => '0x...';

  @override
  String walletImportWordProgress(int current, int total) {
    return '현재 단어 수: $current / $total';
  }

  @override
  String get walletImportMnemonicSecurityTitle => '보안 안내';

  @override
  String get walletImportMnemonicSecurityBody =>
      '• 안전한 네트워크에서 조작하세요\n• 복구 구문 분실 시 복구 불가\n• 타인에게 절대 공개하지 마세요\n• 서버에 복구 구문을 저장하지 않습니다';

  @override
  String get walletImportSelectChainSection => '블록체인 유형 선택';

  @override
  String get walletImportTapSwitchChain => '탭하여 체인 유형 전환';

  @override
  String get walletImportEnterPrivateKey => '보안 키 입력';

  @override
  String get walletImportPkFormatExample => '보안 키 형식 예';

  @override
  String get walletImportPkSevereTitle => '중대 경고';

  @override
  String get walletImportPkSevereBody =>
      '• 보안 키는 노트 계정의 최고 권한입니다\n• 탈취 시 노트를 완전히 관리당할 수 있습니다\n• 안전하지 않은 기기에서 입력하지 마세요\n• 캡처나 메신저 전송을 하지 마세요';

  @override
  String get walletImportConfirm => '복원 확인';

  @override
  String walletImportMnemonicNeedCount(int count) {
    return '$count개 단어를 모두 입력하세요';
  }

  @override
  String walletImportMnemonicWrongCount(int count, int current) {
    return '$count개 필요합니다(현재 $current개)';
  }

  @override
  String get walletImportMnemonicInvalidWords =>
      '복구 구문이 잘못되었습니다. 소문자 영어 단어를 사용하세요';

  @override
  String get walletImportPkEmpty => '보안 키를 입력하세요';

  @override
  String get walletImportPkNeed0x => '보안 키는 0x로 시작해야 합니다';

  @override
  String get walletImportPkNeedWif => '보안 키는 5·K·L로 시작해야 합니다';

  @override
  String get walletImportPkWifLength => '보안 키 길이는 51–52자여야 합니다';

  @override
  String walletImportPkLengthExpected(int length) {
    return '보안 키 길이는 $length자여야 합니다';
  }

  @override
  String get walletImportPkInvalidFormat => '보안 키 형식이 올바르지 않습니다';

  @override
  String get walletImportEvmOnly => 'EVM 보안 키 복원만 지원합니다';

  @override
  String get walletImportDeriveAddressFailed =>
      '보안 키에서 주소를 계산할 수 없습니다. 형식을 확인하세요';

  @override
  String get walletImportDuplicatePk => '이 주소는 이미 있습니다. 중복 복원는 할 수 없습니다';

  @override
  String get walletImportDuplicateMnemonic =>
      '이 복구 구문 노트 계정은 이미 복원했습니다. 중복 복원는 할 수 없습니다';

  @override
  String get walletImportInvalidPrivateKeyRetry =>
      '개인 키가 유효하지 않습니다. 확인 후 다시 시도하세요';

  @override
  String get walletImportInvalidMnemonicRetry =>
      '복구 구문이 유효하지 않습니다. 확인 후 다시 시도하세요';

  @override
  String get clipboardEmpty => '클립보드가 비어 있습니다';

  @override
  String get mnemonicViewLengthTitle => '복구 구문 길이';

  @override
  String get mnemonicViewInputMode => '입력 방식';

  @override
  String get mnemonicViewSingleWord => '단어 하나씩';

  @override
  String get mnemonicViewFullPaste => '문단 붙여넣기';

  @override
  String get mnemonicViewImportCta => '복구 구문 복원';

  @override
  String mnemonicViewEnterOrdered(int count) {
    return '순서대로 $count개 단어 입력';
  }

  @override
  String get mnemonicViewPasteHint => '전체 복구 구문을 붙여넣고 단어는 공백으로 구분하세요';

  @override
  String mnemonicCountMismatch(int expected, int current) {
    return '$expected개 필요합니다(현재 $current개)';
  }

  @override
  String get mnemonicInvalidBip39 => '유효하지 않은 복구 구문입니다. 철자를 확인하세요';

  @override
  String get walletSelectorTitle => '내 노트 계정';

  @override
  String get walletSelectorSubtitle => '모든 노트 계정 노트 계정 관리';

  @override
  String walletNumberedName(int n) {
    return '노트 계정 $n';
  }

  @override
  String get walletDefaultCreatedNameFirst => '내 노트 계정';

  @override
  String walletDefaultCreatedNameNumbered(int n) {
    return '내 노트 계정 $n';
  }

  @override
  String get walletDefaultPrivateKeyNameFirst => '내 보안 키 노트 계정';

  @override
  String walletDefaultPrivateKeyNameNumbered(int n) {
    return '내 보안 키 노트 계정 $n';
  }

  @override
  String get walletBackupNotYet => '백업 안 됨';

  @override
  String get walletBackupPromptLine1 => '노트 계정 백업';

  @override
  String get walletBackupPromptLine2 => '탭하여 지금 복구 구문 백업';

  @override
  String get walletDeleteConfirmTitle => '노트 계정을 삭제할까요?';

  @override
  String get walletDeleteConfirmLine1 => '되돌릴 수 없습니다. 복구 구문을 백업했는지 확인하세요.';

  @override
  String get walletDeleteConfirmLine2Notes => '이 노트 계정과 연결된 로컬 노트 데이터도 삭제됩니다.';

  @override
  String get walletDeleteCannotCurrent => '⚠️ 사용 중인 노트 계정은 삭제할 수 없습니다';

  @override
  String get walletDeleteLastHint => '삭제 후 노트 계정이 없어지면 온보딩으로 돌아갑니다.';

  @override
  String get walletEditNameSubtitle => '알아보기 쉬운 이름을 설정하세요';

  @override
  String get walletNameFieldLabel => '노트 계정 이름';

  @override
  String get walletNameFieldHint => '노트 계정 이름 입력';

  @override
  String get networkNodeAdd => '노드 추가';

  @override
  String get networkNodeTest => '테스트';

  @override
  String get networkNodeSetDefault => '기본값으로 설정';

  @override
  String get networkNodeOnline => '온라인';

  @override
  String get networkNodeOffline => '오프라인';

  @override
  String get networkNodeConnectionFailed => '노드 연결 실패';

  @override
  String get networkRpcUrlInvalid => '유효한 HTTP 또는 HTTPS RPC URL을 입력하세요.';

  @override
  String get networkNodeDuplicate => '이 RPC URL이 이미 목록에 있습니다.';

  @override
  String get networkNodeNameRpcRequired => '노드 이름과 RPC URL을 입력하세요';

  @override
  String get networkNodeAdded => '노드가 추가되었습니다';

  @override
  String get networkRpcCopied => 'RPC URL이 복사되었습니다';

  @override
  String get networkNodeSwitched => '이 노드로 전환했습니다';

  @override
  String get networkNodeDeleted => '노드가 삭제되었습니다';

  @override
  String get networkSettingsTitle => '네트워크 설정';

  @override
  String get networkSettingsSubtitle => '블록체인 RPC 노드 구성';

  @override
  String networkLoadFailed(String message) {
    return '불러오기 실패: $message';
  }

  @override
  String get networkSectionMainnet => '메인넷';

  @override
  String get networkSectionTestnet => '테스트넷';

  @override
  String get networkTestnetListHint =>
      '앱 데이터 소스(ChainDatas)에서 testnet으로 표시된 네트워크가 여기에 나열됩니다.';

  @override
  String networkCountNetworks(int count) {
    return '네트워크 $count개';
  }

  @override
  String get networkAboutNodesTitle => 'RPC 노드 안내';

  @override
  String get networkAboutNodesBullet1 => 'RPC 노드는 블록체인 네트워크로 연결하는 관문입니다.';

  @override
  String get networkAboutNodesBullet2 => '속도나 안정성을 위해 사용자 지정 노드를 추가할 수 있습니다.';

  @override
  String get networkAboutNodesBullet3 => '신뢰할 수 있는 공개 노드나 직접 운영하는 노드를 권장합니다.';

  @override
  String get networkStatusConnectionOk => '연결 정상';

  @override
  String get networkStatusConnectionError => '연결 문제';

  @override
  String get networkStatusCustomized => '사용자 지정';

  @override
  String networkNodeCountLabel(int count) {
    return '노드 $count개';
  }

  @override
  String networkAllNodesTitle(int count) {
    return '전체 노드($count)';
  }

  @override
  String networkDetailHeaderNodeCount(int count) {
    return '총 $count개 노드';
  }

  @override
  String get networkQuickAddTitle => '빠른 노드 추가';

  @override
  String get networkQuickAddLine1 =>
      '네트워크를 눌러 상세로 들어가면 사용자 지정 RPC 노드를 추가할 수 있습니다.';

  @override
  String get networkQuickAddLine2 =>
      '여러 노드를 추가할 수 있으며, 목록은 이후 기능(가장 빠른 노드 선택 등)을 위해 보관됩니다.';

  @override
  String get networkNodeProbeOk => '노드 연결 정상';

  @override
  String networkNodeProbeOkLatency(int ms) {
    return '노드 연결 정상, 지연 $ms ms';
  }

  @override
  String get networkCurrentNodeTitle => '현재 사용 중인 노드';

  @override
  String get networkNodeActiveBadge => '활성';

  @override
  String get networkNoNodeSelected => '선택된 노드 없음';

  @override
  String networkNodeLatencyMs(int ms) {
    return '지연 $ms ms';
  }

  @override
  String get networkAddRpcDialogTitle => 'RPC 노드 추가';

  @override
  String networkAddRpcDialogSubtitle(String networkName) {
    return '$networkName 네트워크용 사용자 지정 RPC 노드 추가';
  }

  @override
  String get networkNodeNameLabel => '노드 이름';

  @override
  String get networkNodeNameHint => '예: 내 노드 1';

  @override
  String get networkRpcUrlLabel => 'RPC URL';

  @override
  String get networkRpcUrlHint => 'https://…';

  @override
  String get networkExampleRpcLabel => 'RPC URL 예시';

  @override
  String get networkConfirmAddNode => '추가 확인';

  @override
  String get networkTipsTitle => '사용 팁';

  @override
  String get networkTipsLine1 => '백업을 위해 노드를 여러 개 추가해 보세요.';

  @override
  String get networkTipsLine2 => '테스트로 연결 상태와 지연을 확인하세요.';

  @override
  String get networkTipsLine3 => '지연이 낮을수록 거래가 더 빨라지는 경우가 많습니다.';

  @override
  String get networkTipsLine4 => '기본 제공 노드는 삭제할 수 없습니다.';

  @override
  String get networkNodeInUseBadge => '사용 중';

  @override
  String get networkCannotDeleteDefaultNode => '기본 노드는 삭제할 수 없습니다.';

  @override
  String get networkDeleteSwitchNodeFirst => '삭제하기 전에 다른 노드로 먼저 전환하세요.';

  @override
  String homeFiatApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String homeUnitPrice(String price) {
    return '단가: $price';
  }

  @override
  String get homeUnitPriceUnavailable => '단가: --';

  @override
  String get homeTransactionHistory => '노트 생성 기록';

  @override
  String get homeTransactionHistoryNotConfigured => '노트 생성 기록 기능이 설정되지 않았습니다';

  @override
  String get transactionHistorySubtitle => '모든 노트 생성 기록을 확인하세요';

  @override
  String get transactionHistoryStatTotal => '합계';

  @override
  String get transactionHistoryStatSuccess => '성공';

  @override
  String get transactionHistoryStatPending => '대기';

  @override
  String get transactionHistoryStatFailed => '실패';

  @override
  String get transactionHistoryFilterAll => '전체';

  @override
  String get transactionHistoryFilterSend => '노트 생성';

  @override
  String get transactionHistoryFilterReceive => '수신';

  @override
  String get transactionHistorySelectChain => '네트워크 선택';

  @override
  String get transactionHistoryCopied => '클립보드에 복사했습니다';

  @override
  String get transactionHistoryExplorerInvalidUrl => '탐색기 링크가 올바르지 않습니다';

  @override
  String get transactionHistoryExplorerLaunchFailed =>
      '브라우저를 열 수 없습니다. 설정을 확인하세요';

  @override
  String transactionHistoryExplorerOpenError(String error) {
    return '열기 실패: $error';
  }

  @override
  String get transactionHistoryRefreshed => '노트 생성 기록을 업데이트했습니다';

  @override
  String get transactionHistoryTimeJustNow => '방금';

  @override
  String transactionHistoryTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분 전',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간 전',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 전',
    );
    return '$_temp0';
  }

  @override
  String get transactionHistoryEmptyTitle => '노트 생성 기록 없음';

  @override
  String get transactionHistoryEmptyHintFiltered => '조건에 맞는 노트 생성 기록이 없습니다';

  @override
  String get transactionHistoryEmptyHintAll => '아직 노트 생성 기록이 없습니다';

  @override
  String get transactionHistoryTypeSend => '노트 생성';

  @override
  String get transactionHistoryTypeReceive => '수신';

  @override
  String get transactionHistoryStatusSuccess => '성공';

  @override
  String get transactionHistoryStatusFailed => '실패';

  @override
  String get transactionHistoryStatusPending => '대기 중';

  @override
  String get transactionHistoryDetailFrom => '보낸 주소';

  @override
  String get transactionHistoryDetailTo => '받는 주소';

  @override
  String get transactionHistoryDetailTxHash => '온체인 해시';

  @override
  String get transactionHistoryDetailBlock => '블록';

  @override
  String transactionHistoryGasLine(String fee, String symbol) {
    return 'Gas: $fee $symbol';
  }

  @override
  String homeGasBalanceTitle(String symbol) {
    return '$symbol 가스 잔액';
  }

  @override
  String get homeTotalAssets => '총 잔액';

  @override
  String get homeRefreshBalance => '잔액 새로고침';

  @override
  String get homeGetGas => '가스 받기';

  @override
  String get homeGasHelp => '가스는 온체인 거래 수수료에 필요합니다. 잔액을 충분히 유지하세요.';

  @override
  String getGasDialogTitle(String symbol) {
    return '가스용 $symbol 받기';
  }

  @override
  String getGasDialogSubtitle(String chainName) {
    return '$chainName 노트 계정에 자금을 넣는 방법을 선택하세요';
  }

  @override
  String get getGasOptionReceiveTitle => '토큰 받기';

  @override
  String get getGasBadgeRecommended => '추천';

  @override
  String getGasReceiveHint(String symbol) {
    return '다른 노트 계정 또는 거래소에서 $symbol 보내기';
  }

  @override
  String get getGasWalletAddressLabel => '노트 계정 주소';

  @override
  String get getGasShowQr => 'QR 코드';

  @override
  String get getGasHideQr => '숨기기';

  @override
  String getGasTransferWarning(String chainName) {
    return '송금 네트워크가 $chainName인지 확인하세요. 다르면 노트를 잃을 수 있습니다';
  }

  @override
  String get getGasFaucetTitle => '테스트넷 수도꼭지';

  @override
  String get getGasBadgeFree => '무료';

  @override
  String getGasFaucetHint(String symbol) {
    return '수도꼭지에서 테스트넷 $symbol 무료 받기';
  }

  @override
  String getGasFaucetOpen(int index) {
    return '수도꼭지 $index 열기';
  }

  @override
  String get getGasBuyExchangeTitle => '거래소에서 구매';

  @override
  String get getGasBadgeComingSoon => '곧 제공';

  @override
  String getGasBuyExchangeHint(String symbol) {
    return '거래소에서 $symbol 구매 후 노트 계정으로 출금';
  }

  @override
  String get getGasDialogCancel => '취소';

  @override
  String get getGasAddressCopied => '주소가 복사되었습니다';

  @override
  String get getGasInvalidLink => '유효하지 않은 링크입니다';

  @override
  String get getGasCouldNotOpenLink => '링크를 열 수 없습니다. 브라우저를 확인하세요';

  @override
  String getGasOpenFailed(String error) {
    return '열 수 없음: $error';
  }

  @override
  String get homeRecentNotes => '최근 노트';

  @override
  String get homeRefreshRecentNotes => '최근 노트 새로고침';

  @override
  String get homeLoadingOnChainNotes => '온체인 노트 불러오는 중';

  @override
  String get homeSyncingOnChainNotes => '온체인 노트 동기화 중…';

  @override
  String get homeNoNotesInLastMonth => '최근 한 달간 노트가 없습니다';

  @override
  String get homeCreateNewNotePrompt => '새 노트를 작성해 보세요';

  @override
  String get notesAllChains => '모든 체인';

  @override
  String get notesSwitchedToAllChains => '모든 체인으로 전환했습니다';

  @override
  String get notesFilterAll => '전체';

  @override
  String get notesFilterOnChain => '온체인';

  @override
  String get notesFilterOffChain => '온체인 아님';

  @override
  String get notesSortNewest => '최신순';

  @override
  String get notesSortUpdated => '업데이트순';

  @override
  String get notesSortOldest => '오래된순';

  @override
  String get notesSortTitle => '제목';

  @override
  String notesTimelineNoteCount(int count) {
    return '$count개';
  }

  @override
  String get noteStatsTotalNotes => '전체 노트';

  @override
  String get noteStatsOnChainCount => '온체인';

  @override
  String get noteStatsImages => '이미지';

  @override
  String get noteStatsChars => '글자 수';

  @override
  String get noteDeleteNote => '노트 삭제';

  @override
  String get noteDeleteConfirmTitle => '노트를 삭제할까요?';

  @override
  String get noteDeleteConfirmBody => '이 노트를 삭제하시겠어요? 되돌릴 수 없습니다.';

  @override
  String get noteDeletedSnackbar => '노트가 삭제되었습니다';

  @override
  String noteDeleteFailed(String error) {
    return '삭제 실패: $error';
  }

  @override
  String noteUpdatedAt(String date) {
    return '업데이트 $date';
  }

  @override
  String noteCreatedAt(String date) {
    return '생성 $date';
  }

  @override
  String get noteNoContent => '내용이 없습니다';

  @override
  String get noteEditorCreateNewNote => '새 노트 만들기';

  @override
  String noteEditorChainLine(String chainName) {
    return '$chainName 체인';
  }

  @override
  String get noteEditorSelectChainToPublish => '체인을 선택하면 온체인에 게시할 수 있습니다';

  @override
  String get noteEditorSave => '저장';

  @override
  String get noteEditorSaving => '저장 중…';

  @override
  String get noteTitleLabel => '제목';

  @override
  String get noteTitleHint => '노트 제목을 입력하세요…';

  @override
  String get noteCoverImages => '커버 이미지(선택)';

  @override
  String get noteCoverAdd => '커버 추가';

  @override
  String get noteCoverUploading => '업로드 중…';

  @override
  String get noteCoverTapUpload => '탭하여 커버 이미지 업로드';

  @override
  String get noteCoverFormatsHint => 'JPG, PNG 등 지원';

  @override
  String get noteRichTextGuideTitle => '리치 텍스트 도구';

  @override
  String get noteRichTextHeadingLabel => '제목:';

  @override
  String get noteRichTextHeadingBody => '도구 모음의 «제목»으로 번호 제목을 넣을 수 있습니다.';

  @override
  String get noteRichTextListLabel => '목록:';

  @override
  String get noteRichTextListBody => '글머리 기호 또는 번호 목록을 삽입합니다.';

  @override
  String get noteRichTextEmojiLabel => '이모지:';

  @override
  String get noteRichTextEmojiBody => '자주 쓰는 이모지와 표시를 빠르게 넣을 수 있습니다.';

  @override
  String get noteRichTextTemplateLabel => '템플릿:';

  @override
  String get noteRichTextTemplateBody => '미리 만들어진 템플릿으로 바로 작성을 시작하세요.';

  @override
  String get noteRichTextImageLabel => '이미지:';

  @override
  String get noteRichTextImageBody => '도구 모음의 이미지 버튼으로 본문에 삽입합니다.';

  @override
  String get noteRichTextPreviewHint => '팁: «미리보기»로 서식 결과를 확인하세요.';

  @override
  String get noteEditorContentPlaceholder =>
      '아이디어와 계획을 적어 보세요…\n\n도구 모음으로 빠르게 삽입:\n• 제목과 목록\n• 이모지와 기호\n• 빠른 템플릿\n• 이미지\n\n리치 텍스트를 지원하며 상세 화면에서 보기 좋게 표시됩니다.';

  @override
  String get noteTipsTitle => '작성 팁';

  @override
  String get noteTipsBody =>
      '• 의미 있는 제목을 붙이세요\n• 아이디어, 일정, 중요한 정보를 기록하세요\n• 이미지로 내용을 풍부하게 하세요\n• 저장 후 온체인에 게시해 영구 보관할 수 있습니다';

  @override
  String get noteReadyTitle => '준비 완료';

  @override
  String get noteReadyBody => '내용이 채워졌습니다. 오른쪽 위 «저장»을 눌러 노트를 만드세요.';

  @override
  String get noteTypeSectionLabel => '노트 유형:';

  @override
  String get notePublishToChain => '체인에 게시';

  @override
  String get notePublishing => '게시 중…';

  @override
  String get noteOnChainPublished => '온체인됨';

  @override
  String get selectBlockchainFirst => '먼저 블록체인 네트워크를 선택하세요';

  @override
  String get noteImageAdded => '이미지가 추가되었습니다';

  @override
  String get noteImagePickFailed => '이미지를 선택하지 못했습니다';

  @override
  String get noteSavedToLocal => '로컬에 저장되었습니다';

  @override
  String get notePublishFailedKeptDraft => '게시에 실패했습니다. 초안으로 저장했습니다';

  @override
  String get noteSavedAsDraft => '초안으로 저장되었습니다';

  @override
  String get richTextPreviewMode => '미리보기';

  @override
  String get richTextEditMode => '편집 모드';

  @override
  String get richTextPreview => '미리보기';

  @override
  String get richTextEdit => '편집';

  @override
  String richTextLineCount(int count) {
    return '$count줄';
  }

  @override
  String richTextCharCount(int count) {
    return '$count자';
  }

  @override
  String get richTextToolbarBottomHint =>
      '팁: 도구 모음으로 빠르게 서식을 넣거나 이모지와 기호를 직접 입력하세요.';

  @override
  String get richTextToolbarHeading => '제목';

  @override
  String get richTextTooltipInsertHeading => '제목 삽입';

  @override
  String get richTextTooltipBulletList => '글머리 목록 삽입';

  @override
  String get richTextTooltipNumberedList => '번호 목록 삽입';

  @override
  String get richTextTooltipStatusMarkers => '상태 표시 삽입';

  @override
  String get richTextToolbarEmojiMenu => '이모지';

  @override
  String get richTextTooltipInsertEmoji => '이모지 삽입';

  @override
  String get richTextToolbarTemplate => '템플릿';

  @override
  String get richTextTooltipQuickTemplate => '빠른 템플릿';

  @override
  String get richTextTooltipAddImage => '이미지 추가';

  @override
  String get richTextMdImageAlt => '이미지';

  @override
  String get richTextInsertNumberedHeading => '\n1️⃣ 제목\n';

  @override
  String get richTextInsertBulletLines => '\n• 항목 1\n• 항목 2\n• 항목 3\n';

  @override
  String get richTextInsertNumberedLines => '\n1. 첫 번째\n2. 두 번째\n3. 세 번째\n';

  @override
  String get richTextInsertStatusMarkers => '\n🟢 완료\n🔵 진행 중\n🟡 대기\n';

  @override
  String get richTextEmojiGroupNumberedTitle => '숫자 제목';

  @override
  String get richTextEmojiGroupStatus => '상태 표시';

  @override
  String get richTextEmojiGroupSymbols => '자주 쓰는 기호';

  @override
  String get richTextEmojiGroupEmoji => '이모지';

  @override
  String get richTextEmojiHeadingWord => '제목';

  @override
  String get richTextEmojiBodyWord => '내용';

  @override
  String get richTextTplStandardNoteName => '📝 표준 노트';

  @override
  String get richTextTplStandardNoteBody =>
      '제목\n\n본문:\n• 항목 1\n• 항목 2\n• 항목 3\n\n요약:\n';

  @override
  String get richTextTplTaskName => '✅ 할 일 목록';

  @override
  String get richTextTplTaskBody =>
      '할 일 목록\n\n오늘:\n✓ 완료\n✗ 미완료\n→ 진행 중\n\n메모:\n';

  @override
  String get richTextTplStudyName => '📚 학습 노트';

  @override
  String get richTextTplStudyBody =>
      '학습 노트 - 주제\n\n1️⃣ 핵심 개념\n• 개념 1: 설명\n• 개념 2: 설명\n\n2️⃣ 정리\n• 요점 1\n• 요점 2\n\n3️⃣ 실습\n';

  @override
  String get richTextTplIdeaName => '💡 아이디어';

  @override
  String get richTextTplIdeaBody =>
      '💡 아이디어\n\n생각:\n🟢 핵심 아이디어\n\n장점:\n• 장점 1\n• 장점 2\n\n다음:\n→ 다음 단계\n';

  @override
  String get richTextTplProjectName => '📊 프로젝트 계획';

  @override
  String get richTextTplProjectBody =>
      '프로젝트 계획\n\n🎯 목표:\n\n📝 단계:\n1. 1단계\n2. 2단계\n3. 3단계\n\n⏰ 일정:\n';

  @override
  String get gasPreviewTitle => '가스 미리보기';

  @override
  String get gasPreviewSubtitle => '가스 속도를 선택한 뒤 온체인 게시를 확인하세요.';

  @override
  String get gasPreviewLoading => '가스 비용을 불러오는 중…';

  @override
  String get gasPreviewPickSpeed => '가스 속도';

  @override
  String get gasPreviewLiveRates => '실시간 추정';

  @override
  String get gasSpeedSlow => '느림';

  @override
  String get gasSpeedStandard => '표준';

  @override
  String get gasSpeedFast => '빠름';

  @override
  String get gasTimeSlow => '약 3–5분';

  @override
  String get gasTimeStandard => '약 1–2분';

  @override
  String get gasTimeFast => '약 15–30초';

  @override
  String get gasDescSlow => 'baseFee×1.1, 우선 수수료 = max(30Gwei, 권장) + 3Gwei';

  @override
  String get gasDescStandard =>
      'baseFee×1.25, 우선 수수료 = max(30Gwei, 권장) + 8Gwei';

  @override
  String get gasDescFast => 'baseFee×1.5, 우선 수수료 = max(30Gwei, 권장) + 20Gwei';

  @override
  String get gasLabelGasPrice => '가스 가격';

  @override
  String get gasLabelEstCost => '예상 비용';

  @override
  String get gasRecommendedBadge => '추천';

  @override
  String gasPreviewGweiMax(String value) {
    return '$value Gwei (최대)';
  }

  @override
  String get gasFeeBreakdownTitle => '비용 내역';

  @override
  String get gasFeeRowBase => '기본 수수료';

  @override
  String get gasFeeRowPriority => '우선 수수료';

  @override
  String get gasFeeRowNoteSize => '노트 크기';

  @override
  String get gasFeeRowTotal => '합계';

  @override
  String gasFeeNoteSizeKb(String kb) {
    return '$kb KB';
  }

  @override
  String get gasWarningTitle => '알림';

  @override
  String get gasWarningBody =>
      '• 가스는 네트워크에 지불하며 앱과 무관합니다.\n• 혼잡에 따라 실제 금액이 달라질 수 있습니다.\n• 온체인 후에는 삭제·수정이 불가합니다.';

  @override
  String get gasConfirmOnChain => '온체인 확인';

  @override
  String get gasOnChainConfirmDialogTitle => '온체인 후 수정 불가';

  @override
  String get gasOnChainConfirmDialogBody =>
      '이 노트는 블록체인(IPFS + 온체인 기록)에 기록됩니다.\n제출 후에는 삭제하거나 수정할 수 없습니다. 내용을 확인한 뒤 계속하세요.';

  @override
  String get gasOnChainConfirmDialogQuestion => '온체인으로 게시하시겠습니까?';

  @override
  String get onChainConfirmParamSummarySectionTitle => '호출 파라미터';

  @override
  String get noteOnChainParamJsonKeyNetwork => '네트워크';

  @override
  String get noteOnChainParamJsonKeyChainId => '체인 ID';

  @override
  String get noteOnChainParamJsonKeyFeeToken => '가스 결제 토큰';

  @override
  String get noteOnChainParamJsonKeySender => '발신 주소(내 노트 계정)';

  @override
  String get noteOnChainParamJsonKeyContract => '컨트랙트 주소';

  @override
  String get noteOnChainParamJsonKeyContractName => '컨트랙트 이름';

  @override
  String get noteOnChainParamJsonKeyFunction => '호출 함수';

  @override
  String get noteOnChainParamJsonKeyNoteTitle => '노트 제목';

  @override
  String get noteOnChainParamJsonKeyContentSha256 => '본문 지문 SHA-256';

  @override
  String get noteOnChainParamJsonGroupMintCall => '온체인 호출(컨트랙트 인자)';

  @override
  String get noteOnChainParamJsonGroupContext => '지금 확인할 수 있는 정보';

  @override
  String get noteOnChainParamJsonValueUriPending =>
      '보안 인증 후 IPFS 업로드가 끝나면 실제 ipfs:// 주소가 채워집니다';

  @override
  String get noteOnChainConfirmPageTitle => '온체인 게시 확인';

  @override
  String get noteOnChainConfirmPageSubtitle => '노트를 블록체인에 영구 저장합니다';

  @override
  String get noteOnChainConfirmNoExplorer =>
      '이 네트워크에는 블록 탐색기가 설정되어 있지 않아 계약을 열 수 없습니다.';

  @override
  String get noteOnChainConfirmMintStatusUncertain =>
      '온체인 상태를 확인할 수 없습니다. 나중에 노트나 탐색기에서 확인하세요.';

  @override
  String get noteOnChainConfirmSignButton => '확인 후 보안 인증';

  @override
  String get noteOnChainConfirmTipTitle => '게시 전 안내';

  @override
  String get noteOnChainConfirmTipBody =>
      '• 게시 후 노트는 수정하거나 삭제할 수 없습니다\n• 노트가 영구적으로 온체인되며 귀하의 소유가 됩니다\n• 소액의 가스비가 한 번만 필요합니다';

  @override
  String get noteOnChainConfirmNoteContentSection => '노트 내용';

  @override
  String get noteOnChainConfirmNoteTitleLabel => '제목';

  @override
  String get noteOnChainConfirmContentPreview => '본문 미리보기';

  @override
  String get noteOnChainConfirmNoteHashLabel => '노트 해시 (SHA-256)';

  @override
  String get noteOnChainConfirmChainDetailsSection => '온체인 상세';

  @override
  String get noteOnChainConfirmMyWallet => '내 노트 계정';

  @override
  String get noteOnChainConfirmTargetContract => '대상 컨트랙트';

  @override
  String get noteOnChainConfirmContractOwnershipHint =>
      '컨트랙트가 노트(NFT)를 민팅합니다. 노트(NFT)는 노트 계정에 귀속되며 노트에 대한 영구 소유권을 갖습니다.';

  @override
  String noteOnChainConfirmNoteRecipientAddress(String address) {
    return '노트 수신 주소: $address';
  }

  @override
  String get noteOnChainConfirmNetworkFee => '네트워크 수수료';

  @override
  String get noteOnChainConfirmGasPriceLabel => '가스 단가';

  @override
  String get noteOnChainConfirmGasLimitLabel => '가스 한도';

  @override
  String get noteOnChainConfirmOnChainFee => '온체인 수수료';

  @override
  String get noteOnChainConfirmGasOnlyHint => '가스만 지불';

  @override
  String get noteOnChainConfirmAdvancedSection => '고급';

  @override
  String get noteOnChainConfirmNonceLabel => 'Nonce';

  @override
  String get noteOnChainConfirmNetworkLabel => '네트워크';

  @override
  String get noteOnChainConfirmGasSlow => '느림';

  @override
  String get noteOnChainConfirmGasNormal => '표준';

  @override
  String get noteOnChainConfirmGasFast => '빠름';

  @override
  String get noteOnChainConfirmGasTimeSlow => '약 5분';

  @override
  String get noteOnChainConfirmGasTimeNormal => '약 1분';

  @override
  String get noteOnChainConfirmGasTimeFast => '약 15초';

  @override
  String get saveOptionsTitle => '저장 방식 선택';

  @override
  String get saveOptionsSubtitle => '필요에 맞는 저장 방식을 고르세요.';

  @override
  String get saveOnChainTitle => '온체인에 저장';

  @override
  String get saveOnChainDescription => '블록체인에 영구 저장, 변조에 강함';

  @override
  String get saveOnChainFeature1 => '영구 보관';

  @override
  String get saveOnChainFeature2 => '검증 가능';

  @override
  String get saveOnChainFeature3 => '분산형';

  @override
  String get ipfsUploadConfirmTitle => 'IPFS에 업로드';

  @override
  String get ipfsUploadConfirmBody =>
      '이 노트에 로컬 이미지가 있습니다. 온체인 전에 분산 저장소(IPFS)로 업로드해야 합니다. 업로드 후 블록체인 기록 단계로 진행할 수 있습니다.\n\nIPFS에 업로드하고 계속할까요?';

  @override
  String get saveBadgeSecure => '안전';

  @override
  String get saveDraftTitle => '초안으로 저장';

  @override
  String get saveDraftDescription => '나중에 편집. 아직 체인 리소스 없음';

  @override
  String get saveDraftFeature1 => '언제든 편집';

  @override
  String get saveDraftFeature2 => '로컬 저장';

  @override
  String get saveDraftFeature3 => '빠른 저장';

  @override
  String get saveBadgeRecommended => '추천';

  @override
  String get saveLocalTitle => '로컬에 저장';

  @override
  String get saveLocalDescription => '이 기기에만 보관';

  @override
  String get saveLocalFeature1 => '오프라인';

  @override
  String get saveLocalFeature2 => '즉시 저장';

  @override
  String get saveLocalFeature3 => '수수료 없음';

  @override
  String saveWillPublishToChain(String chainName) {
    return '$chainName에 저장됩니다';
  }

  @override
  String get guideWelcomeTitle => '온체인 노트에 오신 것을 환영합니다';

  @override
  String get guideWelcomeSubtitle => '시작하기 전에 노트 계정을 설정하세요';

  @override
  String get guideSecurityTitle => '내 데이터는 내가 관리합니다';

  @override
  String get guideSecurityBody =>
      '개인 키는 기기에만 보관되며 서버에 민감 정보를 저장하지 않습니다. 복구 구문과 개인 키를 안전하게 보관하세요.';

  @override
  String get guideCreateWalletTitle => '새 노트 계정 만들기';

  @override
  String get guideCreateWalletSubtitle => '새 주소와 복구 구문을 생성합니다';

  @override
  String get guideRecommendedNewUser => '처음 사용자께 추천';

  @override
  String get guideImportWalletTitle => '기존 노트 계정 복원';

  @override
  String get guideImportWalletSubtitle => '복구 구문 또는 개인 키로 복원합니다';

  @override
  String get guideTagMnemonic => '복구 구문';

  @override
  String get guideTagPrivateKey => '개인 키';

  @override
  String get guideICloudRestoreTitle => 'iCloud에서 복원';

  @override
  String get guideICloudRestoreSubtitle => 'iCloud에 백업해 두었다면 빠르게 복원할 수 있습니다';

  @override
  String get guideBadgeIosOnly => 'iOS 전용';

  @override
  String get guideGoogleRestoreTitle => 'Google 드라이브에서 복원';

  @override
  String get guideGoogleRestoreSubtitle =>
      'Google 드라이브에 백업해 두었다면 빠르게 복원할 수 있습니다';

  @override
  String get guideBadgeAllDevices => '모든 기기 지원';

  @override
  String get guideFooterHint => '원하는 방법을 선택해 계속하세요.\n개인 키는 이 기기에 안전하게 저장됩니다.';

  @override
  String get guideProviderICloud => 'iCloud';

  @override
  String get guideProviderGoogleDrive => 'Google 드라이브';

  @override
  String get guideLoadingWalletMessage => '노트 계정 불러오는 중…';

  @override
  String googlePlayReviewModeTapHint(int remaining) {
    return '심사 모드까지 $remaining번 더 탭하세요';
  }

  @override
  String get helpCenter => '도움말';

  @override
  String get helpCenterSubtitle => '자주 묻는 질문 및 이용 안내';

  @override
  String get helpSectionQuickGuide => '빠른 안내';

  @override
  String get helpSectionFaq => '자주 묻는 질문';

  @override
  String get helpSearchHint => '질문 검색…';

  @override
  String get helpCategoryAll => '전체';

  @override
  String get helpCategoryBasics => '기본 사용';

  @override
  String get helpCategoryBlockchain => '블록체인';

  @override
  String get helpCategoryWalletSecurity => '노트 계정 보안';

  @override
  String get helpCategoryWalletMgmt => '노트 계정 관리';

  @override
  String get helpCategoryAdvanced => '고급 기능';

  @override
  String get helpCategoryCommon => '자주 있는 문제';

  @override
  String get helpComingSoon => '곧 제공 예정';

  @override
  String get helpEmptyTitle => '일치하는 질문이 없습니다';

  @override
  String get helpEmptySubtitle => '다른 키워드를 시도하거나 고객 지원으로 문의하세요';

  @override
  String get helpContactTitle => '고객 지원';

  @override
  String get helpContactSubtitle => '답이 없으면 이메일로 문의하세요';

  @override
  String get helpContactSendFeedback => '의견 보내기';

  @override
  String get helpContactYourEmailOptional => '이메일（선택）';

  @override
  String get helpContactEmailHint => '';

  @override
  String get helpContactMessageLabel => '내용';

  @override
  String get helpContactMessageHint => '문제나 제안을 입력하세요…';

  @override
  String get helpContactSending => '전송 중…';

  @override
  String get helpContactSend => '보내기';

  @override
  String get helpCopySupportEmail => '이메일 주소가 복사되었습니다';

  @override
  String get helpFeedbackEmpty => '의견을 입력하세요';

  @override
  String get helpFeedbackThanks => '피드백 감사합니다!';

  @override
  String get helpFeedbackMailFailed => '메일을 열 수 없습니다. 나중에 다시 시도하세요.';

  @override
  String get helpFeedbackMailSubject => '사용자 의견';

  @override
  String get helpQuickGuide1Title => '빠른 시작';

  @override
  String get helpQuickGuide1Desc => '5분 안에 기본 기능 알아보기';

  @override
  String get helpQuickGuide2Title => '첫 번째 노트 만들기';

  @override
  String get helpQuickGuide2Desc => '노트를 만들고 온체인에 게시';

  @override
  String get helpQuickGuide3Title => '복구 구문 백업';

  @override
  String get helpQuickGuide3Desc => '노트와 데이터를 안전하게';

  @override
  String get helpQuickGuide4Title => '여러 노트 계정 관리';

  @override
  String get helpQuickGuide4Desc => '만들기, 복원 및 전환';

  @override
  String get helpFaq1Question => '온체인 노트란?';

  @override
  String get helpFaq1Answer =>
      '블록체인에 노트를 영구 저장하는 앱입니다. 온체인에 게시되면 원칙적으로 변경·삭제가 어렵습니다.';

  @override
  String get helpFaq2Question => '노트는 어떻게 만드나요?';

  @override
  String get helpFaq2Answer =>
      '홈의 ‘노트 만들기’ 또는 목록의 ‘+’로 생성합니다. 제목·본문·이미지를 추가할 수 있습니다.';

  @override
  String get helpFaq3Question => '저장 방식은?';

  @override
  String get helpFaq3Answer =>
      '초안(언제든 편집)·로컬 저장·온체인 저장 세 가지입니다. 먼저 초안으로 다듬은 뒤 게시하는 것을 권장합니다.';

  @override
  String get helpFaq4Question => '온체인 저장과 수수료는?';

  @override
  String get helpFaq4Answer => '블록체인에 영구 기록됩니다. 가스 비용은 네트워크가 부과하며 네트워크마다 다릅니다.';

  @override
  String get helpFaq5Question => '지원 네트워크는?';

  @override
  String get helpFaq5Answer =>
      'Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Fantom, Base 등 주요 EVM을 지원합니다. 홈에서 전환합니다.';

  @override
  String get helpFaq6Question => '온체인 여부는 어떻게 확인하나요?';

  @override
  String get helpFaq6Answer => '트랜잭션 해시를 상세 화면이나 블록 익스플로러에서 확인할 수 있습니다.';

  @override
  String get helpFaq7Question => '복구 구문이란? 백업은?';

  @override
  String get helpFaq7Answer =>
      '복구 구문(보통 영어 12단어)은 노트 계정을 복구하는 마스터 키입니다.\n\n분실하면 영구적으로 접근하지 못할 수 있습니다.\n유출하면 노트가 영구적으로 잃거나 다른 사람이 관리할 수 있습니다.\n앱이 대신 복구해 줄 수 없습니다.\n종이에 적어 안전한 곳에 보관하세요.';

  @override
  String get helpFaq8Question => '복구 구문 백업 순서는?';

  @override
  String get helpFaq8Answer =>
      '프로필→백업→안내 확인→순서대로 적기→검증→완료. 타인이 볼 수 없는 곳에서 진행하세요.';

  @override
  String get helpFaq9Question => '복구 구문과 개인 키 차이는?';

  @override
  String get helpFaq9Answer =>
      '둘 다 복구에 사용됩니다. 복구 구문은 단어열로 다루기 쉽고 권장됩니다. 개인 키는 긴 16진 문자열로 고급 사용자용입니다.';

  @override
  String get helpFaq10Question => '노트 계정 전환은?';

  @override
  String get helpFaq10Answer =>
      '홈 상단 주소를 눌러 선택하거나 노트 계정 관리에서 생성·복원를 합니다. 여러 노트 계정을 관리할 수 있습니다.';

  @override
  String get helpFaq11Question => '체인별 주소는?';

  @override
  String get helpFaq11Answer =>
      '내 노트 계정에서 카드를 펼치면 각 체인 주소가 보이며 탭으로 복사합니다. EVM 호환 체인은 같은 형식의 주소입니다.';

  @override
  String get helpFaq12Question => 'RPC 사용자 정의는?';

  @override
  String get helpFaq12Answer =>
      '프로필→네트워크 설정→네트워크 선택→노드 추가→URL 입력→테스트→기본 설정. 안정성에 도움이 됩니다.';

  @override
  String get helpFaq13Question => '리치 텍스트 지원은?';

  @override
  String get helpFaq13Answer => '굵게·기울임·밑줄, 제목, 목록, 인용, 코드, 이미지 업로드 등을 지원합니다.';

  @override
  String get helpFaq14Question => '온체인 후 수정·삭제가 되나요?';

  @override
  String get helpFaq14Answer =>
      '원칙적으로 불가능합니다. 초안에서 충분히 검토한 뒤 게시하고 민감 정보는 올리지 마세요.';

  @override
  String get helpFaq15Question => '왜 대기 시간이 있나요?';

  @override
  String get helpFaq15Answer =>
      '트랜잭션이 채굴될 때까지 걸립니다. 혼잡도와 가스 속도에 따라 보통 수분 이내입니다.';

  @override
  String get helpFaq16Question => '비밀번호를 잊었어요?';

  @override
  String get helpFaq16Answer =>
      '복구 구문으로 다시 복원한 뒤 새 비밀번호를 설정할 수 있습니다. 비밀번호는 기기 암호화용이며 최종 복구는 복구 구문입니다.';

  @override
  String helpFeedbackMailBody(String email, String message) {
    return '연락 이메일: $email\n\n$message';
  }

  @override
  String get termsOfServiceLastUpdatedLabel => '최종 업데이트';

  @override
  String get termsOfServiceIntroTitle => '중요 안내';

  @override
  String termsOfServiceIntroBody(String privacyDoc) {
    return '본 이용약관과 $privacyDoc을(를) 주의 깊게 읽어 주세요. 서비스를 이용하면 관련 규칙을 이해하고 동의한 것으로 간주됩니다. 동의하지 않으면 이용하지 마세요.';
  }

  @override
  String get termsOfServiceHelpTitle => '도움이 필요하신가요?';

  @override
  String get termsOfServiceHelpBody =>
      '본 약관에 대한 문의는 앱 내 고객센터를 이용하거나 설정의 피드백·이메일로 연락해 주세요. 합리적인 시간 내에 최대한 답변드리겠습니다.';

  @override
  String get termsOfServiceHelpMailFeedback => '이메일 피드백';

  @override
  String get termsOfServiceSection01Title => '1. 약관 동의';

  @override
  String termsOfServiceSection01Body(String appTitle) {
    return '「$appTitle」(이하 “본 서비스”)에 오신 것을 환영합니다. 이용 전 본 이용약관(이하 “본 약관”)을 읽어 주세요.\n동의 탭, 가입, 로그인 또는 실제 이용 시 본 약관에 동의한 것으로 봅니다. 동의하지 않으면 이용을 중단해 주세요.\n당사는 약관을 수시로 개정할 수 있으며, 앱 내 공지 또는 업데이트 후에도 계속 이용하면 개정 약관에 동의한 것으로 봅니다.';
  }

  @override
  String get termsOfServiceSection02Title => '2. 서비스 설명';

  @override
  String get termsOfServiceSection02Body =>
      '본 서비스는 로컬 저장과 블록체인 관련 기능을 결합한 메모 앱입니다. 기기에서 메모를 만들고 편집·관리할 수 있으며, 선택에 따라 온체인 작업(거래, 해시, 메타데이터 등, 앱 내 절차·안내에 따름)을 수행할 수 있습니다.\n현재 구현 특징(버전에 따라 변경될 수 있음):\n• 로컬 저장: 메모 등 데이터는 주로 기기(예: 로컬 DB)에 저장됩니다. 앱을 삭제하면 로컬 데이터가 사라질 수 있으니 직접 백업하세요.\n• 온체인 기능: 증명, 동기화, 표시 등을 위해 자발적으로 온체인 작업을 제출할 수 있습니다. 온체인 기록은 공개되고 삭제가 어려운 경우가 많습니다.\n• 멀티체인: 앱에 나열된 여러 EVM 호환 네트워크를 지원합니다.\n• 노트 계정: 키는 기기에서 생성·가져오며, 복구 구문·보안 키 보관은 사용자 책임입니다.\n본 서비스는 기술 도구만 제공하며, 콘텐츠의 합법성·정확성·완전성·특정 목적 적합성을 보증하지 않습니다.';

  @override
  String get termsOfServiceSection03Title => '3. 노트 계정 및 보안';

  @override
  String get termsOfServiceSection03Body =>
      '3.1 노트 계정 및 자격 증명: 노트 계정을 만들거나 복원한 후 앱은 기기 측에서 주소와 키 자료를 관리합니다. 복구 구문·보안 키는 노트 복구의 실질적 수단 중 하나이므로 오프라인으로 백업하고 엄격히 보관하세요.\n3.2 보안 책임: 기기에서 앱 또는 노트 계정이 잠금 해제된 상태에서 수행된 작업은 사용자 또는 허용된 환경에서의 작업으로 간주합니다. 복구 구문·보안 키 유출, 기기 분실, 악성코드, 피싱, 안내 미준수 등으로 인한 손실은 사용자가 부담합니다.\n3.3 보안 권고:\n• 누구에게도 복구 구문·보안 키를 알려 주지 마세요\n• 강력한 앱 비밀번호를 설정하고 가능한 경우 기기 잠금·생체 인증을 켜세요\n• 신뢰할 수 있는 환경에서 복구 구문을 백업하고 내용을 검증하세요\n• 사칭 앱·피싱 링크를 주의하세요\n3.4 당사 및 직원은 어떤 이유로도 전체 복구 구문이나 보안 키를 요구하지 않습니다. 그런 요청은 거절하고 공식 채널로 신고해 주세요.';

  @override
  String get termsOfServiceSection04Title => '4. 온체인 거래 및 수수료';

  @override
  String termsOfServiceSection04Body(String appTitle) {
    return '4.1 가스·네트워크 비용: 온체인 거래에는 네트워크에 지불하는 수수료(가스 등)가 필요합니다. 비용은 네트워크가 징수하며 소프트웨어 제공자인 「$appTitle」이 상업적으로 대행 징수하는 것이 아닙니다. 금액은 네트워크와 혼잡 상황에 따릅니다.\n4.2 확인 시간: 거래는 네트워크 확인이 필요하며 소요 시간은 네트워크 상태와 수수료 설정에 따릅니다. 구체적 소요 시간을 보장하지 않습니다.\n4.3 실패 및 과금: 잔액 부족, RPC 오류, 사용자 취소, 컨트랙트 리버트 등으로 실패할 수 있으며, 이미 소모된 네트워크 비용은 네트워크 규칙에 따라 환불되지 않을 수 있습니다.\n4.4 불가역성: 충분히 확인된 온체인 거래는 일반적으로 취소할 수 없습니다. 보안 인증·브로드캐스트 전 네트워크·금액·컨트랙트 호출 내용을 재확인하세요.\n4.5 사용자가 시작한 모든 온체인 작업과 그 결과에 대해 사용자가 책임집니다. 법이 허용하는 범위에서 블록체인 프로토콜, 제3자 노드, 스마트 컨트랙트 또는 본인 실수로 인한 손해에 대해 당사는 책임지지 않습니다.';
  }

  @override
  String get termsOfServiceSection05Title => '5. 이용 규범';

  @override
  String get termsOfServiceSection05Body =>
      '본 서비스 이용 시 다음을 해서는 안 됩니다.\n• 불법·침해·명예훼손·음란·폭력·혐오 기타 불법 콘텐츠의 제작·업로드·유포\n• 사기, 자금세탁, 불법 모금, 지식재산권 침해, 규제기관이 금지한 행위에 서비스 이용\n• 허가 없이 본 서비스 또는 관련 인프라에 대한 접근·탐사·방해·훼손\n• 스크래핑, API 남용, 다른 사용자의 정상 이용을 해치는 행위(서면 허가가 있는 경우 제외)\n• 괴롭힘이나 무단 상업 메시지 대량 발송\n위반 시 경고, 기능 제한, 이용 중단·종료 등 조치를 취할 수 있으며, 법령 또는 규제 당국 요청에 따라 협조할 수 있습니다.';

  @override
  String get termsOfServiceSection06Title => '6. 지식재산권';

  @override
  String get termsOfServiceSection06Body =>
      '6.1 서비스 자체: 클라이언트 소프트웨어, UI, 상표, 문서 등의 저작권·상표권 등은 당사 또는 권리자에게 귀속됩니다. 허가 없이 핵심 소프트웨어의 복제·리버스 엔지니어링·크랙·상업적 재배포를 해서는 안 됩니다(법이 허용하는 합리적 사용 제외).\n6.2 사용자 콘텐츠: 직접 작성한 메모 등의 권리는 사용자에게 남으며, 본 약관이 그 권리를 당사로 이전하지는 않습니다.\n6.3 당사에 대한 라이선스: 동기화, 표시, 백업, 온체인 제출 등 서비스 운영·개선에 필요한 범위에서 비독점·로열티 없음(약관에서 허용하는 범위에서 철회 가능) 라이선스를 부여합니다.\n6.4 서면 허가 없이 상표·앱 이름·로고를 혼동을 일으키는 방식으로 사용하지 마세요.';

  @override
  String get termsOfServiceSection07Title => '7. 면책';

  @override
  String get termsOfServiceSection07Body =>
      '7.1 “있는 그대로”: 법이 허용하는 최대 범위에서 본 서비스는 “있는 그대로”“이용 가능한 범위에서” 제공됩니다. 중단 없는 운영, 오류 없음, 모든 요구 충족, 모든 기기·소프트웨어와의 호환에 대한 명시·묵시적 보증은 하지 않습니다.\n7.2 데이터·보안: 합리적 조치를 취하지만 불가항력, 기기 분실, 바이러스, 공격, 블록체인/IPFS 등 외부 시스템으로 인한 유출·손실·중단이 결코 없음을 보증할 수 없습니다.\n7.3 제3자: 노드, 게이트웨이, 탈중앙 저장소, 푸시 등 제3자 서비스에 의존할 수 있으며, 가용성·정확성·준수 여부를 보증하지 않습니다. 위험은 스스로 평가하세요.\n7.4 온체인 노트 및 프로토콜 위험: 온체인 노트 및 관련 프로토콜에는 네트워크 이상, 버그, 포크 등 고유 위험이 있으며 사용자가 이해하고 부담합니다.\n7.5 책임 제한: 법이 금지하는 경우를 제외하고 간접·부수·특별·결과적 손해에 대해 책임지지 않습니다. 총 배상액은 해당 분쟁 서비스에 대해 사용자가 당사에 실제 지급한 금액을 상한으로 합니다(0이면 0).';

  @override
  String get termsOfServiceSection08Title => '8. 변경·중단·종료';

  @override
  String get termsOfServiceSection08Body =>
      '8.1 사업, 컴플라이언스, 기술적 사유로 기능을 변경·일시 중단·종료할 수 있으며, 가능한 경우 앱 내에 안내합니다.\n8.2 사용자는 언제든 이용을 중단하고 앱을 삭제할 수 있습니다. 중요한 데이터는 사전에 내보내기·백업하세요.\n8.3 본 약관에 중대하게 위반하면 이용을 중단·종료할 수 있습니다.\n8.4 종료 후 법이 달리 정하지 않는 한 온체인, 제3자 네트워크 또는 사용자가 통제하는 로컬에 이미 있는 데이터를 보관·반환할 의무는 없습니다.';

  @override
  String get termsOfServiceSection09Title => '9. 준거법 및 분쟁';

  @override
  String get termsOfServiceSection09Body =>
      '9.1 본 약관의 성립, 효력, 해석 및 이행은 중화인민공화국 본토 법률에 따릅니다(본 약관 목적에 한하며, 외국법을 선택하게 하는 충돌법 규칙은 강행법에 달리 정함이 없는 한 제외합니다).\n9.2 분쟁은 우선 성실히 협의로 해결합니다.\n9.3 협의가 되지 않으면 관할 법원에 소를 제기할 수 있습니다(예: 당사 주된 사무소 소재지 관할). 강제적 관할 규칙과 충돌하면 법에 따릅니다.';

  @override
  String get termsOfServiceSection10Title => '10. 기타';

  @override
  String termsOfServiceSection10Body(String privacyDoc) {
    return '10.1 완전한 합의: 본 약관, $privacyDoc(해당 시) 및 앱 내 특별 규칙이 본 서비스 이용의 주된 규율을 구성합니다. 충돌 시 해당 주제에 대해서는 특별 규칙이 우선합니다(강행법 위반 불가).\n10.2 분리 가능성: 어떤 조항이 무효·집행 불능이어도 나머지는 유효하며 합법적 범위에서 원래 의도에 최대한 가깝게 해석합니다.\n10.3 권리 포기 아님: 권리를 행사하지 않았다고 포기로 보지 않습니다.\n10.4 문의: 법이 다른 의무적 채널을 정하지 않는 한 앱 내 고객센터 또는 피드백으로 본 약관에 관해 물을 수 있습니다.';
  }

  @override
  String termsOfServiceFooterLine1(String appTitle) {
    return '$appTitle을(를) 믿고 이용해 주셔서 감사합니다.';
  }

  @override
  String get connectEvmAccountFirst => '먼저 EVM 노트 계정을 연결하세요';

  @override
  String get createAccountFailedRetry => '노트 계정 생성에 실패했습니다. 나중에 다시 시도하세요';

  @override
  String createAccountFailedWithError(String error) {
    return '노트 계정 생성 실패: $error';
  }

  @override
  String get transactionHistoryConnectEvm =>
      '네트워크를 선택하고 EVM 노트 계정이 연결되었는지 확인하세요';

  @override
  String get transactionHistoryUnsupportedNetwork =>
      '이 네트워크는 노트 생성 기록 목록을 아직 지원하지 않습니다. 일반 EVM 네트워크로 전환하세요.';

  @override
  String get securityVerificationFailed => '보안 인증 실패';

  @override
  String get walletImportPrivateKeyHint => '보안 키를 입력하세요. 다른 사람에게 공유하지 마세요.';

  @override
  String get walletImportPrivateKeySubmit => '보안 키 복원';
}
