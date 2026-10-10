// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ChainNotes';

  @override
  String get tabHome => 'Home';

  @override
  String get tabNotes => 'Notes';

  @override
  String get tabProfile => 'Me';

  @override
  String get myNotes => 'My Notes';

  @override
  String notesCount(int count) {
    return '$count notes';
  }

  @override
  String get createNote => 'Create Note';

  @override
  String get selectNetwork => 'Select Network';

  @override
  String get selectNetworkSubtitle =>
      'Choose the blockchain network you want to use';

  @override
  String get chainSelectorMainnetTab => 'Mainnet';

  @override
  String get chainSelectorTestnetTab => 'Testnet';

  @override
  String get chainSelectorFooterHint =>
      'After you switch networks, notes are saved on the corresponding blockchain.';

  @override
  String get chainSelectorTestnetNoticeTitle => 'About testnets';

  @override
  String get chainSelectorTestnetNoticeBody =>
      'Testnets are for development and testing; tokens have no real value.';

  @override
  String get chainSelectorAllChainsTitle => 'All chains';

  @override
  String get chainSelectorAllChainsSubtitle => 'Show notes from all chains';

  @override
  String chainSelectorChainIdLabel(int chainId) {
    return 'Chain ID: $chainId';
  }

  @override
  String get chainSelectorCurrentBadge => 'Current';

  @override
  String chainSelectorGasLabel(String cost) {
    return 'Gas: $cost';
  }

  @override
  String get chainGasCostLevelMedium => 'Medium';

  @override
  String get chainSelectorTestnetChainWarning => 'Testnet — no real value';

  @override
  String get viewAll => 'View All';

  @override
  String get aboutUs => 'About Us';

  @override
  String get aboutPageTagline =>
      'Permanent storage · Tamper-proof · Full control';

  @override
  String splashVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get aboutPageVersionSection => 'Version info';

  @override
  String get aboutPageCurrentVersion => 'Current version';

  @override
  String get photosPermissionDeniedSnack =>
      'Photo library access is required. Enable it in Settings and try again.';

  @override
  String get pressBackAgainToExitApp => 'Press back again to exit';

  @override
  String noteEditorOnChainTypeConfirmedSnack(String publishAction) {
    return 'On-chain type confirmed. Save the note or tap \"$publishAction\" to continue.';
  }

  @override
  String get actionShow => 'Show';

  @override
  String get actionHide => 'Hide';

  @override
  String get actionSaveToFile => 'Save to file';

  @override
  String get mnemonicExportSecurityConfirmTitle => 'Security confirmation';

  @override
  String get mnemonicExportAckSaved =>
      'I have securely backed up my recovery phrase';

  @override
  String get mnemonicExportAckUnderstandLoss =>
      'I understand that losing my recovery phrase means I cannot recover this note account';

  @override
  String get mnemonicExportAckNoShare =>
      'I will not share my recovery phrase with anyone';

  @override
  String get mnemonicExportSafetyTipsTitle => 'Safety tips';

  @override
  String get mnemonicExportSafetyTipPaper =>
      'Write your recovery phrase on paper and store it in a safe place';

  @override
  String get mnemonicExportSafetyTipNoScreenshot =>
      'Do not screenshot or store it on internet-connected devices';

  @override
  String get mnemonicExportSafetyTipCheckBackup =>
      'Check your backup periodically to make sure it is intact';

  @override
  String get mnemonicExportFinishCta => 'I have backed up securely';

  @override
  String get aboutPageReleaseDate => 'Release date';

  @override
  String get aboutPageBuildNumber => 'Build number';

  @override
  String get aboutPageCoreFeatures => 'Core features';

  @override
  String get aboutFeatureOnChainTitle => 'On-chain storage';

  @override
  String get aboutFeatureOnChainDesc =>
      'SHA-256 hashes on-chain, permanently immutable.';

  @override
  String get aboutFeatureSecureTitle => 'Data security';

  @override
  String get aboutFeatureSecureDesc =>
      'End-to-end encryption; you control your keys.';

  @override
  String get aboutFeatureSyncTitle => 'Instant sync';

  @override
  String get aboutFeatureSyncDesc =>
      'Real-time sync across devices, access anywhere.';

  @override
  String get aboutFeatureControlTitle => 'Full control';

  @override
  String get aboutFeatureControlDesc =>
      'Decentralized architecture; your data stays yours.';

  @override
  String get aboutPageTechStack => 'Tech stack';

  @override
  String get aboutPageContactUs => 'Contact us';

  @override
  String get aboutPageOfficialWebsite => 'Official website';

  @override
  String get aboutPageContactEmail => 'Contact email';

  @override
  String get aboutPageOpenSource => 'Open source';

  @override
  String get aboutPageCreditsMadeWith => 'Made with ';

  @override
  String aboutPageCopyrightNotice(String yearBrand) {
    return '© $yearBrand. All rights reserved.';
  }

  @override
  String get walletManagement => 'Note account Management';

  @override
  String get walletCannotDeleteSwitchFirst =>
      'Cannot delete the note account in use. Switch to another note account first.';

  @override
  String get walletViewMnemonicCompleteBackupFirst =>
      'Complete the recovery phrase backup flow before viewing your recovery phrase or security key.';

  @override
  String get walletDemoPrimaryName => 'My primary note account';

  @override
  String get walletAddressListTitle => 'Note account addresses';

  @override
  String get copyAddressButton => 'Copy address';

  @override
  String get labelCopied => 'Copied';

  @override
  String get walletManagementDeleteIrreversible =>
      'This cannot be undone. Make sure you have backed up your recovery phrase or security key.';

  @override
  String get walletManagementDeleteWarningTitle =>
      'Warning: cannot be recovered after deletion';

  @override
  String get walletManagementDeleteAssetsLoss =>
      'If you have not saved your recovery phrase or security key, you may permanently lose access to your notes.';

  @override
  String get walletCreateSystemDescription =>
      'A new note account address and recovery phrase will be generated for you.';

  @override
  String get walletCreateBackupReminderBody =>
      'Back up your recovery phrase immediately after creation. It is the only way to recover your note account.';

  @override
  String get walletCreateGenerateSubtitle => 'Generate a new note account';

  @override
  String get walletAddressCopied => 'Address copied';

  @override
  String get walletNameRequired => 'Note account name is required';

  @override
  String get walletNameUpdated => 'Note account name updated';

  @override
  String get walletKeepAtLeastOne => 'At least one note account must be kept';

  @override
  String get walletCannotDeleteCurrent =>
      'Cannot delete the note account in use';

  @override
  String get walletDeleted => 'Note account deleted';

  @override
  String get walletCreated => 'Note account created';

  @override
  String get walletImportMnemonicOrKeyRequired =>
      'Please enter recovery phrase or security key';

  @override
  String get walletImportSuccess => 'Note account restored successfully';

  @override
  String get walletImportedCannotViewMnemonic =>
      'Restored note account cannot view recovery phrase';

  @override
  String get walletMarkedBackedUp => 'Marked as backed up';

  @override
  String get walletSwitched => 'Note account switched';

  @override
  String get viewMnemonic => 'View Recovery phrase';

  @override
  String get viewPrivateKey => 'View security key';

  @override
  String get privateKeyExportSelectNetworkHint => 'Select a network to view';

  @override
  String get privateKeyExportKeepKeySafeHint => 'Keep your security key secure';

  @override
  String get privateKeyExportSecurityWarningTitle => 'Security warning';

  @override
  String get privateKeyExportWarnBullet1 =>
      'Your security key is the highest-level credential for managing your notes';

  @override
  String get privateKeyExportWarnBullet2 =>
      'Anyone who obtains your security key can fully manage your notes';

  @override
  String get privateKeyExportWarnBullet3 =>
      'Ensure your surroundings are safe and no one is watching';

  @override
  String get privateKeyExportWarnBullet4 =>
      'Never screenshot, photograph, or transmit your security key over a network';

  @override
  String get privateKeyExportSupportedNetworksTitle => 'Supported networks';

  @override
  String privateKeyExportNetworkCount(int count) {
    return '$count networks';
  }

  @override
  String get privateKeyExportViewSafetyTitle => 'Security key safety tips';

  @override
  String get privateKeyExportViewBullet1 =>
      'Ensure your surroundings are safe and no one can see your screen';

  @override
  String get privateKeyExportViewBullet2 =>
      'Do not view in public places or on untrusted networks';

  @override
  String get privateKeyExportViewBullet3 =>
      'Close this page as soon as you are done viewing';

  @override
  String get privateKeyExportKeySectionTitle => 'Security key';

  @override
  String get privateKeyExportBip44Hint =>
      'The security key derived via the BIP44 Ethereum path is the same across EVM mainnets; only the network name differs.';

  @override
  String get privateKeyExportMaskedPlaceholder =>
      '0x•••••••••••••••••••••••••••••••••';

  @override
  String get privateKeyExportDoNotShareInline =>
      'Never tell anyone your security key or send it over a network';

  @override
  String privateKeyExportNetworkAddressLabel(String networkName) {
    return '$networkName network address';
  }

  @override
  String get privateKeyExportImportantReminderTitle => 'Important';

  @override
  String get privateKeyExportReminderBullet1 =>
      'Having the security key means you can fully manage notes for this address';

  @override
  String get privateKeyExportReminderBullet2 =>
      'A leaked security key can cause permanent loss of notes with no recovery';

  @override
  String get privateKeyExportReminderBullet3 =>
      'Our team will never ask you for your security key';

  @override
  String get privateKeyExportReminderBullet4 =>
      'We recommend backing up with a recovery phrase rather than exporting the security key';

  @override
  String get privateKeyExportBackToList => 'Back to list';

  @override
  String get privateKeyExportCopySecurityKey => 'Copy security key';

  @override
  String get mnemonicManagePageTitle => 'Recovery phrase';

  @override
  String get mnemonicManagePageSubtitle =>
      'Keep your recovery phrase safe — never share it';

  @override
  String get mnemonicBackupFlowTitle => 'Back up recovery phrase';

  @override
  String mnemonicBackupFlowStepProgress(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get mnemonicBackupFlowLoadFailed => 'Load failed';

  @override
  String get mnemonicBackupFlowCTAUnderstoodStart =>
      'I understand, start backup';

  @override
  String get mnemonicBackupFlowCTACopiedContinue =>
      'I\'ve written them down, continue';

  @override
  String get mnemonicBackupFlowCTAVerifiedContinue => 'Verified, continue';

  @override
  String get mnemonicBackupFlowCTAPleaseVerify => 'Complete verification first';

  @override
  String get mnemonicBackupFlowCTAFinish => 'Finish backup';

  @override
  String get mnemonicBackupFlowCTANext => 'Next';

  @override
  String get mnemonicBackupFlowFooterCopyHint =>
      'Make sure you have correctly written down every word before continuing';

  @override
  String get mnemonicBackupFlowStep1Heading => 'Before you start';

  @override
  String get mnemonicBackupFlowStep1Subheading =>
      'Please read the following security tips carefully';

  @override
  String get mnemonicBackupFlowSecurityTipsTitle => 'Important security tips';

  @override
  String get mnemonicBackupFlowSecurityTip1 =>
      'Your recovery phrase is the only way to recover this note account';

  @override
  String get mnemonicBackupFlowSecurityTip2 =>
      'Anyone with your recovery phrase can manage your notes';

  @override
  String get mnemonicBackupFlowSecurityTip3 =>
      'If you lose your recovery phrase, your note account cannot be recovered';

  @override
  String get mnemonicBackupFlowBackupAdviceTitle => 'How to back up safely';

  @override
  String get mnemonicBackupFlowBackupAdvice1 =>
      'Write the recovery phrase on paper and store it somewhere safe';

  @override
  String get mnemonicBackupFlowBackupAdvice2 =>
      'Do not screenshot or store it on internet-connected devices';

  @override
  String get mnemonicBackupFlowBackupAdvice3 =>
      'Never send it over the network or share it with anyone';

  @override
  String get mnemonicBackupFlowBackupAdvice4 =>
      'Consider multiple copies in separate secure places';

  @override
  String get mnemonicBackupFlowProcessTitle => 'Backup steps';

  @override
  String get mnemonicBackupFlowProcess1 =>
      'View and write down your recovery phrase';

  @override
  String get mnemonicBackupFlowProcess2 =>
      'Confirm your backup with verification';

  @override
  String get mnemonicBackupFlowProcess3 =>
      'Finish backup to protect your notes';

  @override
  String get mnemonicBackupFlowYourMnemonicTitle => 'Your recovery phrase';

  @override
  String get mnemonicBackupFlowYourMnemonicSubtitle =>
      'Write down every word in order and keep it safe';

  @override
  String mnemonicBackupFlowWordCount(int count) {
    return '$count words';
  }

  @override
  String get mnemonicBackupFlowPleaseNoteTitle => 'Please note';

  @override
  String get mnemonicBackupFlowStep2NoteBody =>
      'We recommend writing your recovery phrase on paper instead of screenshots or copying to connected devices. Tap the eye icon to show or hide the words.';

  @override
  String get mnemonicBackupFlowVerifyTitle => 'Verify recovery phrase';

  @override
  String get mnemonicBackupFlowVerifySubtitle =>
      'Select the correct words to confirm you backed them up correctly';

  @override
  String mnemonicBackupFlowVerifyWordQuestion(int position) {
    return 'Which word is in position $position?';
  }

  @override
  String get mnemonicBackupFlowVerifySuccessTitle => 'Verified!';

  @override
  String get mnemonicBackupFlowVerifySuccessBody =>
      'You have backed up your recovery phrase correctly';

  @override
  String get mnemonicBackupFlowDoneTitle => 'Backup complete!';

  @override
  String get mnemonicBackupFlowDoneSubtitle =>
      'Your recovery phrase is backed up safely';

  @override
  String get mnemonicBackupFlowDoneSectionTitle => 'Done';

  @override
  String get mnemonicBackupFlowDoneCheck1 =>
      'Viewed and wrote down the recovery phrase';

  @override
  String get mnemonicBackupFlowDoneCheck2 => 'Passed the verification';

  @override
  String get mnemonicBackupFlowDoneCheck3 => 'Recovery phrase stored securely';

  @override
  String get mnemonicBackupFlowDoneSecurityTitle => 'Security reminder';

  @override
  String get mnemonicBackupFlowDoneSecurity1 =>
      'Keep the recovery phrase in a safe physical place';

  @override
  String get mnemonicBackupFlowDoneSecurity2 =>
      'Never reveal your recovery phrase to anyone';

  @override
  String get mnemonicBackupFlowDoneSecurity3 =>
      'Official staff will never ask for your recovery phrase';

  @override
  String get mnemonicBackupFlowDoneSecurity4 =>
      'Check periodically that your backup is intact and readable';

  @override
  String get mnemonicBackupFlowFinalEncouragementTitle =>
      'You\'re ready to use your note account!';

  @override
  String get mnemonicBackupFlowFinalEncouragementBody =>
      'Your notes are protected by your recovery phrase';

  @override
  String get switchWallet => 'Switch';

  @override
  String get viewAddresses => 'View Addresses';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get createWallet => 'Create Note account';

  @override
  String get importWallet => 'Restore Note account';

  @override
  String get mnemonicOrPrivateKey => 'Recovery phrase or security key';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get mnemonicCopied => 'Recovery phrase copied';

  @override
  String get privateKeyCopied => 'Security key copied';

  @override
  String get backedUp => 'Backed Up';

  @override
  String get editWalletName => 'Edit Note account Name';

  @override
  String get deleteWallet => 'Delete Note account';

  @override
  String get confirmDeleteWallet => 'Confirm Delete Note account';

  @override
  String get newWalletCreated => 'New note account created';

  @override
  String get cannotDeleteCurrentWallet =>
      'Cannot delete the note account in use';

  @override
  String get edit => 'Edit';

  @override
  String get createNewWallet => 'Create New Note account';

  @override
  String get editWalletNameTitle => 'Edit Note account Name';

  @override
  String get noteNotFoundBack => 'Note not found, go back';

  @override
  String get createNoteNotImplemented => 'Create note (not implemented)';

  @override
  String get newWalletCreateSuccess => 'New note account created successfully!';

  @override
  String restoringFromProvider(String provider) {
    return 'Restoring from $provider...';
  }

  @override
  String restoredFromProvider(String provider) {
    return 'Restored from $provider!';
  }

  @override
  String noBackupFoundProvider(String provider) {
    return 'No $provider backup found, try another way';
  }

  @override
  String get walletAddressCopiedShort => 'Address copied';

  @override
  String switchedToChain(String chain) {
    return 'Switched to $chain';
  }

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get passwordMismatch => 'The two new passwords do not match';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordChangeSuccess => 'Password changed successfully';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get verificationCodeSent => 'Verification code sent';

  @override
  String get enterSixDigitCode => 'Please enter the 6-digit code';

  @override
  String get emailBindSuccess => 'Email bound successfully';

  @override
  String get emailUnbound => 'Email unbound';

  @override
  String get logoutNotConnected => 'Logout (not connected)';

  @override
  String get changePassword => 'Change Password';

  @override
  String get confirm => 'Confirm';

  @override
  String get bindEmail => 'Bind Email';

  @override
  String get editNoteOpenByRoute => 'Please open edit page via route';

  @override
  String get imageUploadNotConnected => 'Image upload not connected to storage';

  @override
  String get imageRemoved => 'Image removed';

  @override
  String get titleContentRequired => 'Title and content are required';

  @override
  String get submittedToChain => 'Submitted to chain';

  @override
  String get onChainNoteCannotChangeType => 'On-chain notes cannot change type';

  @override
  String get setToLocalNote => 'Set as local note (will not be on chain)';

  @override
  String get setToDraft => 'Set as draft';

  @override
  String get editNote => 'Edit Note';

  @override
  String get noteDetailEditDisabledOnChain => 'On-chain notes cannot be edited';

  @override
  String get noteTypeDraft => 'Draft';

  @override
  String get noteTypeLocal => 'Local';

  @override
  String get noteTypeOnChain => 'On Chain';

  @override
  String get blockchainVerify => 'Verify on Blockchain';

  @override
  String get blockchainVerifyTitle => 'Blockchain Verification';

  @override
  String getGas(String symbol) {
    return 'Get $symbol Gas';
  }

  @override
  String get addressCopied => 'Address copied';

  @override
  String get redirectingToFaucet => 'Redirecting to faucet...';

  @override
  String get noFaucetForNetwork => 'No faucet for this network';

  @override
  String get loginNotImplemented => 'Login not implemented';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordNotImplemented => 'Forgot password not implemented';

  @override
  String get noAccountYet => 'No note account yet?';

  @override
  String get registerNotImplemented => 'Register not implemented';

  @override
  String get registerNow => 'Register now';

  @override
  String get mnemonicVerifySuccess =>
      'Recovery phrase verified, import logic handled externally';

  @override
  String get privateKeyVerifySuccess =>
      'Security key verified, import logic handled externally';

  @override
  String get importSuccess => 'Restore successful!';

  @override
  String get cleared => 'Cleared';

  @override
  String get back => 'Back';

  @override
  String get current => 'Current';

  @override
  String get imported => 'Restored';

  @override
  String get defaultBadge => 'Default';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchNotesHint => 'Search notes...';

  @override
  String get noMatchNotes => 'No matching notes';

  @override
  String get noOnChainNotes => 'No on-chain notes yet';

  @override
  String get noOffChainNotes => 'No off-chain notes yet';

  @override
  String get noNotes => 'No notes yet';

  @override
  String get tryOtherSearch => 'Try other keywords';

  @override
  String get startCreateFirstNote => 'Create your first note';

  @override
  String get profileNotConnected => 'Not connected';

  @override
  String get profileSectionAccount => 'Note account';

  @override
  String get profileNetworkSettingsSubtitle => 'Configure RPC & nodes';

  @override
  String get profileSectionSecurity => 'Security';

  @override
  String get profileChangePasswordSubtitle => 'Protect your note account';

  @override
  String get profileBindEmailNotBound => 'Not bound';

  @override
  String get profileBindEmailBadgeBound => 'Bound';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileSectionMore => 'More';

  @override
  String get profileTestPage => 'Test page';

  @override
  String get profileTestPageSubtitle => 'Feature test entry';

  @override
  String get profileTerms => 'Terms of Service';

  @override
  String get profilePrivacy => 'Privacy Policy';

  @override
  String get profileRateUs => 'Rate us';

  @override
  String get profileShare => 'Share with friends';

  @override
  String profileShareMessage(String url) {
    return 'I\'m using On Chain Notes — an on-chain notes app I like. Check it out:\n$url';
  }

  @override
  String get profileLogoutLabel => 'Logout';

  @override
  String get profileLogoutPending => 'Logout (coming soon)';

  @override
  String profilePageFooter(String appTitle, String version, String year) {
    return '$appTitle v$version\n© $year All rights reserved.';
  }

  @override
  String get profileAvatarFallback => 'ME';

  @override
  String get profileDefaultWalletName => 'My note account';

  @override
  String get profileUserActive => 'Active user';

  @override
  String get profileUserNormal => 'Standard user';

  @override
  String get profileStatNotes => 'Notes';

  @override
  String get profileStatOnChain => 'On-chain';

  @override
  String get profileStatDays => 'Days';

  @override
  String get profileBindEmailDialogSubtitle =>
      'Enter your email and verification code.';

  @override
  String get profileBindEmailFieldEmail => 'Email address';

  @override
  String get profileBindEmailFieldCode => 'Verification code';

  @override
  String get profileSendVerificationCode => 'Send code';

  @override
  String profileResendCodeInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get profileUnbindEmail => 'Unbind email';

  @override
  String get languageSelectTitle => 'Language';

  @override
  String get languageSelectSubtitle => 'Select your preferred language';

  @override
  String get languageNoticeHint => 'Note';

  @override
  String get languageNoticeBody =>
      'Simplified Chinese, Traditional Chinese, English, Japanese, and Korean are supported; more languages coming soon.';

  @override
  String get languageCurrentBadge => 'Current';

  @override
  String get languageSnackbarComingSoon => 'Coming soon';

  @override
  String languageSwitchedTo(String name) {
    return 'Switched to $name';
  }

  @override
  String get languageFooterMore => 'More languages coming soon';

  @override
  String get changePasswordSameAsOld =>
      'New password cannot be the same as the old password';

  @override
  String get changePasswordLength632 => 'New password must be 6–32 characters';

  @override
  String get walletNoSavedKey =>
      'No saved key found. Create an note account first.';

  @override
  String get changePasswordWrongOrFailed =>
      'Wrong old password or operation failed';

  @override
  String get passwordMaxLength32 => 'Password must be at most 32 characters';

  @override
  String get passwordMeetAllRequirements =>
      'Please meet all password requirements';

  @override
  String encryptionInitFailed(String error) {
    return 'Encryption init failed: $error';
  }

  @override
  String get passwordVerifyForgotGoReset => 'Forgot password? Reset';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get changePasswordPageTitle => 'Change password';

  @override
  String get changePasswordPageSubtitle => 'Protect your note account';

  @override
  String get changePasswordSecurityHintTitle => 'Security tips';

  @override
  String get changePasswordSecurityHintBody =>
      '• Change your password regularly\n• Use a strong password with letters and numbers\n• Avoid birthdays or phone numbers';

  @override
  String get changePasswordOldLabel => 'Current password';

  @override
  String get changePasswordOldHint => 'Enter current password';

  @override
  String get changePasswordNewLabel => 'New password';

  @override
  String get changePasswordNewHint => 'Enter new password';

  @override
  String get changePasswordStrengthLabel => 'Password strength:';

  @override
  String get changePasswordMatchOk => 'Passwords match';

  @override
  String get changePasswordMatchBad => 'Passwords do not match';

  @override
  String get changePasswordConfirmLabel => 'Confirm new password';

  @override
  String get changePasswordConfirmHint => 'Enter new password again';

  @override
  String get changePasswordRuleLength => '6–32 characters';

  @override
  String get changePasswordRuleCase => 'Upper & lower case letters';

  @override
  String get changePasswordRuleDigit => 'Include a number';

  @override
  String get changePasswordClear => 'Clear';

  @override
  String get changePasswordSubmit => 'Confirm change';

  @override
  String get validatorOldPasswordRequired => 'Enter current password';

  @override
  String get validatorNewPasswordRequired => 'Enter new password';

  @override
  String get validatorNewPasswordMin6 => 'At least 6 characters';

  @override
  String get validatorNewPasswordMax32 => 'At most 32 characters';

  @override
  String get validatorConfirmRequired => 'Confirm new password';

  @override
  String get validatorConfirmMismatch => 'Passwords do not match';

  @override
  String get changePasswordRulesTitle => 'Password requirements';

  @override
  String get loginWelcomeTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to your note account';

  @override
  String get loginEmailOrUsernameLabel => 'Email or username';

  @override
  String get loginEmailOrUsernameHint => 'Enter email or username';

  @override
  String get validatorLoginIdRequired => 'Enter email or username';

  @override
  String get loginPasswordFieldLabel => 'Password';

  @override
  String get loginPasswordFieldHint => 'Enter your password';

  @override
  String get validatorLoginPasswordRequired => 'Enter password';

  @override
  String get validatorLoginPasswordMin6 =>
      'Password must be at least 6 characters';

  @override
  String get loginButton => 'Sign in';

  @override
  String get createWalletPasswordPageTitle => 'Set note account password';

  @override
  String get createWalletPasswordSubtitle => 'Protect your notes';

  @override
  String get createWalletPasswordWhyTitle => 'Why a password?';

  @override
  String get createWalletPasswordWhyBody =>
      'Your note account password encrypts security keys and recovery phrases so only you can access your notes. Remember it — it cannot be recovered if lost.';

  @override
  String get walletPasswordFieldLabel => 'Note account password';

  @override
  String get walletPasswordFieldHint => 'Enter 6–32 characters';

  @override
  String get walletConfirmPasswordFieldLabel => 'Confirm password';

  @override
  String get walletConfirmPasswordFieldHint => 'Enter password again';

  @override
  String get walletPasswordImportantNotice => 'Important';

  @override
  String get walletPasswordWarnBullets =>
      '• The password protects your note account\n• Use something memorable but hard to guess\n• Mix letters, numbers, and symbols\n• If lost, it cannot be recovered — remember it';

  @override
  String get createWalletPasswordSubmitCreate =>
      'Confirm and create note account';

  @override
  String get createWalletPasswordSubmitReset => 'Confirm and reset password';

  @override
  String get createWalletPasswordFooterAck =>
      'By confirming you understand how important your password is';

  @override
  String get walletPasswordRulesHeader => 'Requirements:';

  @override
  String get walletPasswordRuleLength632 => '6–32 characters';

  @override
  String get walletPasswordRuleLetter => 'Contains letters';

  @override
  String get walletPasswordRuleNumberRecommended =>
      'Contains numbers (recommended)';

  @override
  String get walletPasswordRuleMatch => 'Passwords match';

  @override
  String get walletBootstrapImporting => 'Restoring note account...';

  @override
  String get walletBootstrapInitializing => 'Initializing note account...';

  @override
  String get passwordVerifyTitle => 'Verify password';

  @override
  String get passwordVerifyDescription =>
      'For your security, enter your note account password to continue.';

  @override
  String get passwordVerifyDescExportMnemonic =>
      'Enter your note account password before viewing and exporting the recovery phrase.';

  @override
  String get passwordVerifyDescExportPrivateKey =>
      'Enter your note account password before viewing your security key.';

  @override
  String get passwordVerifyDescImportWallet =>
      'Enter your note account password before restoring the note account.';

  @override
  String get passwordVerifyDescBackupMnemonic =>
      'Enter your note account password before backing up the recovery phrase.';

  @override
  String get passwordVerifyDescCreateWallet =>
      'Enter your note account password before creating an note account.';

  @override
  String get passwordVerifyDescDeleteWallet =>
      'Enter your note account password before deleting the note account.';

  @override
  String get passwordVerifyDescMintNft =>
      'Enter your note account password to mint an NFT.';

  @override
  String get passwordVerifyWalletPasswordLabel => 'Note account password';

  @override
  String get passwordVerifyWalletPasswordHint => 'Enter note account password';

  @override
  String get validatorWalletPasswordRequired => 'Enter password';

  @override
  String get passwordVerifyNoEncryptedData =>
      'No encrypted data found. Set your password again.';

  @override
  String passwordVerifyFailedWithError(String error) {
    return 'Verification failed: $error';
  }

  @override
  String passwordVerifyLockoutMinutes(int minutes) {
    return 'Too many attempts. Try again in $minutes minutes.';
  }

  @override
  String passwordVerifyLockoutHours(int hours) {
    return 'Too many attempts. Try again in $hours hours.';
  }

  @override
  String passwordVerifyWrongWithCount(int current, int max) {
    return 'Wrong password ($current/$max)';
  }

  @override
  String passwordVerifyAttemptsBanner(int count, int remaining) {
    return 'Wrong $count time(s). $remaining attempt(s) left.';
  }

  @override
  String passwordVerifyLockBanner(String time) {
    return 'Too many attempts. Try again after $time.';
  }

  @override
  String passwordVerifyDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes m';
  }

  @override
  String passwordVerifyDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get passwordVerifySecurityTipsTitle => 'Security tips';

  @override
  String passwordVerifySecurityTipsBody(int maxAttempts) {
    return '• Password length 6–32\n• Ensure your surroundings are safe\n• $maxAttempts wrong attempts will temporarily lock';
  }

  @override
  String get paste => 'Paste';

  @override
  String get loadingDefault => 'Loading…';

  @override
  String get walletLoadingTagline => 'BlockNote · Secure · Trusted · Permanent';

  @override
  String get walletLoadingStepConnecting => 'Connecting to the network…';

  @override
  String get walletLoadingStepVerifying => 'Verifying note account…';

  @override
  String get walletLoadingStepSyncing => 'Syncing your notes…';

  @override
  String get walletLoadingStepComplete => 'Almost done…';

  @override
  String get retry => 'Retry';

  @override
  String loadFailedWithError(String error) {
    return 'Load failed: $error';
  }

  @override
  String get selectEvmChainFirst =>
      'Please select an EVM-supported network first';

  @override
  String get noteNotFoundShort => 'Note not found';

  @override
  String get createOrSelectWalletFirst =>
      'Please create or select an note account first';

  @override
  String get privateKeyDecryptFailedHint =>
      'Could not get security key. Check your password. If you changed it, re-enter your recovery phrase.';

  @override
  String get uploadingIpfsAndMinting => 'Uploading to IPFS and minting…';

  @override
  String ipfsFileUploadFailed(String details) {
    return 'IPFS file upload failed: $details';
  }

  @override
  String onChainSuccessTx(String txHash) {
    return 'On-chain success: $txHash';
  }

  @override
  String get draftSavedIpfsRetry =>
      'Saved as draft with IPFS images. You can retry publishing anytime.';

  @override
  String mintFailedGasDebug(String detail) {
    return 'Insufficient balance (gas)\n$detail';
  }

  @override
  String get mintFailedGasUser =>
      'Insufficient balance for gas. Add funds and try again.';

  @override
  String mintFailedGeneric(String error) {
    return 'Publish failed: $error';
  }

  @override
  String get walletErrNoWalletYet => 'Create or restore an note account first';

  @override
  String get walletErrUnrecognizedAccount =>
      'Cannot recognize the current note account';

  @override
  String get walletErrWalletDataNotFound => 'Note account data not found';

  @override
  String get walletErrImportedMnemonicNoExport =>
      'Recovery phrase-imported note accounts cannot export the recovery phrase here again';

  @override
  String get walletErrImportedMnemonicNoBackup =>
      'Recovery phrase-imported note accounts do not need backup here';

  @override
  String get walletErrPrivateKeyWalletNoMnemonic =>
      'Security key–imported note accounts have no recovery phrase';

  @override
  String get walletErrNoEncryptedMnemonic =>
      'No locally encrypted recovery phrase for this note account';

  @override
  String get walletErrDecryptFailed => 'Decryption failed. Check your password';

  @override
  String get walletErrMissingAddress => 'Missing note account address';

  @override
  String get walletErrGetPrivateKeyFailed =>
      'Could not get security key. Check your password';

  @override
  String get exportMnemonicDocTitle =>
      'On Chain Notes — Recovery phrase backup';

  @override
  String exportMnemonicDocTime(String time) {
    return 'Generated: $time';
  }

  @override
  String get exportMnemonicDocLabel => 'Recovery phrase (keep safe):';

  @override
  String get exportMnemonicDocSecurity =>
      '⚠️ Security tips:\n1. Store this recovery phrase in a safe place\n2. Never share it with anyone\n3. If lost, your note account cannot be recovered';

  @override
  String get exportMnemonicUseCopyOnPlatform =>
      'Please use Copy on this platform';

  @override
  String exportMnemonicSavedTo(String path) {
    return 'Saved: $path';
  }

  @override
  String get walletBootstrapCreating => 'Creating note account…';

  @override
  String get chainNameEvm => 'EVM (Ethereum / BSC / Polygon, etc.)';

  @override
  String get chainPkDescEvm =>
      '64 hexadecimal characters with 0x prefix, 66 characters total';

  @override
  String get chainNameBitcoin => 'Bitcoin';

  @override
  String get chainPkDescBitcoin =>
      'WIF format, starts with 5, K, or L, 51–52 characters';

  @override
  String get chainNameSolana => 'Solana';

  @override
  String get chainPkDescSolana =>
      'Base58, about 87–88 characters, no 0, O, I, or l';

  @override
  String get chainNameTron => 'Tron';

  @override
  String get chainPkDescTronHex => '64 hexadecimal characters (no 0x prefix)';

  @override
  String get chainNameCosmos => 'Cosmos';

  @override
  String get chainPkDescCosmosHex => '64 hexadecimal characters (no 0x prefix)';

  @override
  String walletPkSubtitleLength(int count) {
    return '$count characters';
  }

  @override
  String walletPkSubtitleStartsWith(String prefix) {
    return 'Starts with $prefix';
  }

  @override
  String get walletImportSelectChainTitle => 'Select blockchain type';

  @override
  String get walletImportEvmOnlyNotice =>
      'Not supported yet. Use EVM security key import.';

  @override
  String get walletImportPageSubtitle =>
      'Restore your note account with a recovery phrase or security key';

  @override
  String get walletImportTabMnemonic => 'Recovery phrase';

  @override
  String get walletImportTabPrivateKey => 'Security key';

  @override
  String get walletImportInputMethod => 'Input method';

  @override
  String get walletImportInputSingle => 'Word by word';

  @override
  String get walletImportInputPasteFull => 'Paste full phrase';

  @override
  String get walletImportWordCountLabel => 'Recovery phrase length';

  @override
  String walletImportWordCountN(int n) {
    return '$n words';
  }

  @override
  String get walletImportWordCountDialogTitle => 'Select mnemonic length';

  @override
  String get walletImportWordCountDialogDesc =>
      'BIP39 supports several mnemonic lengths; security increases with more words.';

  @override
  String walletImportWordCountOptionLabel(int count) {
    return '$count words';
  }

  @override
  String get walletImportWordCountSecurityLabel => 'Security: ';

  @override
  String get walletImportWordCountSecurityStandard => 'Standard';

  @override
  String get walletImportWordCountSecurityEnhanced => 'Enhanced';

  @override
  String get walletImportWordCountSecurityAdvanced => 'Advanced';

  @override
  String get walletImportWordCountSecurityProfessional => 'Professional';

  @override
  String get walletImportWordCountSecurityMaximum => 'Maximum';

  @override
  String walletImportWordCountSwitched(int n) {
    return 'Switched to $n words';
  }

  @override
  String get walletImportWordCountDialogTip =>
      'Most wallets use 12 words. If you are unsure, choose 12 words.';

  @override
  String get walletImportEnterMnemonic => 'Enter recovery phrase';

  @override
  String get walletImportMnemonicPasteTip =>
      'Tip: you can paste the full phrase; use “Paste full phrase” above';

  @override
  String get walletImportPasteMnemonicPrompt => 'Paste your recovery phrase';

  @override
  String walletImportMnemonicHintWords(int count) {
    return 'Paste your $count words separated by spaces';
  }

  @override
  String get walletImportMnemonicWordFieldHint => 'word';

  @override
  String get walletImportMnemonicParagraphExampleHint =>
      'word1 word2 word3 ...';

  @override
  String get walletImportPrivateKeyFieldHint => '0x... or 64 hex characters';

  @override
  String get walletImportPrivateKeyFieldHintShort => '0x...';

  @override
  String walletImportWordProgress(int current, int total) {
    return 'Current words: $current / $total';
  }

  @override
  String get walletImportMnemonicSecurityTitle => 'Security tips';

  @override
  String get walletImportMnemonicSecurityBody =>
      '• Use a secure network\n• If the recovery phrase is lost, it cannot be recovered\n• Never share your recovery phrase\n• We do not store your recovery phrase on servers';

  @override
  String get walletImportSelectChainSection => 'Select blockchain type';

  @override
  String get walletImportTapSwitchChain => 'Tap to switch chain type';

  @override
  String get walletImportEnterPrivateKey => 'Enter security key';

  @override
  String get walletImportPkFormatExample => 'Security key format example';

  @override
  String get walletImportPkSevereTitle => 'Critical warning';

  @override
  String get walletImportPkSevereBody =>
      '• The security key grants full control of your note account\n• Anyone with it can fully manage your notes\n• Do not enter it on unsafe devices\n• Do not screenshot or send via chat apps';

  @override
  String get walletImportConfirm => 'Confirm restore';

  @override
  String walletImportMnemonicNeedCount(int count) {
    return 'Enter all $count recovery phrase words';
  }

  @override
  String walletImportMnemonicWrongCount(int count, int current) {
    return 'Enter $count words (currently $current)';
  }

  @override
  String get walletImportMnemonicInvalidWords =>
      'Invalid recovery phrase words; use lowercase English words';

  @override
  String get walletImportPkEmpty => 'Enter security key';

  @override
  String get walletImportPkNeed0x => 'Security key should start with 0x';

  @override
  String get walletImportPkNeedWif =>
      'Security key should start with 5, K, or L';

  @override
  String get walletImportPkWifLength =>
      'Security key length should be 51–52 characters';

  @override
  String walletImportPkLengthExpected(int length) {
    return 'Security key length should be $length characters';
  }

  @override
  String get walletImportPkInvalidFormat => 'Invalid security key format';

  @override
  String get walletImportEvmOnly => 'Only EVM security key import is supported';

  @override
  String get walletImportDeriveAddressFailed =>
      'Could not derive address from security key; check format';

  @override
  String get walletImportDuplicatePk =>
      'This address already exists. Do not restore again';

  @override
  String get walletImportDuplicateMnemonic =>
      'This note account is already restored. Do not restore again';

  @override
  String get walletImportInvalidPrivateKeyRetry =>
      'Invalid security key. Check and try again';

  @override
  String get walletImportInvalidMnemonicRetry =>
      'Invalid recovery phrase. Check and try again';

  @override
  String get clipboardEmpty => 'Clipboard is empty';

  @override
  String get mnemonicViewLengthTitle => 'Recovery phrase length';

  @override
  String get mnemonicViewInputMode => 'Input mode';

  @override
  String get mnemonicViewSingleWord => 'Word by word';

  @override
  String get mnemonicViewFullPaste => 'Paste paragraph';

  @override
  String get mnemonicViewImportCta => 'Use recovery phrase';

  @override
  String mnemonicViewEnterOrdered(int count) {
    return 'Enter $count words in order';
  }

  @override
  String get mnemonicViewPasteHint =>
      'Paste the full recovery phrase, words separated by spaces';

  @override
  String mnemonicCountMismatch(int expected, int current) {
    return 'Enter $expected words (currently $current)';
  }

  @override
  String get mnemonicInvalidBip39 => 'Invalid recovery phrase; check spelling';

  @override
  String get walletSelectorTitle => 'My note accounts';

  @override
  String get walletSelectorSubtitle => 'Manage all your note accounts';

  @override
  String walletNumberedName(int n) {
    return 'Note account $n';
  }

  @override
  String get walletDefaultCreatedNameFirst => 'My Note account';

  @override
  String walletDefaultCreatedNameNumbered(int n) {
    return 'My Note account $n';
  }

  @override
  String get walletDefaultPrivateKeyNameFirst => 'My security key note account';

  @override
  String walletDefaultPrivateKeyNameNumbered(int n) {
    return 'My security key note account $n';
  }

  @override
  String get walletBackupNotYet => 'Not backed up';

  @override
  String get walletBackupPromptLine1 => 'Back up your note account';

  @override
  String get walletBackupPromptLine2 =>
      'Tap to back up your recovery phrase now';

  @override
  String get walletDeleteConfirmTitle => 'Delete note account?';

  @override
  String get walletDeleteConfirmLine1 =>
      'This cannot be undone. Make sure you have backed up your recovery phrase.';

  @override
  String get walletDeleteConfirmLine2Notes =>
      'Local notes linked to this note account will also be removed.';

  @override
  String get walletDeleteCannotCurrent =>
      'Cannot delete the note account in use';

  @override
  String get walletDeleteLastHint =>
      'No note account will remain; you will return to onboarding to create or restore.';

  @override
  String get walletEditNameSubtitle => 'Choose an easy-to-recognize name';

  @override
  String get walletNameFieldLabel => 'Note account name';

  @override
  String get walletNameFieldHint => 'Enter note account name';

  @override
  String get networkNodeAdd => 'Add node';

  @override
  String get networkNodeTest => 'Test';

  @override
  String get networkNodeSetDefault => 'Set as default';

  @override
  String get networkNodeOnline => 'Online';

  @override
  String get networkNodeOffline => 'Offline';

  @override
  String get networkNodeConnectionFailed => 'Node connection failed';

  @override
  String get networkRpcUrlInvalid => 'Enter a valid HTTP or HTTPS RPC URL.';

  @override
  String get networkNodeDuplicate => 'This RPC URL is already in the list.';

  @override
  String get networkNodeNameRpcRequired => 'Enter node name and RPC URL';

  @override
  String get networkNodeAdded => 'Node added';

  @override
  String get networkRpcCopied => 'RPC URL copied';

  @override
  String get networkNodeSwitched => 'Switched to this node';

  @override
  String get networkNodeDeleted => 'Node deleted';

  @override
  String get networkSettingsTitle => 'Network settings';

  @override
  String get networkSettingsSubtitle => 'Configure blockchain RPC nodes';

  @override
  String networkLoadFailed(String message) {
    return 'Load failed: $message';
  }

  @override
  String get networkSectionMainnet => 'Mainnet';

  @override
  String get networkSectionTestnet => 'Testnets';

  @override
  String get networkTestnetListHint =>
      'Chains marked as testnet in the app data source are listed here.';

  @override
  String networkCountNetworks(int count) {
    return '$count networks';
  }

  @override
  String get networkAboutNodesTitle => 'About RPC nodes';

  @override
  String get networkAboutNodesBullet1 =>
      'RPC nodes are your gateway to the blockchain network.';

  @override
  String get networkAboutNodesBullet2 =>
      'Add custom nodes to improve speed or reliability.';

  @override
  String get networkAboutNodesBullet3 =>
      'Prefer trusted public nodes or nodes you run yourself.';

  @override
  String get networkStatusConnectionOk => 'Connected';

  @override
  String get networkStatusConnectionError => 'Connection issue';

  @override
  String get networkStatusCustomized => 'Customized';

  @override
  String networkNodeCountLabel(int count) {
    return '$count nodes';
  }

  @override
  String networkAllNodesTitle(int count) {
    return 'All nodes ($count)';
  }

  @override
  String networkDetailHeaderNodeCount(int count) {
    return 'Total $count nodes';
  }

  @override
  String get networkQuickAddTitle => 'Quick add nodes';

  @override
  String get networkQuickAddLine1 =>
      'Tap a network to open its details and add custom RPC URLs.';

  @override
  String get networkQuickAddLine2 =>
      'You can add multiple nodes; the list is kept for future improvements (e.g. picking the fastest).';

  @override
  String get networkNodeProbeOk => 'Node connection OK';

  @override
  String networkNodeProbeOkLatency(int ms) {
    return 'Node connection OK, latency $ms ms';
  }

  @override
  String get networkCurrentNodeTitle => 'Current node';

  @override
  String get networkNodeActiveBadge => 'Active';

  @override
  String get networkNoNodeSelected => 'No node selected';

  @override
  String networkNodeLatencyMs(int ms) {
    return '$ms ms';
  }

  @override
  String get networkAddRpcDialogTitle => 'Add RPC node';

  @override
  String networkAddRpcDialogSubtitle(String networkName) {
    return 'Add a custom RPC node for the $networkName network.';
  }

  @override
  String get networkNodeNameLabel => 'Node name';

  @override
  String get networkNodeNameHint => 'e.g. My node 1';

  @override
  String get networkRpcUrlLabel => 'RPC URL';

  @override
  String get networkRpcUrlHint => 'https://…';

  @override
  String get networkExampleRpcLabel => 'Example RPC URL';

  @override
  String get networkConfirmAddNode => 'Add node';

  @override
  String get networkTipsTitle => 'Tips';

  @override
  String get networkTipsLine1 => 'Add several nodes as backups.';

  @override
  String get networkTipsLine2 =>
      'Test a node to see connection status and latency.';

  @override
  String get networkTipsLine3 =>
      'Lower latency often means faster transactions.';

  @override
  String get networkTipsLine4 => 'Built-in default nodes cannot be deleted.';

  @override
  String get networkNodeInUseBadge => 'In use';

  @override
  String get networkCannotDeleteDefaultNode =>
      'Default nodes cannot be deleted.';

  @override
  String get networkDeleteSwitchNodeFirst =>
      'Switch to another node before deleting this one.';

  @override
  String homeFiatApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String homeUnitPrice(String price) {
    return 'Unit price: $price';
  }

  @override
  String get homeUnitPriceUnavailable => 'Unit price: --';

  @override
  String get homeTransactionHistory => 'Note creation records';

  @override
  String get homeTransactionHistoryNotConfigured =>
      'Note creation records are not configured';

  @override
  String get transactionHistorySubtitle =>
      'View all your note creation records';

  @override
  String get transactionHistoryStatTotal => 'Total';

  @override
  String get transactionHistoryStatSuccess => 'Success';

  @override
  String get transactionHistoryStatPending => 'Pending';

  @override
  String get transactionHistoryStatFailed => 'Failed';

  @override
  String get transactionHistoryFilterAll => 'All';

  @override
  String get transactionHistoryFilterSend => 'Note created';

  @override
  String get transactionHistoryFilterReceive => 'Received';

  @override
  String get transactionHistorySelectChain => 'Select network';

  @override
  String get transactionHistoryCopied => 'Copied to clipboard';

  @override
  String get transactionHistoryExplorerInvalidUrl => 'Invalid explorer link';

  @override
  String get transactionHistoryExplorerLaunchFailed =>
      'Could not open the browser. Check system settings.';

  @override
  String transactionHistoryExplorerOpenError(String error) {
    return 'Could not open: $error';
  }

  @override
  String get transactionHistoryRefreshed => 'Note creation records updated';

  @override
  String get transactionHistoryTimeJustNow => 'Just now';

  @override
  String transactionHistoryTimeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String transactionHistoryTimeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get transactionHistoryEmptyTitle => 'No note creation records yet';

  @override
  String get transactionHistoryEmptyHintFiltered =>
      'No note creation records match this filter';

  @override
  String get transactionHistoryEmptyHintAll =>
      'You have no note creation records yet';

  @override
  String get transactionHistoryTypeSend => 'Note created';

  @override
  String get transactionHistoryTypeReceive => 'Received';

  @override
  String get transactionHistoryStatusSuccess => 'Success';

  @override
  String get transactionHistoryStatusFailed => 'Failed';

  @override
  String get transactionHistoryStatusPending => 'Pending';

  @override
  String get transactionHistoryDetailFrom => 'From';

  @override
  String get transactionHistoryDetailTo => 'To';

  @override
  String get transactionHistoryDetailTxHash => 'On-chain hash';

  @override
  String get transactionHistoryDetailBlock => 'Block';

  @override
  String transactionHistoryGasLine(String fee, String symbol) {
    return 'Gas: $fee $symbol';
  }

  @override
  String homeGasBalanceTitle(String symbol) {
    return '$symbol gas balance';
  }

  @override
  String get homeTotalAssets => 'Total balance';

  @override
  String get homeRefreshBalance => 'Refresh balance';

  @override
  String get homeGetGas => 'Get gas';

  @override
  String get homeGasHelp =>
      'Gas is required to send transactions on-chain. Please keep enough balance.';

  @override
  String getGasDialogTitle(String symbol) {
    return 'Get $symbol for gas';
  }

  @override
  String getGasDialogSubtitle(String chainName) {
    return 'Choose a way to add funds to your $chainName note account';
  }

  @override
  String get getGasOptionReceiveTitle => 'Receive tokens';

  @override
  String get getGasBadgeRecommended => 'Recommended';

  @override
  String getGasReceiveHint(String symbol) {
    return 'Transfer $symbol from another note account or exchange';
  }

  @override
  String get getGasWalletAddressLabel => 'Note account address';

  @override
  String get getGasShowQr => 'QR code';

  @override
  String get getGasHideQr => 'Hide';

  @override
  String getGasTransferWarning(String chainName) {
    return 'Use network $chainName for transfers, or notes may be lost.';
  }

  @override
  String get getGasFaucetTitle => 'Testnet faucet';

  @override
  String get getGasBadgeFree => 'Free';

  @override
  String getGasFaucetHint(String symbol) {
    return 'Claim free testnet $symbol from a faucet';
  }

  @override
  String getGasFaucetOpen(int index) {
    return 'Open faucet $index';
  }

  @override
  String get getGasBuyExchangeTitle => 'Buy on an exchange';

  @override
  String get getGasBadgeComingSoon => 'Coming soon';

  @override
  String getGasBuyExchangeHint(String symbol) {
    return 'Buy $symbol on an exchange and withdraw to your note account';
  }

  @override
  String get getGasDialogCancel => 'Cancel';

  @override
  String get getGasAddressCopied => 'Address copied';

  @override
  String get getGasInvalidLink => 'Invalid link';

  @override
  String get getGasCouldNotOpenLink =>
      'Could not open the link. Check that a browser is available.';

  @override
  String getGasOpenFailed(String error) {
    return 'Could not open: $error';
  }

  @override
  String get homeRecentNotes => 'Recent notes';

  @override
  String get homeRefreshRecentNotes => 'Refresh recent notes';

  @override
  String get homeLoadingOnChainNotes => 'Loading on-chain notes';

  @override
  String get homeSyncingOnChainNotes => 'Syncing on-chain notes…';

  @override
  String get homeNoNotesInLastMonth => 'No notes in the last month';

  @override
  String get homeCreateNewNotePrompt => 'Create a new note';

  @override
  String get notesAllChains => 'All chains';

  @override
  String get notesSwitchedToAllChains => 'Switched to all chains';

  @override
  String get notesFilterAll => 'All';

  @override
  String get notesFilterOnChain => 'On-chain';

  @override
  String get notesFilterOffChain => 'Not on-chain';

  @override
  String get notesSortNewest => 'Newest';

  @override
  String get notesSortUpdated => 'Updated';

  @override
  String get notesSortOldest => 'Oldest';

  @override
  String get notesSortTitle => 'Title';

  @override
  String notesTimelineNoteCount(int count) {
    return '$count notes';
  }

  @override
  String get noteStatsTotalNotes => 'Total notes';

  @override
  String get noteStatsOnChainCount => 'On-chain';

  @override
  String get noteStatsImages => 'Images';

  @override
  String get noteStatsChars => 'Characters';

  @override
  String get noteDeleteNote => 'Delete note';

  @override
  String get noteDeleteConfirmTitle => 'Delete note?';

  @override
  String get noteDeleteConfirmBody =>
      'Delete this note? This cannot be undone.';

  @override
  String get noteDeletedSnackbar => 'Note deleted';

  @override
  String noteDeleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String noteUpdatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String noteCreatedAt(String date) {
    return 'Created $date';
  }

  @override
  String get noteNoContent => 'No content yet';

  @override
  String get noteEditorCreateNewNote => 'Create new note';

  @override
  String noteEditorChainLine(String chainName) {
    return '$chainName network';
  }

  @override
  String get noteEditorSelectChainToPublish =>
      'Select a network to publish on-chain';

  @override
  String get noteEditorSave => 'Save';

  @override
  String get noteEditorSaving => 'Saving…';

  @override
  String get noteTitleLabel => 'Title';

  @override
  String get noteTitleHint => 'Give your note a title…';

  @override
  String get noteCoverImages => 'Cover image (optional)';

  @override
  String get noteCoverAdd => 'Add cover';

  @override
  String get noteCoverUploading => 'Uploading…';

  @override
  String get noteCoverTapUpload => 'Tap to upload a cover image';

  @override
  String get noteCoverFormatsHint => 'JPG, PNG, and other formats supported';

  @override
  String get noteRichTextGuideTitle => 'Rich text tools';

  @override
  String get noteRichTextHeadingLabel => 'Headings:';

  @override
  String get noteRichTextHeadingBody =>
      'Use the toolbar “Heading” to insert numbered headings.';

  @override
  String get noteRichTextListLabel => 'Lists:';

  @override
  String get noteRichTextListBody => 'Insert bullets or numbered lists.';

  @override
  String get noteRichTextEmojiLabel => 'Emoji:';

  @override
  String get noteRichTextEmojiBody =>
      'Insert common emoji and markers quickly.';

  @override
  String get noteRichTextTemplateLabel => 'Templates:';

  @override
  String get noteRichTextTemplateBody =>
      'Pick a preset template to start writing.';

  @override
  String get noteRichTextImageLabel => 'Images:';

  @override
  String get noteRichTextImageBody =>
      'Use the image button in the toolbar to insert into the body.';

  @override
  String get noteRichTextPreviewHint =>
      'Tip: switch to “Preview” to see formatted output.';

  @override
  String get noteEditorContentPlaceholder =>
      'Write your ideas, inspiration, and plans…\n\nTip: the toolbar can quickly insert:\n• Headings and lists\n• Emoji and symbols\n• Quick templates\n• Images\n\nRich text is supported; the detail page renders it nicely.';

  @override
  String get noteTipsTitle => 'Writing tips';

  @override
  String get noteTipsBody =>
      '• Use a meaningful title\n• Capture ideas, plans, or important information\n• Add images to enrich your note\n• After saving you can publish on-chain for permanent storage';

  @override
  String get noteReadyTitle => 'Ready';

  @override
  String get noteReadyBody =>
      'Content looks good. Tap “Save” at the top right to create your note.';

  @override
  String get noteTypeSectionLabel => 'Note type:';

  @override
  String get notePublishToChain => 'Publish on-chain';

  @override
  String get notePublishing => 'Publishing…';

  @override
  String get noteOnChainPublished => 'Published on-chain';

  @override
  String get selectBlockchainFirst =>
      'Please select a blockchain network first';

  @override
  String get noteImageAdded => 'Image added';

  @override
  String get noteImagePickFailed => 'Could not pick image';

  @override
  String get noteSavedToLocal => 'Saved locally';

  @override
  String get notePublishFailedKeptDraft => 'Publish failed; saved as draft';

  @override
  String get noteSavedAsDraft => 'Saved as draft';

  @override
  String get richTextPreviewMode => 'Preview mode';

  @override
  String get richTextEditMode => 'Edit mode';

  @override
  String get richTextPreview => 'Preview';

  @override
  String get richTextEdit => 'Edit';

  @override
  String richTextLineCount(int count) {
    return '$count lines';
  }

  @override
  String richTextCharCount(int count) {
    return '$count characters';
  }

  @override
  String get richTextToolbarBottomHint =>
      'Tip: use the toolbar for quick formatting, or type emoji and symbols manually.';

  @override
  String get richTextToolbarHeading => 'Heading';

  @override
  String get richTextTooltipInsertHeading => 'Insert heading';

  @override
  String get richTextTooltipBulletList => 'Insert bullet list';

  @override
  String get richTextTooltipNumberedList => 'Insert numbered list';

  @override
  String get richTextTooltipStatusMarkers => 'Insert status markers';

  @override
  String get richTextToolbarEmojiMenu => 'Emoji';

  @override
  String get richTextTooltipInsertEmoji => 'Insert emoji';

  @override
  String get richTextToolbarTemplate => 'Template';

  @override
  String get richTextTooltipQuickTemplate => 'Quick templates';

  @override
  String get richTextTooltipAddImage => 'Add image';

  @override
  String get richTextMdImageAlt => 'Image';

  @override
  String get richTextInsertNumberedHeading => '\n1️⃣ Title\n';

  @override
  String get richTextInsertBulletLines =>
      '\n• List item 1\n• List item 2\n• List item 3\n';

  @override
  String get richTextInsertNumberedLines =>
      '\n1. First item\n2. Second item\n3. Third item\n';

  @override
  String get richTextInsertStatusMarkers =>
      '\n🟢 Done\n🔵 In progress\n🟡 Pending\n';

  @override
  String get richTextEmojiGroupNumberedTitle => 'Numbered titles';

  @override
  String get richTextEmojiGroupStatus => 'Status markers';

  @override
  String get richTextEmojiGroupSymbols => 'Common symbols';

  @override
  String get richTextEmojiGroupEmoji => 'Emoji';

  @override
  String get richTextEmojiHeadingWord => 'Title';

  @override
  String get richTextEmojiBodyWord => 'Text';

  @override
  String get richTextTplStandardNoteName => '📝 Standard note';

  @override
  String get richTextTplStandardNoteBody =>
      'Title\n\nMain content:\n• Point 1\n• Point 2\n• Point 3\n\nSummary:\n';

  @override
  String get richTextTplTaskName => '✅ Task list';

  @override
  String get richTextTplTaskBody =>
      'Task list\n\nToday:\n✓ Completed\n✗ Not done\n→ In progress\n\nNotes:\n';

  @override
  String get richTextTplStudyName => '📚 Study notes';

  @override
  String get richTextTplStudyBody =>
      'Study notes - Topic\n\n1️⃣ Key ideas\n• Idea 1: details\n• Idea 2: details\n\n2️⃣ Summary\n• Takeaway 1\n• Takeaway 2\n\n3️⃣ Practice\n';

  @override
  String get richTextTplIdeaName => '💡 Idea capture';

  @override
  String get richTextTplIdeaBody =>
      '💡 Idea capture\n\nThought:\n🟢 Core idea\n\nPros:\n• Pro 1\n• Pro 2\n\nNext:\n→ Next step\n';

  @override
  String get richTextTplProjectName => '📊 Project plan';

  @override
  String get richTextTplProjectBody =>
      'Project plan\n\n🎯 Goal:\n\n📝 Steps:\n1. Step one\n2. Step two\n3. Step three\n\n⏰ Timeline:\n';

  @override
  String get gasPreviewTitle => 'Gas fee preview';

  @override
  String get gasPreviewSubtitle =>
      'Choose a gas speed and confirm to publish on-chain.';

  @override
  String get gasPreviewLoading => 'Fetching gas fees…';

  @override
  String get gasPreviewPickSpeed => 'Gas speed';

  @override
  String get gasPreviewLiveRates => 'Live estimates';

  @override
  String get gasSpeedSlow => 'Slow';

  @override
  String get gasSpeedStandard => 'Standard';

  @override
  String get gasSpeedFast => 'Fast';

  @override
  String get gasTimeSlow => '~3–5 min';

  @override
  String get gasTimeStandard => '~1–2 min';

  @override
  String get gasTimeFast => '~15–30 sec';

  @override
  String get gasDescSlow =>
      'baseFee×1.1; priority fee = max(30 Gwei, suggested) + 3 Gwei.';

  @override
  String get gasDescStandard =>
      'baseFee×1.25; priority fee = max(30 Gwei, suggested) + 8 Gwei.';

  @override
  String get gasDescFast =>
      'baseFee×1.5; priority fee = max(30 Gwei, suggested) + 20 Gwei.';

  @override
  String get gasLabelGasPrice => 'Gas price';

  @override
  String get gasLabelEstCost => 'Est. cost';

  @override
  String get gasRecommendedBadge => 'Recommended';

  @override
  String gasPreviewGweiMax(String value) {
    return '$value Gwei (max)';
  }

  @override
  String get gasFeeBreakdownTitle => 'Fee breakdown';

  @override
  String get gasFeeRowBase => 'Base fee';

  @override
  String get gasFeeRowPriority => 'Priority fee';

  @override
  String get gasFeeRowNoteSize => 'Note size';

  @override
  String get gasFeeRowTotal => 'Total';

  @override
  String gasFeeNoteSizeKb(String kb) {
    return '$kb KB';
  }

  @override
  String get gasWarningTitle => 'Before you continue';

  @override
  String get gasWarningBody =>
      '• Gas is paid to the network, not to this app.\n• Actual cost may vary slightly with congestion.\n• On-chain notes cannot be deleted or edited afterward.';

  @override
  String get gasConfirmOnChain => 'Confirm on-chain';

  @override
  String get gasOnChainConfirmDialogTitle => 'Cannot be changed after on-chain';

  @override
  String get gasOnChainConfirmDialogBody =>
      'This note will be written to the blockchain (IPFS + on-chain attestation).\nOnce submitted, it cannot be deleted or edited. Please make sure the content is correct before continuing.';

  @override
  String get gasOnChainConfirmDialogQuestion => 'Publish on-chain?';

  @override
  String get onChainConfirmParamSummarySectionTitle => 'Call parameters';

  @override
  String get noteOnChainParamJsonKeyNetwork => 'Network';

  @override
  String get noteOnChainParamJsonKeyChainId => 'Chain ID';

  @override
  String get noteOnChainParamJsonKeyFeeToken => 'Gas token';

  @override
  String get noteOnChainParamJsonKeySender => 'Sender (your note account)';

  @override
  String get noteOnChainParamJsonKeyContract => 'Contract address';

  @override
  String get noteOnChainParamJsonKeyContractName => 'Contract name';

  @override
  String get noteOnChainParamJsonKeyFunction => 'Function';

  @override
  String get noteOnChainParamJsonKeyNoteTitle => 'Note title';

  @override
  String get noteOnChainParamJsonKeyContentSha256 =>
      'Note body fingerprint (SHA-256)';

  @override
  String get noteOnChainParamJsonGroupMintCall =>
      'On-chain call (contract args)';

  @override
  String get noteOnChainParamJsonGroupContext => 'Details you can verify now';

  @override
  String get noteOnChainParamJsonValueUriPending =>
      'Actual ipfs:// values are filled after you sign and content is uploaded to IPFS';

  @override
  String get noteOnChainConfirmPageTitle => 'Confirm publishing on-chain';

  @override
  String get noteOnChainConfirmPageSubtitle =>
      'Save this note permanently on the blockchain';

  @override
  String get noteOnChainConfirmNoExplorer =>
      'This network has no block explorer configured; cannot open the contract.';

  @override
  String get noteOnChainConfirmMintStatusUncertain =>
      'On-chain status is unclear. Check the note or a block explorer later.';

  @override
  String get noteOnChainConfirmSignButton => 'Confirm verification';

  @override
  String get noteOnChainConfirmTipTitle => 'Before you publish';

  @override
  String get noteOnChainConfirmTipBody =>
      '• After publishing, the note cannot be edited or deleted\n• Your note will be on-chain permanently and belongs to you\n• A small gas fee is required, one time only';

  @override
  String get noteOnChainConfirmNoteContentSection => 'Note content';

  @override
  String get noteOnChainConfirmNoteTitleLabel => 'Title';

  @override
  String get noteOnChainConfirmContentPreview => 'Content preview';

  @override
  String get noteOnChainConfirmNoteHashLabel => 'Note hash (SHA-256)';

  @override
  String get noteOnChainConfirmChainDetailsSection => 'On-chain details';

  @override
  String get noteOnChainConfirmMyWallet => 'My note account';

  @override
  String get noteOnChainConfirmTargetContract => 'Target contract';

  @override
  String get noteOnChainConfirmContractOwnershipHint =>
      'The contract mints your note (NFT). The note (NFT) belongs to your note account—you hold permanent ownership of the note.';

  @override
  String noteOnChainConfirmNoteRecipientAddress(String address) {
    return 'Note recipient address: $address';
  }

  @override
  String get noteOnChainConfirmNetworkFee => 'Network fee';

  @override
  String get noteOnChainConfirmGasPriceLabel => 'Gas price';

  @override
  String get noteOnChainConfirmGasLimitLabel => 'Gas limit';

  @override
  String get noteOnChainConfirmOnChainFee => 'On-chain fee';

  @override
  String get noteOnChainConfirmGasOnlyHint => 'Gas only';

  @override
  String get noteOnChainConfirmAdvancedSection => 'Advanced';

  @override
  String get noteOnChainConfirmNonceLabel => 'Nonce';

  @override
  String get noteOnChainConfirmNetworkLabel => 'Network';

  @override
  String get noteOnChainConfirmGasSlow => 'Slow';

  @override
  String get noteOnChainConfirmGasNormal => 'Standard';

  @override
  String get noteOnChainConfirmGasFast => 'Fast';

  @override
  String get noteOnChainConfirmGasTimeSlow => '~5 min';

  @override
  String get noteOnChainConfirmGasTimeNormal => '~1 min';

  @override
  String get noteOnChainConfirmGasTimeFast => '~15 sec';

  @override
  String get saveOptionsTitle => 'Choose how to save';

  @override
  String get saveOptionsSubtitle => 'Pick the option that fits what you need.';

  @override
  String get saveOnChainTitle => 'Save on-chain';

  @override
  String get saveOnChainDescription =>
      'Permanent on the blockchain; tamper-resistant.';

  @override
  String get saveOnChainFeature1 => 'Permanent';

  @override
  String get saveOnChainFeature2 => 'Verifiable';

  @override
  String get saveOnChainFeature3 => 'Decentralized';

  @override
  String get ipfsUploadConfirmTitle => 'Upload to IPFS';

  @override
  String get ipfsUploadConfirmBody =>
      'This note has local images. Before going on-chain, they need to be uploaded to decentralized storage (IPFS). After upload you can continue to write to the blockchain.\n\nUpload to IPFS and continue?';

  @override
  String get saveBadgeSecure => 'Secure';

  @override
  String get saveDraftTitle => 'Save as draft';

  @override
  String get saveDraftDescription =>
      'Continue editing later; no chain resources yet.';

  @override
  String get saveDraftFeature1 => 'Edit anytime';

  @override
  String get saveDraftFeature2 => 'Stored locally';

  @override
  String get saveDraftFeature3 => 'Quick save';

  @override
  String get saveBadgeRecommended => 'Recommended';

  @override
  String get saveLocalTitle => 'Save locally';

  @override
  String get saveLocalDescription => 'Keep this note on this device only.';

  @override
  String get saveLocalFeature1 => 'Offline friendly';

  @override
  String get saveLocalFeature2 => 'Instant save';

  @override
  String get saveLocalFeature3 => 'No fees';

  @override
  String saveWillPublishToChain(String chainName) {
    return 'Will be saved on $chainName';
  }

  @override
  String get guideWelcomeTitle => 'Welcome to On Chain Notes';

  @override
  String get guideWelcomeSubtitle =>
      'Before we start, let’s set up your note account.';

  @override
  String get guideSecurityTitle => 'Your data, your control';

  @override
  String get guideSecurityBody =>
      'Your keys stay on your device. We do not store sensitive data on our servers. Keep your recovery phrase and security key safe.';

  @override
  String get guideCreateWalletTitle => 'Create a new note account';

  @override
  String get guideCreateWalletSubtitle =>
      'Start fresh with a new note account address and recovery phrase.';

  @override
  String get guideRecommendedNewUser => 'Recommended for new users';

  @override
  String get guideImportWalletTitle => 'Restore existing note account';

  @override
  String get guideImportWalletSubtitle =>
      'Restore with your recovery phrase or security key.';

  @override
  String get guideTagMnemonic => 'Recovery phrase';

  @override
  String get guideTagPrivateKey => 'Security key';

  @override
  String get guideICloudRestoreTitle => 'Restore from iCloud';

  @override
  String get guideICloudRestoreSubtitle =>
      'If you backed up your note account to iCloud, you can restore it quickly.';

  @override
  String get guideBadgeIosOnly => 'iOS only';

  @override
  String get guideGoogleRestoreTitle => 'Restore from Google Drive';

  @override
  String get guideGoogleRestoreSubtitle =>
      'If you backed up your note account to Google Drive, you can restore it quickly.';

  @override
  String get guideBadgeAllDevices => 'All devices';

  @override
  String get guideFooterHint =>
      'Choose any option to continue.\nYour keys are stored securely on this device.';

  @override
  String get guideProviderICloud => 'iCloud';

  @override
  String get guideProviderGoogleDrive => 'Google Drive';

  @override
  String get guideLoadingWalletMessage => 'Loading note account…';

  @override
  String googlePlayReviewModeTapHint(int remaining) {
    return '$remaining more tap(s) to enter review mode';
  }

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpCenterSubtitle => 'FAQ & user guide';

  @override
  String get helpSectionQuickGuide => 'Quick guides';

  @override
  String get helpSectionFaq => 'FAQ';

  @override
  String get helpSearchHint => 'Search questions…';

  @override
  String get helpCategoryAll => 'All';

  @override
  String get helpCategoryBasics => 'Basics';

  @override
  String get helpCategoryBlockchain => 'Blockchain';

  @override
  String get helpCategoryWalletSecurity => 'Note account security';

  @override
  String get helpCategoryWalletMgmt => 'Note account management';

  @override
  String get helpCategoryAdvanced => 'Advanced';

  @override
  String get helpCategoryCommon => 'Common issues';

  @override
  String get helpComingSoon => 'Coming soon';

  @override
  String get helpEmptyTitle => 'No matching questions';

  @override
  String get helpEmptySubtitle => 'Try other keywords or contact support';

  @override
  String get helpContactTitle => 'Contact support';

  @override
  String get helpContactSubtitle => 'No answer? Email us';

  @override
  String get helpContactSendFeedback => 'Send feedback';

  @override
  String get helpContactYourEmailOptional => 'Your email (optional)';

  @override
  String get helpContactEmailHint => '';

  @override
  String get helpContactMessageLabel => 'Message';

  @override
  String get helpContactMessageHint => 'Describe your issue or suggestion…';

  @override
  String get helpContactSending => 'Sending…';

  @override
  String get helpContactSend => 'Send';

  @override
  String get helpCopySupportEmail => 'Email address copied';

  @override
  String get helpFeedbackEmpty => 'Please enter your feedback';

  @override
  String get helpFeedbackThanks => 'Thank you for your feedback!';

  @override
  String get helpFeedbackMailFailed => 'Could not open email. Try again later.';

  @override
  String get helpFeedbackMailSubject => 'User feedback';

  @override
  String get helpQuickGuide1Title => 'Quick start';

  @override
  String get helpQuickGuide1Desc => 'Learn the basics in 5 minutes';

  @override
  String get helpQuickGuide2Title => 'Create your first note';

  @override
  String get helpQuickGuide2Desc => 'Create a note and publish on-chain';

  @override
  String get helpQuickGuide3Title => 'Back up your recovery phrase';

  @override
  String get helpQuickGuide3Desc => 'Keep your notes and data safe';

  @override
  String get helpQuickGuide4Title => 'Manage multiple note accounts';

  @override
  String get helpQuickGuide4Desc => 'Create, import, and switch note accounts';

  @override
  String get helpFaq1Question => 'What is On Chain Notes?';

  @override
  String get helpFaq1Answer =>
      'On Chain Notes lets you store notes permanently on a blockchain so content stays tamper-evident and traceable. Once published on-chain, it typically cannot be changed or removed.';

  @override
  String get helpFaq2Question => 'How do I create a note?';

  @override
  String get helpFaq2Answer =>
      'You can:\n1. Tap “Create note” on the home screen\n2. Or tap the “+” button on the notes page\n3. Add title, content, and images';

  @override
  String get helpFaq3Question => 'What save options are available?';

  @override
  String get helpFaq3Answer =>
      'There are three options:\n1. Draft: saved locally, editable anytime\n2. Local save: finalized locally\n3. On-chain: permanent on blockchain, not editable\n\nWe recommend using a draft first, then publishing when ready.';

  @override
  String get helpFaq4Question => 'What is on-chain save? Do I pay?';

  @override
  String get helpFaq4Answer =>
      'On-chain save stores your note on-chain permanently. You pay network fees (Gas) charged by the blockchain, not an app fee. Fees vary by network; many L2s are cheaper.';

  @override
  String get helpFaq5Question => 'Which networks are supported?';

  @override
  String get helpFaq5Answer =>
      'The app supports eight mainstream EVM networks, including Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Fantom, and Base. You can switch networks from the home screen.';

  @override
  String get helpFaq6Question => 'How do I verify a note is on-chain?';

  @override
  String get helpFaq6Answer =>
      'After publishing, you get a transaction hash. In note details you can view the hash, use Verify, or copy the hash to a block explorer for that network.';

  @override
  String get helpFaq7Question => 'What is a recovery phrase? Why back it up?';

  @override
  String get helpFaq7Answer =>
      'A recovery phrase (often 12 English words) is the master key to recover your note account.\n\nIf you lose it, you may lose access forever.\nIf it leaks, your notes may be permanently lost or managed by others.\nThe app cannot recover it for you.\nWrite it on paper and store it safely.';

  @override
  String get helpFaq8Question => 'How do I back up my recovery phrase?';

  @override
  String get helpFaq8Answer =>
      '1. Open Profile\n2. Tap backup recovery phrase\n3. Read the warnings\n4. Write down all words in order\n5. Verify in order\n6. Finish backup\n\nDo this in a private environment.';

  @override
  String get helpFaq9Question => 'Recovery phrase vs security key?';

  @override
  String get helpFaq9Answer =>
      'Both can restore an note account.\n\nRecovery phrase: 12 words, easier to write down, derives keys (recommended backup).\n\nSecurity key: long hex string, harder to handle, single address (advanced users).';

  @override
  String get helpFaq10Question => 'How do I switch note accounts?';

  @override
  String get helpFaq10Answer =>
      '1. Tap the note account address on the home header\n2. Pick another note account in the selector\n3. Or go to Note account management to create/import\n\nYou can manage multiple note accounts.';

  @override
  String get helpFaq11Question => 'How do I see addresses on other chains?';

  @override
  String get helpFaq11Answer =>
      'In My note account:\n1. Expand the card with the arrow\n2. See supported chains and addresses\n3. Tap to copy\n\nFor EVM-compatible chains, the address format is the same.';

  @override
  String get helpFaq12Question => 'How do I customize an RPC node?';

  @override
  String get helpFaq12Answer =>
      '1. Profile → Network settings\n2. Choose a network\n3. Add node\n4. Enter name and RPC URL\n5. Test connection\n6. Set as default\n\nCustom RPC can improve speed and reliability.';

  @override
  String get helpFaq13Question => 'What rich text formats are supported?';

  @override
  String get helpFaq13Answer =>
      'Bold, italic, underline, headings (H1–H3), ordered/bullet lists, quotes, code blocks, and image upload—via the editor toolbar.';

  @override
  String get helpFaq14Question => 'Can on-chain notes be edited or deleted?';

  @override
  String get helpFaq14Answer =>
      'Generally not—that is a property of blockchains.\n\nPublished notes are permanent and tamper-evident.\nUse drafts to iterate, then publish only when sure. Avoid putting highly sensitive data on-chain.';

  @override
  String get helpFaq15Question => 'Why does on-chain publishing take time?';

  @override
  String get helpFaq15Answer =>
      'After fees are accepted, the transaction must be mined. Time depends on congestion and gas speed (fast often ~15–30s, standard ~1–2m, slow longer). Usually under a couple of minutes.';

  @override
  String get helpFaq16Question => 'What if I forgot my password?';

  @override
  String get helpFaq16Answer =>
      'You can re-import the note account with your recovery phrase and set a new password. Local data may be retained depending on your setup.\n\nRemember: password encrypts locally; recovery phrase is the ultimate recovery key—keep it backed up.';

  @override
  String helpFeedbackMailBody(String email, String message) {
    return 'Contact email: $email\n\n$message';
  }

  @override
  String get termsOfServiceLastUpdatedLabel => 'Last updated';

  @override
  String get termsOfServiceIntroTitle => 'Important';

  @override
  String termsOfServiceIntroBody(String privacyDoc) {
    return 'Please read these Terms of Service and $privacyDoc carefully. By using the service you acknowledge these rules. If you do not agree, please do not use the service.';
  }

  @override
  String get termsOfServiceHelpTitle => 'Need help?';

  @override
  String get termsOfServiceHelpBody =>
      'If you have questions about these terms, open the in-app Help Center or contact us via feedback or email. We will do our best to respond within a reasonable time.';

  @override
  String get termsOfServiceHelpMailFeedback => 'Email feedback';

  @override
  String get termsOfServiceSection01Title => '1. Acceptance';

  @override
  String termsOfServiceSection01Body(String appTitle) {
    return 'Welcome to $appTitle (“the Service”). Please read these Terms of Service (“the Terms”) before use.\nBy tapping agree, security verification up, security verification in, or using the Service, you agree to be bound by the Terms. If you disagree, stop using the Service.\nWe may update the Terms from time to time. Continued use after notice or updates means you accept the revised Terms.';
  }

  @override
  String get termsOfServiceSection02Title => '2. Description of the Service';

  @override
  String get termsOfServiceSection02Body =>
      'The Service combines local storage with blockchain-related features: you can create, edit, and manage notes on your device and optionally perform on-chain actions (such as transactions, hashes, or metadata—see in-app flows and prompts).\nCurrent characteristics may evolve with releases:\n• Local storage: note data is mainly stored on your device (e.g. local database); uninstalling the app may erase local data—back up on your own.\n• On-chain features: you may voluntarily submit on-chain operations for proof, sync, or display; on-chain records are often public and hard to delete.\n• Multi-chain: multiple EVM-compatible networks as listed in the app.\n• Note account: keys are generated or imported by you on the device; you are responsible for safeguarding keys and recovery phrases.\nThe Service provides technical tools only and does not warrant the legality, accuracy, completeness, or fitness for a particular purpose of your content.';

  @override
  String get termsOfServiceSection03Title => '3. Note account and security';

  @override
  String get termsOfServiceSection03Body =>
      '3.1 Note account and credentials: after creating or importing an note account, the app manages addresses and key material on the device. Recovery phrases and security keys are among the only practical ways to recover notes—back them up offline and keep them secret.\n3.2 Your responsibility: actions performed while the app or note account is unlocked on your device are treated as yours or authorized by you. Losses from leaked phrases/keys, lost devices, malware, phishing, or failure to follow prompts are yours to bear.\n3.3 Security tips:\n• Never share your recovery phrase or security key with anyone\n• Use a strong app password and device lock / biometrics where available\n• Back up your phrase in a trusted environment and verify the backup\n• Beware of fake apps and phishing links\n3.4 We and our staff will never ask for your full recovery phrase or security key. Reject such requests and report them through official channels.';

  @override
  String get termsOfServiceSection04Title =>
      '4. Blockchain transactions and fees';

  @override
  String termsOfServiceSection04Body(String appTitle) {
    return '4.1 Gas and network fees: on-chain transactions require fees paid to the network (e.g. gas). Fees are collected by the network, not by $appTitle as a software provider on your behalf; amounts depend on the network and congestion.\n4.2 Confirmation time: transactions need network confirmation; timing depends on network conditions and your fee settings—we do not guarantee a specific duration.\n4.3 Failures and charges: insufficient balance, RPC errors, user cancellation, or contract reverts may cause failure; network fees already spent may be non-refundable per network rules.\n4.4 Irreversibility: once sufficiently confirmed, on-chain transactions usually cannot be undone. Double-check network, amounts, and contract calls before security verification and broadcasting.\n4.5 You are responsible for all on-chain actions you initiate. To the extent permitted by law, we are not liable for losses from blockchain protocols, nodes, smart contracts, or your own mistakes.';
  }

  @override
  String get termsOfServiceSection05Title => '5. Acceptable use';

  @override
  String get termsOfServiceSection05Body =>
      'You must not:\n• Create, upload, or distribute illegal, infringing, defamatory, obscene, violent, hateful, or otherwise unlawful content\n• Use the Service for fraud, money laundering, illegal fundraising, IP infringement, or other conduct prohibited by regulators\n• Access, probe, disrupt, or damage the Service or related infrastructure without authorization\n• Scrape, abuse APIs, or harm other users’ normal use (unless we agree in writing)\n• Send bulk harassment or unsolicited commercial messages\nIf you breach the above, we may warn you, restrict features, suspend, or terminate access, and cooperate with lawful or regulatory requests where required.';

  @override
  String get termsOfServiceSection06Title => '6. Intellectual property';

  @override
  String get termsOfServiceSection06Body =>
      '6.1 The Service itself: client software, UI, branding, and documentation are protected by us or right holders. Without permission, you may not copy, reverse engineer, crack, or commercially redistribute the core software (except as allowed by law).\n6.2 Your content: you retain rights in notes and content you create; the Terms do not transfer those rights to us.\n6.3 License to us: solely to operate and improve the Service (sync, display, backup, on-chain submission, etc.), you grant us a non-exclusive, royalty-free license, revocable as permitted by the Terms.\n6.4 Do not use our trademarks, app name, or logos in a confusing way without written consent.';

  @override
  String get termsOfServiceSection07Title => '7. Disclaimers';

  @override
  String get termsOfServiceSection07Body =>
      '7.1 “As is”: to the fullest extent permitted by law, the Service is provided “as is” and “as available.” We disclaim warranties of uninterrupted operation, error-free use, suitability for your needs, or compatibility with all devices or software.\n7.2 Data and security: we use reasonable measures but cannot guarantee there will never be data loss, leaks, or outages due to force majeure, lost devices, malware, attacks, or external systems (blockchain / IPFS, etc.).\n7.3 Third parties: the Service may rely on nodes, gateways, decentralized storage, push messaging, etc.; we do not warrant third parties’ availability, accuracy, or compliance—assess risks yourself.\n7.4 On-chain notes and protocol risks: on-chain notes and related protocols involve network issues, contract bugs, forks, and other risks—you assume them.\n7.5 Liability cap: except where law forbids, we are not liable for indirect, incidental, special, or consequential damages; our total liability is capped at fees you actually paid us for the disputed Service (zero if none).';

  @override
  String get termsOfServiceSection08Title =>
      '8. Changes, suspension, and termination';

  @override
  String get termsOfServiceSection08Body =>
      '8.1 We may change, suspend, or discontinue features for business, compliance, or technical reasons; we will notify you in-app when practicable.\n8.2 You may stop using the Service and uninstall at any time; export or back up important data beforehand.\n8.3 We may suspend or terminate access if you materially breach the Terms.\n8.4 After termination, unless the law requires otherwise, we have no obligation to retain or return data already on-chain, on third-party networks, or locally under your control.';

  @override
  String get termsOfServiceSection09Title => '9. Governing law and disputes';

  @override
  String get termsOfServiceSection09Body =>
      '9.1 These Terms are governed by the laws of mainland China (for these Terms only, excluding conflict-of-law rules that would select foreign law, unless mandatory law says otherwise).\n9.2 Disputes should first be resolved through good-faith negotiation.\n9.3 If negotiation fails, either party may bring a suit in a court with jurisdiction (e.g. where our principal office is located), subject to mandatory jurisdictional rules.';

  @override
  String get termsOfServiceSection10Title => '10. Miscellaneous';

  @override
  String termsOfServiceSection10Body(String privacyDoc) {
    return '10.1 Entire agreement: these Terms, $privacyDoc, and in-app rules together govern use of the Service; special rules prevail for their topic if they conflict (without violating mandatory law).\n10.2 Severability: if a provision is invalid, the rest remain in effect and should be interpreted as closely as legally possible to the original intent.\n10.3 No waiver: failure to enforce a right is not a waiver.\n10.4 Contact: unless the law requires another channel, ask about these Terms via the in-app Help Center or feedback.';
  }

  @override
  String termsOfServiceFooterLine1(String appTitle) {
    return 'Thank you for trusting and using $appTitle.';
  }

  @override
  String get connectEvmAccountFirst => 'Connect an EVM note account first';

  @override
  String get createAccountFailedRetry =>
      'Failed to create note account. Please try again later.';

  @override
  String createAccountFailedWithError(String error) {
    return 'Failed to create note account: $error';
  }

  @override
  String get transactionHistoryConnectEvm =>
      'Select a network and ensure an EVM note account is connected';

  @override
  String get transactionHistoryUnsupportedNetwork =>
      'This network does not support note creation records yet. Switch to a common EVM network.';

  @override
  String get securityVerificationFailed => 'Security verification failed';

  @override
  String get walletImportPrivateKeyHint =>
      'Enter your security key. Never share it with anyone.';

  @override
  String get walletImportPrivateKeySubmit => 'Import security key';
}
