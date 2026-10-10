import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ChainNotes'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabProfile;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get myNotes;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesCount(int count);

  /// No description provided for @createNote.
  ///
  /// In en, this message translates to:
  /// **'Create Note'**
  String get createNote;

  /// No description provided for @selectNetwork.
  ///
  /// In en, this message translates to:
  /// **'Select Network'**
  String get selectNetwork;

  /// No description provided for @selectNetworkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the blockchain network you want to use'**
  String get selectNetworkSubtitle;

  /// No description provided for @chainSelectorMainnetTab.
  ///
  /// In en, this message translates to:
  /// **'Mainnet'**
  String get chainSelectorMainnetTab;

  /// No description provided for @chainSelectorTestnetTab.
  ///
  /// In en, this message translates to:
  /// **'Testnet'**
  String get chainSelectorTestnetTab;

  /// No description provided for @chainSelectorFooterHint.
  ///
  /// In en, this message translates to:
  /// **'After you switch networks, notes are saved on the corresponding blockchain.'**
  String get chainSelectorFooterHint;

  /// No description provided for @chainSelectorTestnetNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'About testnets'**
  String get chainSelectorTestnetNoticeTitle;

  /// No description provided for @chainSelectorTestnetNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Testnets are for development and testing; tokens have no real value.'**
  String get chainSelectorTestnetNoticeBody;

  /// No description provided for @chainSelectorAllChainsTitle.
  ///
  /// In en, this message translates to:
  /// **'All chains'**
  String get chainSelectorAllChainsTitle;

  /// No description provided for @chainSelectorAllChainsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show notes from all chains'**
  String get chainSelectorAllChainsSubtitle;

  /// No description provided for @chainSelectorChainIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Chain ID: {chainId}'**
  String chainSelectorChainIdLabel(int chainId);

  /// No description provided for @chainSelectorCurrentBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get chainSelectorCurrentBadge;

  /// No description provided for @chainSelectorGasLabel.
  ///
  /// In en, this message translates to:
  /// **'Gas: {cost}'**
  String chainSelectorGasLabel(String cost);

  /// No description provided for @chainGasCostLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get chainGasCostLevelMedium;

  /// No description provided for @chainSelectorTestnetChainWarning.
  ///
  /// In en, this message translates to:
  /// **'Testnet — no real value'**
  String get chainSelectorTestnetChainWarning;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @aboutPageTagline.
  ///
  /// In en, this message translates to:
  /// **'Permanent storage · Tamper-proof · Full control'**
  String get aboutPageTagline;

  /// No description provided for @splashVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String splashVersionLabel(String version);

  /// No description provided for @aboutPageVersionSection.
  ///
  /// In en, this message translates to:
  /// **'Version info'**
  String get aboutPageVersionSection;

  /// No description provided for @aboutPageCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get aboutPageCurrentVersion;

  /// No description provided for @photosPermissionDeniedSnack.
  ///
  /// In en, this message translates to:
  /// **'Photo library access is required. Enable it in Settings and try again.'**
  String get photosPermissionDeniedSnack;

  /// No description provided for @pressBackAgainToExitApp.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExitApp;

  /// No description provided for @noteEditorOnChainTypeConfirmedSnack.
  ///
  /// In en, this message translates to:
  /// **'On-chain type confirmed. Save the note or tap \"{publishAction}\" to continue.'**
  String noteEditorOnChainTypeConfirmedSnack(String publishAction);

  /// No description provided for @actionShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get actionShow;

  /// No description provided for @actionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// No description provided for @actionSaveToFile.
  ///
  /// In en, this message translates to:
  /// **'Save to file'**
  String get actionSaveToFile;

  /// No description provided for @mnemonicExportSecurityConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Security confirmation'**
  String get mnemonicExportSecurityConfirmTitle;

  /// No description provided for @mnemonicExportAckSaved.
  ///
  /// In en, this message translates to:
  /// **'I have securely backed up my recovery phrase'**
  String get mnemonicExportAckSaved;

  /// No description provided for @mnemonicExportAckUnderstandLoss.
  ///
  /// In en, this message translates to:
  /// **'I understand that losing my recovery phrase means I cannot recover this note account'**
  String get mnemonicExportAckUnderstandLoss;

  /// No description provided for @mnemonicExportAckNoShare.
  ///
  /// In en, this message translates to:
  /// **'I will not share my recovery phrase with anyone'**
  String get mnemonicExportAckNoShare;

  /// No description provided for @mnemonicExportSafetyTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety tips'**
  String get mnemonicExportSafetyTipsTitle;

  /// No description provided for @mnemonicExportSafetyTipPaper.
  ///
  /// In en, this message translates to:
  /// **'Write your recovery phrase on paper and store it in a safe place'**
  String get mnemonicExportSafetyTipPaper;

  /// No description provided for @mnemonicExportSafetyTipNoScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Do not screenshot or store it on internet-connected devices'**
  String get mnemonicExportSafetyTipNoScreenshot;

  /// No description provided for @mnemonicExportSafetyTipCheckBackup.
  ///
  /// In en, this message translates to:
  /// **'Check your backup periodically to make sure it is intact'**
  String get mnemonicExportSafetyTipCheckBackup;

  /// No description provided for @mnemonicExportFinishCta.
  ///
  /// In en, this message translates to:
  /// **'I have backed up securely'**
  String get mnemonicExportFinishCta;

  /// No description provided for @aboutPageReleaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get aboutPageReleaseDate;

  /// No description provided for @aboutPageBuildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get aboutPageBuildNumber;

  /// No description provided for @aboutPageCoreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Core features'**
  String get aboutPageCoreFeatures;

  /// No description provided for @aboutFeatureOnChainTitle.
  ///
  /// In en, this message translates to:
  /// **'On-chain storage'**
  String get aboutFeatureOnChainTitle;

  /// No description provided for @aboutFeatureOnChainDesc.
  ///
  /// In en, this message translates to:
  /// **'SHA-256 hashes on-chain, permanently immutable.'**
  String get aboutFeatureOnChainDesc;

  /// No description provided for @aboutFeatureSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Data security'**
  String get aboutFeatureSecureTitle;

  /// No description provided for @aboutFeatureSecureDesc.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encryption; you control your keys.'**
  String get aboutFeatureSecureDesc;

  /// No description provided for @aboutFeatureSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant sync'**
  String get aboutFeatureSyncTitle;

  /// No description provided for @aboutFeatureSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Real-time sync across devices, access anywhere.'**
  String get aboutFeatureSyncDesc;

  /// No description provided for @aboutFeatureControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Full control'**
  String get aboutFeatureControlTitle;

  /// No description provided for @aboutFeatureControlDesc.
  ///
  /// In en, this message translates to:
  /// **'Decentralized architecture; your data stays yours.'**
  String get aboutFeatureControlDesc;

  /// No description provided for @aboutPageTechStack.
  ///
  /// In en, this message translates to:
  /// **'Tech stack'**
  String get aboutPageTechStack;

  /// No description provided for @aboutPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get aboutPageContactUs;

  /// No description provided for @aboutPageOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get aboutPageOfficialWebsite;

  /// No description provided for @aboutPageContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact email'**
  String get aboutPageContactEmail;

  /// No description provided for @aboutPageOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get aboutPageOpenSource;

  /// No description provided for @aboutPageCreditsMadeWith.
  ///
  /// In en, this message translates to:
  /// **'Made with '**
  String get aboutPageCreditsMadeWith;

  /// No description provided for @aboutPageCopyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'© {yearBrand}. All rights reserved.'**
  String aboutPageCopyrightNotice(String yearBrand);

  /// No description provided for @walletManagement.
  ///
  /// In en, this message translates to:
  /// **'Note account Management'**
  String get walletManagement;

  /// No description provided for @walletCannotDeleteSwitchFirst.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the note account in use. Switch to another note account first.'**
  String get walletCannotDeleteSwitchFirst;

  /// No description provided for @walletViewMnemonicCompleteBackupFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete the recovery phrase backup flow before viewing your recovery phrase or security key.'**
  String get walletViewMnemonicCompleteBackupFirst;

  /// No description provided for @walletDemoPrimaryName.
  ///
  /// In en, this message translates to:
  /// **'My primary note account'**
  String get walletDemoPrimaryName;

  /// No description provided for @walletAddressListTitle.
  ///
  /// In en, this message translates to:
  /// **'Note account addresses'**
  String get walletAddressListTitle;

  /// No description provided for @copyAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Copy address'**
  String get copyAddressButton;

  /// No description provided for @labelCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get labelCopied;

  /// No description provided for @walletManagementDeleteIrreversible.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Make sure you have backed up your recovery phrase or security key.'**
  String get walletManagementDeleteIrreversible;

  /// No description provided for @walletManagementDeleteWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning: cannot be recovered after deletion'**
  String get walletManagementDeleteWarningTitle;

  /// No description provided for @walletManagementDeleteAssetsLoss.
  ///
  /// In en, this message translates to:
  /// **'If you have not saved your recovery phrase or security key, you may permanently lose access to your notes.'**
  String get walletManagementDeleteAssetsLoss;

  /// No description provided for @walletCreateSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'A new note account address and recovery phrase will be generated for you.'**
  String get walletCreateSystemDescription;

  /// No description provided for @walletCreateBackupReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Back up your recovery phrase immediately after creation. It is the only way to recover your note account.'**
  String get walletCreateBackupReminderBody;

  /// No description provided for @walletCreateGenerateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate a new note account'**
  String get walletCreateGenerateSubtitle;

  /// No description provided for @walletAddressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get walletAddressCopied;

  /// No description provided for @walletNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Note account name is required'**
  String get walletNameRequired;

  /// No description provided for @walletNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Note account name updated'**
  String get walletNameUpdated;

  /// No description provided for @walletKeepAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'At least one note account must be kept'**
  String get walletKeepAtLeastOne;

  /// No description provided for @walletCannotDeleteCurrent.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the note account in use'**
  String get walletCannotDeleteCurrent;

  /// No description provided for @walletDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note account deleted'**
  String get walletDeleted;

  /// No description provided for @walletCreated.
  ///
  /// In en, this message translates to:
  /// **'Note account created'**
  String get walletCreated;

  /// No description provided for @walletImportMnemonicOrKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter recovery phrase or security key'**
  String get walletImportMnemonicOrKeyRequired;

  /// No description provided for @walletImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Note account restored successfully'**
  String get walletImportSuccess;

  /// No description provided for @walletImportedCannotViewMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Restored note account cannot view recovery phrase'**
  String get walletImportedCannotViewMnemonic;

  /// No description provided for @walletMarkedBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Marked as backed up'**
  String get walletMarkedBackedUp;

  /// No description provided for @walletSwitched.
  ///
  /// In en, this message translates to:
  /// **'Note account switched'**
  String get walletSwitched;

  /// No description provided for @viewMnemonic.
  ///
  /// In en, this message translates to:
  /// **'View Recovery phrase'**
  String get viewMnemonic;

  /// No description provided for @viewPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'View security key'**
  String get viewPrivateKey;

  /// No description provided for @privateKeyExportSelectNetworkHint.
  ///
  /// In en, this message translates to:
  /// **'Select a network to view'**
  String get privateKeyExportSelectNetworkHint;

  /// No description provided for @privateKeyExportKeepKeySafeHint.
  ///
  /// In en, this message translates to:
  /// **'Keep your security key secure'**
  String get privateKeyExportKeepKeySafeHint;

  /// No description provided for @privateKeyExportSecurityWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Security warning'**
  String get privateKeyExportSecurityWarningTitle;

  /// No description provided for @privateKeyExportWarnBullet1.
  ///
  /// In en, this message translates to:
  /// **'Your security key is the highest-level credential for managing your notes'**
  String get privateKeyExportWarnBullet1;

  /// No description provided for @privateKeyExportWarnBullet2.
  ///
  /// In en, this message translates to:
  /// **'Anyone who obtains your security key can fully manage your notes'**
  String get privateKeyExportWarnBullet2;

  /// No description provided for @privateKeyExportWarnBullet3.
  ///
  /// In en, this message translates to:
  /// **'Ensure your surroundings are safe and no one is watching'**
  String get privateKeyExportWarnBullet3;

  /// No description provided for @privateKeyExportWarnBullet4.
  ///
  /// In en, this message translates to:
  /// **'Never screenshot, photograph, or transmit your security key over a network'**
  String get privateKeyExportWarnBullet4;

  /// No description provided for @privateKeyExportSupportedNetworksTitle.
  ///
  /// In en, this message translates to:
  /// **'Supported networks'**
  String get privateKeyExportSupportedNetworksTitle;

  /// No description provided for @privateKeyExportNetworkCount.
  ///
  /// In en, this message translates to:
  /// **'{count} networks'**
  String privateKeyExportNetworkCount(int count);

  /// No description provided for @privateKeyExportViewSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Security key safety tips'**
  String get privateKeyExportViewSafetyTitle;

  /// No description provided for @privateKeyExportViewBullet1.
  ///
  /// In en, this message translates to:
  /// **'Ensure your surroundings are safe and no one can see your screen'**
  String get privateKeyExportViewBullet1;

  /// No description provided for @privateKeyExportViewBullet2.
  ///
  /// In en, this message translates to:
  /// **'Do not view in public places or on untrusted networks'**
  String get privateKeyExportViewBullet2;

  /// No description provided for @privateKeyExportViewBullet3.
  ///
  /// In en, this message translates to:
  /// **'Close this page as soon as you are done viewing'**
  String get privateKeyExportViewBullet3;

  /// No description provided for @privateKeyExportKeySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Security key'**
  String get privateKeyExportKeySectionTitle;

  /// No description provided for @privateKeyExportBip44Hint.
  ///
  /// In en, this message translates to:
  /// **'The security key derived via the BIP44 Ethereum path is the same across EVM mainnets; only the network name differs.'**
  String get privateKeyExportBip44Hint;

  /// No description provided for @privateKeyExportMaskedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'0x•••••••••••••••••••••••••••••••••'**
  String get privateKeyExportMaskedPlaceholder;

  /// No description provided for @privateKeyExportDoNotShareInline.
  ///
  /// In en, this message translates to:
  /// **'Never tell anyone your security key or send it over a network'**
  String get privateKeyExportDoNotShareInline;

  /// No description provided for @privateKeyExportNetworkAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'{networkName} network address'**
  String privateKeyExportNetworkAddressLabel(String networkName);

  /// No description provided for @privateKeyExportImportantReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get privateKeyExportImportantReminderTitle;

  /// No description provided for @privateKeyExportReminderBullet1.
  ///
  /// In en, this message translates to:
  /// **'Having the security key means you can fully manage notes for this address'**
  String get privateKeyExportReminderBullet1;

  /// No description provided for @privateKeyExportReminderBullet2.
  ///
  /// In en, this message translates to:
  /// **'A leaked security key can cause permanent loss of notes with no recovery'**
  String get privateKeyExportReminderBullet2;

  /// No description provided for @privateKeyExportReminderBullet3.
  ///
  /// In en, this message translates to:
  /// **'Our team will never ask you for your security key'**
  String get privateKeyExportReminderBullet3;

  /// No description provided for @privateKeyExportReminderBullet4.
  ///
  /// In en, this message translates to:
  /// **'We recommend backing up with a recovery phrase rather than exporting the security key'**
  String get privateKeyExportReminderBullet4;

  /// No description provided for @privateKeyExportBackToList.
  ///
  /// In en, this message translates to:
  /// **'Back to list'**
  String get privateKeyExportBackToList;

  /// No description provided for @privateKeyExportCopySecurityKey.
  ///
  /// In en, this message translates to:
  /// **'Copy security key'**
  String get privateKeyExportCopySecurityKey;

  /// No description provided for @mnemonicManagePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase'**
  String get mnemonicManagePageTitle;

  /// No description provided for @mnemonicManagePageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your recovery phrase safe — never share it'**
  String get mnemonicManagePageSubtitle;

  /// No description provided for @mnemonicBackupFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Back up recovery phrase'**
  String get mnemonicBackupFlowTitle;

  /// No description provided for @mnemonicBackupFlowStepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String mnemonicBackupFlowStepProgress(int step, int total);

  /// No description provided for @mnemonicBackupFlowLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed'**
  String get mnemonicBackupFlowLoadFailed;

  /// No description provided for @mnemonicBackupFlowCTAUnderstoodStart.
  ///
  /// In en, this message translates to:
  /// **'I understand, start backup'**
  String get mnemonicBackupFlowCTAUnderstoodStart;

  /// No description provided for @mnemonicBackupFlowCTACopiedContinue.
  ///
  /// In en, this message translates to:
  /// **'I\'ve written them down, continue'**
  String get mnemonicBackupFlowCTACopiedContinue;

  /// No description provided for @mnemonicBackupFlowCTAVerifiedContinue.
  ///
  /// In en, this message translates to:
  /// **'Verified, continue'**
  String get mnemonicBackupFlowCTAVerifiedContinue;

  /// No description provided for @mnemonicBackupFlowCTAPleaseVerify.
  ///
  /// In en, this message translates to:
  /// **'Complete verification first'**
  String get mnemonicBackupFlowCTAPleaseVerify;

  /// No description provided for @mnemonicBackupFlowCTAFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish backup'**
  String get mnemonicBackupFlowCTAFinish;

  /// No description provided for @mnemonicBackupFlowCTANext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get mnemonicBackupFlowCTANext;

  /// No description provided for @mnemonicBackupFlowFooterCopyHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure you have correctly written down every word before continuing'**
  String get mnemonicBackupFlowFooterCopyHint;

  /// No description provided for @mnemonicBackupFlowStep1Heading.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get mnemonicBackupFlowStep1Heading;

  /// No description provided for @mnemonicBackupFlowStep1Subheading.
  ///
  /// In en, this message translates to:
  /// **'Please read the following security tips carefully'**
  String get mnemonicBackupFlowStep1Subheading;

  /// No description provided for @mnemonicBackupFlowSecurityTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Important security tips'**
  String get mnemonicBackupFlowSecurityTipsTitle;

  /// No description provided for @mnemonicBackupFlowSecurityTip1.
  ///
  /// In en, this message translates to:
  /// **'Your recovery phrase is the only way to recover this note account'**
  String get mnemonicBackupFlowSecurityTip1;

  /// No description provided for @mnemonicBackupFlowSecurityTip2.
  ///
  /// In en, this message translates to:
  /// **'Anyone with your recovery phrase can manage your notes'**
  String get mnemonicBackupFlowSecurityTip2;

  /// No description provided for @mnemonicBackupFlowSecurityTip3.
  ///
  /// In en, this message translates to:
  /// **'If you lose your recovery phrase, your note account cannot be recovered'**
  String get mnemonicBackupFlowSecurityTip3;

  /// No description provided for @mnemonicBackupFlowBackupAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'How to back up safely'**
  String get mnemonicBackupFlowBackupAdviceTitle;

  /// No description provided for @mnemonicBackupFlowBackupAdvice1.
  ///
  /// In en, this message translates to:
  /// **'Write the recovery phrase on paper and store it somewhere safe'**
  String get mnemonicBackupFlowBackupAdvice1;

  /// No description provided for @mnemonicBackupFlowBackupAdvice2.
  ///
  /// In en, this message translates to:
  /// **'Do not screenshot or store it on internet-connected devices'**
  String get mnemonicBackupFlowBackupAdvice2;

  /// No description provided for @mnemonicBackupFlowBackupAdvice3.
  ///
  /// In en, this message translates to:
  /// **'Never send it over the network or share it with anyone'**
  String get mnemonicBackupFlowBackupAdvice3;

  /// No description provided for @mnemonicBackupFlowBackupAdvice4.
  ///
  /// In en, this message translates to:
  /// **'Consider multiple copies in separate secure places'**
  String get mnemonicBackupFlowBackupAdvice4;

  /// No description provided for @mnemonicBackupFlowProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup steps'**
  String get mnemonicBackupFlowProcessTitle;

  /// No description provided for @mnemonicBackupFlowProcess1.
  ///
  /// In en, this message translates to:
  /// **'View and write down your recovery phrase'**
  String get mnemonicBackupFlowProcess1;

  /// No description provided for @mnemonicBackupFlowProcess2.
  ///
  /// In en, this message translates to:
  /// **'Confirm your backup with verification'**
  String get mnemonicBackupFlowProcess2;

  /// No description provided for @mnemonicBackupFlowProcess3.
  ///
  /// In en, this message translates to:
  /// **'Finish backup to protect your notes'**
  String get mnemonicBackupFlowProcess3;

  /// No description provided for @mnemonicBackupFlowYourMnemonicTitle.
  ///
  /// In en, this message translates to:
  /// **'Your recovery phrase'**
  String get mnemonicBackupFlowYourMnemonicTitle;

  /// No description provided for @mnemonicBackupFlowYourMnemonicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write down every word in order and keep it safe'**
  String get mnemonicBackupFlowYourMnemonicSubtitle;

  /// No description provided for @mnemonicBackupFlowWordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String mnemonicBackupFlowWordCount(int count);

  /// No description provided for @mnemonicBackupFlowPleaseNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Please note'**
  String get mnemonicBackupFlowPleaseNoteTitle;

  /// No description provided for @mnemonicBackupFlowStep2NoteBody.
  ///
  /// In en, this message translates to:
  /// **'We recommend writing your recovery phrase on paper instead of screenshots or copying to connected devices. Tap the eye icon to show or hide the words.'**
  String get mnemonicBackupFlowStep2NoteBody;

  /// No description provided for @mnemonicBackupFlowVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify recovery phrase'**
  String get mnemonicBackupFlowVerifyTitle;

  /// No description provided for @mnemonicBackupFlowVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the correct words to confirm you backed them up correctly'**
  String get mnemonicBackupFlowVerifySubtitle;

  /// No description provided for @mnemonicBackupFlowVerifyWordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which word is in position {position}?'**
  String mnemonicBackupFlowVerifyWordQuestion(int position);

  /// No description provided for @mnemonicBackupFlowVerifySuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified!'**
  String get mnemonicBackupFlowVerifySuccessTitle;

  /// No description provided for @mnemonicBackupFlowVerifySuccessBody.
  ///
  /// In en, this message translates to:
  /// **'You have backed up your recovery phrase correctly'**
  String get mnemonicBackupFlowVerifySuccessBody;

  /// No description provided for @mnemonicBackupFlowDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup complete!'**
  String get mnemonicBackupFlowDoneTitle;

  /// No description provided for @mnemonicBackupFlowDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recovery phrase is backed up safely'**
  String get mnemonicBackupFlowDoneSubtitle;

  /// No description provided for @mnemonicBackupFlowDoneSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get mnemonicBackupFlowDoneSectionTitle;

  /// No description provided for @mnemonicBackupFlowDoneCheck1.
  ///
  /// In en, this message translates to:
  /// **'Viewed and wrote down the recovery phrase'**
  String get mnemonicBackupFlowDoneCheck1;

  /// No description provided for @mnemonicBackupFlowDoneCheck2.
  ///
  /// In en, this message translates to:
  /// **'Passed the verification'**
  String get mnemonicBackupFlowDoneCheck2;

  /// No description provided for @mnemonicBackupFlowDoneCheck3.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase stored securely'**
  String get mnemonicBackupFlowDoneCheck3;

  /// No description provided for @mnemonicBackupFlowDoneSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security reminder'**
  String get mnemonicBackupFlowDoneSecurityTitle;

  /// No description provided for @mnemonicBackupFlowDoneSecurity1.
  ///
  /// In en, this message translates to:
  /// **'Keep the recovery phrase in a safe physical place'**
  String get mnemonicBackupFlowDoneSecurity1;

  /// No description provided for @mnemonicBackupFlowDoneSecurity2.
  ///
  /// In en, this message translates to:
  /// **'Never reveal your recovery phrase to anyone'**
  String get mnemonicBackupFlowDoneSecurity2;

  /// No description provided for @mnemonicBackupFlowDoneSecurity3.
  ///
  /// In en, this message translates to:
  /// **'Official staff will never ask for your recovery phrase'**
  String get mnemonicBackupFlowDoneSecurity3;

  /// No description provided for @mnemonicBackupFlowDoneSecurity4.
  ///
  /// In en, this message translates to:
  /// **'Check periodically that your backup is intact and readable'**
  String get mnemonicBackupFlowDoneSecurity4;

  /// No description provided for @mnemonicBackupFlowFinalEncouragementTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re ready to use your note account!'**
  String get mnemonicBackupFlowFinalEncouragementTitle;

  /// No description provided for @mnemonicBackupFlowFinalEncouragementBody.
  ///
  /// In en, this message translates to:
  /// **'Your notes are protected by your recovery phrase'**
  String get mnemonicBackupFlowFinalEncouragementBody;

  /// No description provided for @switchWallet.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchWallet;

  /// No description provided for @viewAddresses.
  ///
  /// In en, this message translates to:
  /// **'View Addresses'**
  String get viewAddresses;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @createWallet.
  ///
  /// In en, this message translates to:
  /// **'Create Note account'**
  String get createWallet;

  /// No description provided for @importWallet.
  ///
  /// In en, this message translates to:
  /// **'Restore Note account'**
  String get importWallet;

  /// No description provided for @mnemonicOrPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase or security key'**
  String get mnemonicOrPrivateKey;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @mnemonicCopied.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase copied'**
  String get mnemonicCopied;

  /// No description provided for @privateKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Security key copied'**
  String get privateKeyCopied;

  /// No description provided for @backedUp.
  ///
  /// In en, this message translates to:
  /// **'Backed Up'**
  String get backedUp;

  /// No description provided for @editWalletName.
  ///
  /// In en, this message translates to:
  /// **'Edit Note account Name'**
  String get editWalletName;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete Note account'**
  String get deleteWallet;

  /// No description provided for @confirmDeleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete Note account'**
  String get confirmDeleteWallet;

  /// No description provided for @newWalletCreated.
  ///
  /// In en, this message translates to:
  /// **'New note account created'**
  String get newWalletCreated;

  /// No description provided for @cannotDeleteCurrentWallet.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the note account in use'**
  String get cannotDeleteCurrentWallet;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @createNewWallet.
  ///
  /// In en, this message translates to:
  /// **'Create New Note account'**
  String get createNewWallet;

  /// No description provided for @editWalletNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Note account Name'**
  String get editWalletNameTitle;

  /// No description provided for @noteNotFoundBack.
  ///
  /// In en, this message translates to:
  /// **'Note not found, go back'**
  String get noteNotFoundBack;

  /// No description provided for @createNoteNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Create note (not implemented)'**
  String get createNoteNotImplemented;

  /// No description provided for @newWalletCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'New note account created successfully!'**
  String get newWalletCreateSuccess;

  /// No description provided for @restoringFromProvider.
  ///
  /// In en, this message translates to:
  /// **'Restoring from {provider}...'**
  String restoringFromProvider(String provider);

  /// No description provided for @restoredFromProvider.
  ///
  /// In en, this message translates to:
  /// **'Restored from {provider}!'**
  String restoredFromProvider(String provider);

  /// No description provided for @noBackupFoundProvider.
  ///
  /// In en, this message translates to:
  /// **'No {provider} backup found, try another way'**
  String noBackupFoundProvider(String provider);

  /// No description provided for @walletAddressCopiedShort.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get walletAddressCopiedShort;

  /// No description provided for @switchedToChain.
  ///
  /// In en, this message translates to:
  /// **'Switched to {chain}'**
  String switchedToChain(String chain);

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFields;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two new passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangeSuccess;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get verificationCodeSent;

  /// No description provided for @enterSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code'**
  String get enterSixDigitCode;

  /// No description provided for @emailBindSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email bound successfully'**
  String get emailBindSuccess;

  /// No description provided for @emailUnbound.
  ///
  /// In en, this message translates to:
  /// **'Email unbound'**
  String get emailUnbound;

  /// No description provided for @logoutNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Logout (not connected)'**
  String get logoutNotConnected;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @bindEmail.
  ///
  /// In en, this message translates to:
  /// **'Bind Email'**
  String get bindEmail;

  /// No description provided for @editNoteOpenByRoute.
  ///
  /// In en, this message translates to:
  /// **'Please open edit page via route'**
  String get editNoteOpenByRoute;

  /// No description provided for @imageUploadNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Image upload not connected to storage'**
  String get imageUploadNotConnected;

  /// No description provided for @imageRemoved.
  ///
  /// In en, this message translates to:
  /// **'Image removed'**
  String get imageRemoved;

  /// No description provided for @titleContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Title and content are required'**
  String get titleContentRequired;

  /// No description provided for @submittedToChain.
  ///
  /// In en, this message translates to:
  /// **'Submitted to chain'**
  String get submittedToChain;

  /// No description provided for @onChainNoteCannotChangeType.
  ///
  /// In en, this message translates to:
  /// **'On-chain notes cannot change type'**
  String get onChainNoteCannotChangeType;

  /// No description provided for @setToLocalNote.
  ///
  /// In en, this message translates to:
  /// **'Set as local note (will not be on chain)'**
  String get setToLocalNote;

  /// No description provided for @setToDraft.
  ///
  /// In en, this message translates to:
  /// **'Set as draft'**
  String get setToDraft;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @noteDetailEditDisabledOnChain.
  ///
  /// In en, this message translates to:
  /// **'On-chain notes cannot be edited'**
  String get noteDetailEditDisabledOnChain;

  /// No description provided for @noteTypeDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get noteTypeDraft;

  /// No description provided for @noteTypeLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get noteTypeLocal;

  /// No description provided for @noteTypeOnChain.
  ///
  /// In en, this message translates to:
  /// **'On Chain'**
  String get noteTypeOnChain;

  /// No description provided for @blockchainVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify on Blockchain'**
  String get blockchainVerify;

  /// No description provided for @blockchainVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Blockchain Verification'**
  String get blockchainVerifyTitle;

  /// No description provided for @getGas.
  ///
  /// In en, this message translates to:
  /// **'Get {symbol} Gas'**
  String getGas(String symbol);

  /// No description provided for @addressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get addressCopied;

  /// No description provided for @redirectingToFaucet.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to faucet...'**
  String get redirectingToFaucet;

  /// No description provided for @noFaucetForNetwork.
  ///
  /// In en, this message translates to:
  /// **'No faucet for this network'**
  String get noFaucetForNetwork;

  /// No description provided for @loginNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Login not implemented'**
  String get loginNotImplemented;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Forgot password not implemented'**
  String get forgotPasswordNotImplemented;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No note account yet?'**
  String get noAccountYet;

  /// No description provided for @registerNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Register not implemented'**
  String get registerNotImplemented;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @mnemonicVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase verified, import logic handled externally'**
  String get mnemonicVerifySuccess;

  /// No description provided for @privateKeyVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Security key verified, import logic handled externally'**
  String get privateKeyVerifySuccess;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore successful!'**
  String get importSuccess;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get imported;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultBadge;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get searchNotesHint;

  /// No description provided for @noMatchNotes.
  ///
  /// In en, this message translates to:
  /// **'No matching notes'**
  String get noMatchNotes;

  /// No description provided for @noOnChainNotes.
  ///
  /// In en, this message translates to:
  /// **'No on-chain notes yet'**
  String get noOnChainNotes;

  /// No description provided for @noOffChainNotes.
  ///
  /// In en, this message translates to:
  /// **'No off-chain notes yet'**
  String get noOffChainNotes;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get noNotes;

  /// No description provided for @tryOtherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords'**
  String get tryOtherSearch;

  /// No description provided for @startCreateFirstNote.
  ///
  /// In en, this message translates to:
  /// **'Create your first note'**
  String get startCreateFirstNote;

  /// No description provided for @profileNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get profileNotConnected;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Note account'**
  String get profileSectionAccount;

  /// No description provided for @profileNetworkSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure RPC & nodes'**
  String get profileNetworkSettingsSubtitle;

  /// No description provided for @profileSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSectionSecurity;

  /// No description provided for @profileChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your note account'**
  String get profileChangePasswordSubtitle;

  /// No description provided for @profileBindEmailNotBound.
  ///
  /// In en, this message translates to:
  /// **'Not bound'**
  String get profileBindEmailNotBound;

  /// No description provided for @profileBindEmailBadgeBound.
  ///
  /// In en, this message translates to:
  /// **'Bound'**
  String get profileBindEmailBadgeBound;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileSectionPreferences;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get profileDarkMode;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileSectionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get profileSectionMore;

  /// No description provided for @profileTestPage.
  ///
  /// In en, this message translates to:
  /// **'Test page'**
  String get profileTestPage;

  /// No description provided for @profileTestPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feature test entry'**
  String get profileTestPageSubtitle;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get profileTerms;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacy;

  /// No description provided for @profileRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get profileRateUs;

  /// No description provided for @profileShare.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get profileShare;

  /// No description provided for @profileShareMessage.
  ///
  /// In en, this message translates to:
  /// **'I\'m using On Chain Notes — an on-chain notes app I like. Check it out:\n{url}'**
  String profileShareMessage(String url);

  /// No description provided for @profileLogoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutLabel;

  /// No description provided for @profileLogoutPending.
  ///
  /// In en, this message translates to:
  /// **'Logout (coming soon)'**
  String get profileLogoutPending;

  /// No description provided for @profilePageFooter.
  ///
  /// In en, this message translates to:
  /// **'{appTitle} v{version}\n© {year} All rights reserved.'**
  String profilePageFooter(String appTitle, String version, String year);

  /// No description provided for @profileAvatarFallback.
  ///
  /// In en, this message translates to:
  /// **'ME'**
  String get profileAvatarFallback;

  /// No description provided for @profileDefaultWalletName.
  ///
  /// In en, this message translates to:
  /// **'My note account'**
  String get profileDefaultWalletName;

  /// No description provided for @profileUserActive.
  ///
  /// In en, this message translates to:
  /// **'Active user'**
  String get profileUserActive;

  /// No description provided for @profileUserNormal.
  ///
  /// In en, this message translates to:
  /// **'Standard user'**
  String get profileUserNormal;

  /// No description provided for @profileStatNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get profileStatNotes;

  /// No description provided for @profileStatOnChain.
  ///
  /// In en, this message translates to:
  /// **'On-chain'**
  String get profileStatOnChain;

  /// No description provided for @profileStatDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get profileStatDays;

  /// No description provided for @profileBindEmailDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and verification code.'**
  String get profileBindEmailDialogSubtitle;

  /// No description provided for @profileBindEmailFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get profileBindEmailFieldEmail;

  /// No description provided for @profileBindEmailFieldCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get profileBindEmailFieldCode;

  /// No description provided for @profileSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get profileSendVerificationCode;

  /// No description provided for @profileResendCodeInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String profileResendCodeInSeconds(int seconds);

  /// No description provided for @profileUnbindEmail.
  ///
  /// In en, this message translates to:
  /// **'Unbind email'**
  String get profileUnbindEmail;

  /// No description provided for @languageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectTitle;

  /// No description provided for @languageSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get languageSelectSubtitle;

  /// No description provided for @languageNoticeHint.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get languageNoticeHint;

  /// No description provided for @languageNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese, Traditional Chinese, English, Japanese, and Korean are supported; more languages coming soon.'**
  String get languageNoticeBody;

  /// No description provided for @languageCurrentBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get languageCurrentBadge;

  /// No description provided for @languageSnackbarComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get languageSnackbarComingSoon;

  /// No description provided for @languageSwitchedTo.
  ///
  /// In en, this message translates to:
  /// **'Switched to {name}'**
  String languageSwitchedTo(String name);

  /// No description provided for @languageFooterMore.
  ///
  /// In en, this message translates to:
  /// **'More languages coming soon'**
  String get languageFooterMore;

  /// No description provided for @changePasswordSameAsOld.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the old password'**
  String get changePasswordSameAsOld;

  /// No description provided for @changePasswordLength632.
  ///
  /// In en, this message translates to:
  /// **'New password must be 6–32 characters'**
  String get changePasswordLength632;

  /// No description provided for @walletNoSavedKey.
  ///
  /// In en, this message translates to:
  /// **'No saved key found. Create an note account first.'**
  String get walletNoSavedKey;

  /// No description provided for @changePasswordWrongOrFailed.
  ///
  /// In en, this message translates to:
  /// **'Wrong old password or operation failed'**
  String get changePasswordWrongOrFailed;

  /// No description provided for @passwordMaxLength32.
  ///
  /// In en, this message translates to:
  /// **'Password must be at most 32 characters'**
  String get passwordMaxLength32;

  /// No description provided for @passwordMeetAllRequirements.
  ///
  /// In en, this message translates to:
  /// **'Please meet all password requirements'**
  String get passwordMeetAllRequirements;

  /// No description provided for @encryptionInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Encryption init failed: {error}'**
  String encryptionInitFailed(String error);

  /// No description provided for @passwordVerifyForgotGoReset.
  ///
  /// In en, this message translates to:
  /// **'Forgot password? Reset'**
  String get passwordVerifyForgotGoReset;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @changePasswordPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordPageTitle;

  /// No description provided for @changePasswordPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your note account'**
  String get changePasswordPageSubtitle;

  /// No description provided for @changePasswordSecurityHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Security tips'**
  String get changePasswordSecurityHintTitle;

  /// No description provided for @changePasswordSecurityHintBody.
  ///
  /// In en, this message translates to:
  /// **'• Change your password regularly\n• Use a strong password with letters and numbers\n• Avoid birthdays or phone numbers'**
  String get changePasswordSecurityHintBody;

  /// No description provided for @changePasswordOldLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get changePasswordOldLabel;

  /// No description provided for @changePasswordOldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get changePasswordOldHint;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordNewHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get changePasswordNewHint;

  /// No description provided for @changePasswordStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Password strength:'**
  String get changePasswordStrengthLabel;

  /// No description provided for @changePasswordMatchOk.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get changePasswordMatchOk;

  /// No description provided for @changePasswordMatchBad.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMatchBad;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password again'**
  String get changePasswordConfirmHint;

  /// No description provided for @changePasswordRuleLength.
  ///
  /// In en, this message translates to:
  /// **'6–32 characters'**
  String get changePasswordRuleLength;

  /// No description provided for @changePasswordRuleCase.
  ///
  /// In en, this message translates to:
  /// **'Upper & lower case letters'**
  String get changePasswordRuleCase;

  /// No description provided for @changePasswordRuleDigit.
  ///
  /// In en, this message translates to:
  /// **'Include a number'**
  String get changePasswordRuleDigit;

  /// No description provided for @changePasswordClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get changePasswordClear;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm change'**
  String get changePasswordSubmit;

  /// No description provided for @validatorOldPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get validatorOldPasswordRequired;

  /// No description provided for @validatorNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get validatorNewPasswordRequired;

  /// No description provided for @validatorNewPasswordMin6.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get validatorNewPasswordMin6;

  /// No description provided for @validatorNewPasswordMax32.
  ///
  /// In en, this message translates to:
  /// **'At most 32 characters'**
  String get validatorNewPasswordMax32;

  /// No description provided for @validatorConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get validatorConfirmRequired;

  /// No description provided for @validatorConfirmMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validatorConfirmMismatch;

  /// No description provided for @changePasswordRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Password requirements'**
  String get changePasswordRulesTitle;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your note account'**
  String get loginSubtitle;

  /// No description provided for @loginEmailOrUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get loginEmailOrUsernameLabel;

  /// No description provided for @loginEmailOrUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email or username'**
  String get loginEmailOrUsernameHint;

  /// No description provided for @validatorLoginIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter email or username'**
  String get validatorLoginIdRequired;

  /// No description provided for @loginPasswordFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordFieldLabel;

  /// No description provided for @loginPasswordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordFieldHint;

  /// No description provided for @validatorLoginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get validatorLoginPasswordRequired;

  /// No description provided for @validatorLoginPasswordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validatorLoginPasswordMin6;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @createWalletPasswordPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Set note account password'**
  String get createWalletPasswordPageTitle;

  /// No description provided for @createWalletPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your notes'**
  String get createWalletPasswordSubtitle;

  /// No description provided for @createWalletPasswordWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why a password?'**
  String get createWalletPasswordWhyTitle;

  /// No description provided for @createWalletPasswordWhyBody.
  ///
  /// In en, this message translates to:
  /// **'Your note account password encrypts security keys and recovery phrases so only you can access your notes. Remember it — it cannot be recovered if lost.'**
  String get createWalletPasswordWhyBody;

  /// No description provided for @walletPasswordFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Note account password'**
  String get walletPasswordFieldLabel;

  /// No description provided for @walletPasswordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6–32 characters'**
  String get walletPasswordFieldHint;

  /// No description provided for @walletConfirmPasswordFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get walletConfirmPasswordFieldLabel;

  /// No description provided for @walletConfirmPasswordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password again'**
  String get walletConfirmPasswordFieldHint;

  /// No description provided for @walletPasswordImportantNotice.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get walletPasswordImportantNotice;

  /// No description provided for @walletPasswordWarnBullets.
  ///
  /// In en, this message translates to:
  /// **'• The password protects your note account\n• Use something memorable but hard to guess\n• Mix letters, numbers, and symbols\n• If lost, it cannot be recovered — remember it'**
  String get walletPasswordWarnBullets;

  /// No description provided for @createWalletPasswordSubmitCreate.
  ///
  /// In en, this message translates to:
  /// **'Confirm and create note account'**
  String get createWalletPasswordSubmitCreate;

  /// No description provided for @createWalletPasswordSubmitReset.
  ///
  /// In en, this message translates to:
  /// **'Confirm and reset password'**
  String get createWalletPasswordSubmitReset;

  /// No description provided for @createWalletPasswordFooterAck.
  ///
  /// In en, this message translates to:
  /// **'By confirming you understand how important your password is'**
  String get createWalletPasswordFooterAck;

  /// No description provided for @walletPasswordRulesHeader.
  ///
  /// In en, this message translates to:
  /// **'Requirements:'**
  String get walletPasswordRulesHeader;

  /// No description provided for @walletPasswordRuleLength632.
  ///
  /// In en, this message translates to:
  /// **'6–32 characters'**
  String get walletPasswordRuleLength632;

  /// No description provided for @walletPasswordRuleLetter.
  ///
  /// In en, this message translates to:
  /// **'Contains letters'**
  String get walletPasswordRuleLetter;

  /// No description provided for @walletPasswordRuleNumberRecommended.
  ///
  /// In en, this message translates to:
  /// **'Contains numbers (recommended)'**
  String get walletPasswordRuleNumberRecommended;

  /// No description provided for @walletPasswordRuleMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get walletPasswordRuleMatch;

  /// No description provided for @walletBootstrapImporting.
  ///
  /// In en, this message translates to:
  /// **'Restoring note account...'**
  String get walletBootstrapImporting;

  /// No description provided for @walletBootstrapInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing note account...'**
  String get walletBootstrapInitializing;

  /// No description provided for @passwordVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify password'**
  String get passwordVerifyTitle;

  /// No description provided for @passwordVerifyDescription.
  ///
  /// In en, this message translates to:
  /// **'For your security, enter your note account password to continue.'**
  String get passwordVerifyDescription;

  /// No description provided for @passwordVerifyDescExportMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before viewing and exporting the recovery phrase.'**
  String get passwordVerifyDescExportMnemonic;

  /// No description provided for @passwordVerifyDescExportPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before viewing your security key.'**
  String get passwordVerifyDescExportPrivateKey;

  /// No description provided for @passwordVerifyDescImportWallet.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before restoring the note account.'**
  String get passwordVerifyDescImportWallet;

  /// No description provided for @passwordVerifyDescBackupMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before backing up the recovery phrase.'**
  String get passwordVerifyDescBackupMnemonic;

  /// No description provided for @passwordVerifyDescCreateWallet.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before creating an note account.'**
  String get passwordVerifyDescCreateWallet;

  /// No description provided for @passwordVerifyDescDeleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password before deleting the note account.'**
  String get passwordVerifyDescDeleteWallet;

  /// No description provided for @passwordVerifyDescMintNft.
  ///
  /// In en, this message translates to:
  /// **'Enter your note account password to mint an NFT.'**
  String get passwordVerifyDescMintNft;

  /// No description provided for @passwordVerifyWalletPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Note account password'**
  String get passwordVerifyWalletPasswordLabel;

  /// No description provided for @passwordVerifyWalletPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note account password'**
  String get passwordVerifyWalletPasswordHint;

  /// No description provided for @validatorWalletPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get validatorWalletPasswordRequired;

  /// No description provided for @passwordVerifyNoEncryptedData.
  ///
  /// In en, this message translates to:
  /// **'No encrypted data found. Set your password again.'**
  String get passwordVerifyNoEncryptedData;

  /// No description provided for @passwordVerifyFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Verification failed: {error}'**
  String passwordVerifyFailedWithError(String error);

  /// No description provided for @passwordVerifyLockoutMinutes.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {minutes} minutes.'**
  String passwordVerifyLockoutMinutes(int minutes);

  /// No description provided for @passwordVerifyLockoutHours.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {hours} hours.'**
  String passwordVerifyLockoutHours(int hours);

  /// No description provided for @passwordVerifyWrongWithCount.
  ///
  /// In en, this message translates to:
  /// **'Wrong password ({current}/{max})'**
  String passwordVerifyWrongWithCount(int current, int max);

  /// No description provided for @passwordVerifyAttemptsBanner.
  ///
  /// In en, this message translates to:
  /// **'Wrong {count} time(s). {remaining} attempt(s) left.'**
  String passwordVerifyAttemptsBanner(int count, int remaining);

  /// No description provided for @passwordVerifyLockBanner.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again after {time}.'**
  String passwordVerifyLockBanner(String time);

  /// No description provided for @passwordVerifyDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} m'**
  String passwordVerifyDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @passwordVerifyDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String passwordVerifyDurationMinutes(int minutes);

  /// No description provided for @passwordVerifySecurityTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Security tips'**
  String get passwordVerifySecurityTipsTitle;

  /// No description provided for @passwordVerifySecurityTipsBody.
  ///
  /// In en, this message translates to:
  /// **'• Password length 6–32\n• Ensure your surroundings are safe\n• {maxAttempts} wrong attempts will temporarily lock'**
  String passwordVerifySecurityTipsBody(int maxAttempts);

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @loadingDefault.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingDefault;

  /// No description provided for @walletLoadingTagline.
  ///
  /// In en, this message translates to:
  /// **'BlockNote · Secure · Trusted · Permanent'**
  String get walletLoadingTagline;

  /// No description provided for @walletLoadingStepConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the network…'**
  String get walletLoadingStepConnecting;

  /// No description provided for @walletLoadingStepVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying note account…'**
  String get walletLoadingStepVerifying;

  /// No description provided for @walletLoadingStepSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing your notes…'**
  String get walletLoadingStepSyncing;

  /// No description provided for @walletLoadingStepComplete.
  ///
  /// In en, this message translates to:
  /// **'Almost done…'**
  String get walletLoadingStepComplete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Load failed: {error}'**
  String loadFailedWithError(String error);

  /// No description provided for @selectEvmChainFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an EVM-supported network first'**
  String get selectEvmChainFirst;

  /// No description provided for @noteNotFoundShort.
  ///
  /// In en, this message translates to:
  /// **'Note not found'**
  String get noteNotFoundShort;

  /// No description provided for @createOrSelectWalletFirst.
  ///
  /// In en, this message translates to:
  /// **'Please create or select an note account first'**
  String get createOrSelectWalletFirst;

  /// No description provided for @privateKeyDecryptFailedHint.
  ///
  /// In en, this message translates to:
  /// **'Could not get security key. Check your password. If you changed it, re-enter your recovery phrase.'**
  String get privateKeyDecryptFailedHint;

  /// No description provided for @uploadingIpfsAndMinting.
  ///
  /// In en, this message translates to:
  /// **'Uploading to IPFS and minting…'**
  String get uploadingIpfsAndMinting;

  /// No description provided for @ipfsFileUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'IPFS file upload failed: {details}'**
  String ipfsFileUploadFailed(String details);

  /// No description provided for @onChainSuccessTx.
  ///
  /// In en, this message translates to:
  /// **'On-chain success: {txHash}'**
  String onChainSuccessTx(String txHash);

  /// No description provided for @draftSavedIpfsRetry.
  ///
  /// In en, this message translates to:
  /// **'Saved as draft with IPFS images. You can retry publishing anytime.'**
  String get draftSavedIpfsRetry;

  /// No description provided for @mintFailedGasDebug.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance (gas)\n{detail}'**
  String mintFailedGasDebug(String detail);

  /// No description provided for @mintFailedGasUser.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance for gas. Add funds and try again.'**
  String get mintFailedGasUser;

  /// No description provided for @mintFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Publish failed: {error}'**
  String mintFailedGeneric(String error);

  /// No description provided for @walletErrNoWalletYet.
  ///
  /// In en, this message translates to:
  /// **'Create or restore an note account first'**
  String get walletErrNoWalletYet;

  /// No description provided for @walletErrUnrecognizedAccount.
  ///
  /// In en, this message translates to:
  /// **'Cannot recognize the current note account'**
  String get walletErrUnrecognizedAccount;

  /// No description provided for @walletErrWalletDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Note account data not found'**
  String get walletErrWalletDataNotFound;

  /// No description provided for @walletErrImportedMnemonicNoExport.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase-imported note accounts cannot export the recovery phrase here again'**
  String get walletErrImportedMnemonicNoExport;

  /// No description provided for @walletErrImportedMnemonicNoBackup.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase-imported note accounts do not need backup here'**
  String get walletErrImportedMnemonicNoBackup;

  /// No description provided for @walletErrPrivateKeyWalletNoMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Security key–imported note accounts have no recovery phrase'**
  String get walletErrPrivateKeyWalletNoMnemonic;

  /// No description provided for @walletErrNoEncryptedMnemonic.
  ///
  /// In en, this message translates to:
  /// **'No locally encrypted recovery phrase for this note account'**
  String get walletErrNoEncryptedMnemonic;

  /// No description provided for @walletErrDecryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Decryption failed. Check your password'**
  String get walletErrDecryptFailed;

  /// No description provided for @walletErrMissingAddress.
  ///
  /// In en, this message translates to:
  /// **'Missing note account address'**
  String get walletErrMissingAddress;

  /// No description provided for @walletErrGetPrivateKeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not get security key. Check your password'**
  String get walletErrGetPrivateKeyFailed;

  /// No description provided for @exportMnemonicDocTitle.
  ///
  /// In en, this message translates to:
  /// **'On Chain Notes — Recovery phrase backup'**
  String get exportMnemonicDocTitle;

  /// No description provided for @exportMnemonicDocTime.
  ///
  /// In en, this message translates to:
  /// **'Generated: {time}'**
  String exportMnemonicDocTime(String time);

  /// No description provided for @exportMnemonicDocLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase (keep safe):'**
  String get exportMnemonicDocLabel;

  /// No description provided for @exportMnemonicDocSecurity.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Security tips:\n1. Store this recovery phrase in a safe place\n2. Never share it with anyone\n3. If lost, your note account cannot be recovered'**
  String get exportMnemonicDocSecurity;

  /// No description provided for @exportMnemonicUseCopyOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'Please use Copy on this platform'**
  String get exportMnemonicUseCopyOnPlatform;

  /// No description provided for @exportMnemonicSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved: {path}'**
  String exportMnemonicSavedTo(String path);

  /// No description provided for @walletBootstrapCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating note account…'**
  String get walletBootstrapCreating;

  /// No description provided for @chainNameEvm.
  ///
  /// In en, this message translates to:
  /// **'EVM (Ethereum / BSC / Polygon, etc.)'**
  String get chainNameEvm;

  /// No description provided for @chainPkDescEvm.
  ///
  /// In en, this message translates to:
  /// **'64 hexadecimal characters with 0x prefix, 66 characters total'**
  String get chainPkDescEvm;

  /// No description provided for @chainNameBitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get chainNameBitcoin;

  /// No description provided for @chainPkDescBitcoin.
  ///
  /// In en, this message translates to:
  /// **'WIF format, starts with 5, K, or L, 51–52 characters'**
  String get chainPkDescBitcoin;

  /// No description provided for @chainNameSolana.
  ///
  /// In en, this message translates to:
  /// **'Solana'**
  String get chainNameSolana;

  /// No description provided for @chainPkDescSolana.
  ///
  /// In en, this message translates to:
  /// **'Base58, about 87–88 characters, no 0, O, I, or l'**
  String get chainPkDescSolana;

  /// No description provided for @chainNameTron.
  ///
  /// In en, this message translates to:
  /// **'Tron'**
  String get chainNameTron;

  /// No description provided for @chainPkDescTronHex.
  ///
  /// In en, this message translates to:
  /// **'64 hexadecimal characters (no 0x prefix)'**
  String get chainPkDescTronHex;

  /// No description provided for @chainNameCosmos.
  ///
  /// In en, this message translates to:
  /// **'Cosmos'**
  String get chainNameCosmos;

  /// No description provided for @chainPkDescCosmosHex.
  ///
  /// In en, this message translates to:
  /// **'64 hexadecimal characters (no 0x prefix)'**
  String get chainPkDescCosmosHex;

  /// No description provided for @walletPkSubtitleLength.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String walletPkSubtitleLength(int count);

  /// No description provided for @walletPkSubtitleStartsWith.
  ///
  /// In en, this message translates to:
  /// **'Starts with {prefix}'**
  String walletPkSubtitleStartsWith(String prefix);

  /// No description provided for @walletImportSelectChainTitle.
  ///
  /// In en, this message translates to:
  /// **'Select blockchain type'**
  String get walletImportSelectChainTitle;

  /// No description provided for @walletImportEvmOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'Not supported yet. Use EVM security key import.'**
  String get walletImportEvmOnlyNotice;

  /// No description provided for @walletImportPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your note account with a recovery phrase or security key'**
  String get walletImportPageSubtitle;

  /// No description provided for @walletImportTabMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase'**
  String get walletImportTabMnemonic;

  /// No description provided for @walletImportTabPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Security key'**
  String get walletImportTabPrivateKey;

  /// No description provided for @walletImportInputMethod.
  ///
  /// In en, this message translates to:
  /// **'Input method'**
  String get walletImportInputMethod;

  /// No description provided for @walletImportInputSingle.
  ///
  /// In en, this message translates to:
  /// **'Word by word'**
  String get walletImportInputSingle;

  /// No description provided for @walletImportInputPasteFull.
  ///
  /// In en, this message translates to:
  /// **'Paste full phrase'**
  String get walletImportInputPasteFull;

  /// No description provided for @walletImportWordCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase length'**
  String get walletImportWordCountLabel;

  /// No description provided for @walletImportWordCountN.
  ///
  /// In en, this message translates to:
  /// **'{n} words'**
  String walletImportWordCountN(int n);

  /// No description provided for @walletImportWordCountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Select mnemonic length'**
  String get walletImportWordCountDialogTitle;

  /// No description provided for @walletImportWordCountDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'BIP39 supports several mnemonic lengths; security increases with more words.'**
  String get walletImportWordCountDialogDesc;

  /// No description provided for @walletImportWordCountOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String walletImportWordCountOptionLabel(int count);

  /// No description provided for @walletImportWordCountSecurityLabel.
  ///
  /// In en, this message translates to:
  /// **'Security: '**
  String get walletImportWordCountSecurityLabel;

  /// No description provided for @walletImportWordCountSecurityStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get walletImportWordCountSecurityStandard;

  /// No description provided for @walletImportWordCountSecurityEnhanced.
  ///
  /// In en, this message translates to:
  /// **'Enhanced'**
  String get walletImportWordCountSecurityEnhanced;

  /// No description provided for @walletImportWordCountSecurityAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get walletImportWordCountSecurityAdvanced;

  /// No description provided for @walletImportWordCountSecurityProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get walletImportWordCountSecurityProfessional;

  /// No description provided for @walletImportWordCountSecurityMaximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get walletImportWordCountSecurityMaximum;

  /// No description provided for @walletImportWordCountSwitched.
  ///
  /// In en, this message translates to:
  /// **'Switched to {n} words'**
  String walletImportWordCountSwitched(int n);

  /// No description provided for @walletImportWordCountDialogTip.
  ///
  /// In en, this message translates to:
  /// **'Most wallets use 12 words. If you are unsure, choose 12 words.'**
  String get walletImportWordCountDialogTip;

  /// No description provided for @walletImportEnterMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Enter recovery phrase'**
  String get walletImportEnterMnemonic;

  /// No description provided for @walletImportMnemonicPasteTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: you can paste the full phrase; use “Paste full phrase” above'**
  String get walletImportMnemonicPasteTip;

  /// No description provided for @walletImportPasteMnemonicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Paste your recovery phrase'**
  String get walletImportPasteMnemonicPrompt;

  /// No description provided for @walletImportMnemonicHintWords.
  ///
  /// In en, this message translates to:
  /// **'Paste your {count} words separated by spaces'**
  String walletImportMnemonicHintWords(int count);

  /// No description provided for @walletImportMnemonicWordFieldHint.
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get walletImportMnemonicWordFieldHint;

  /// No description provided for @walletImportMnemonicParagraphExampleHint.
  ///
  /// In en, this message translates to:
  /// **'word1 word2 word3 ...'**
  String get walletImportMnemonicParagraphExampleHint;

  /// No description provided for @walletImportPrivateKeyFieldHint.
  ///
  /// In en, this message translates to:
  /// **'0x... or 64 hex characters'**
  String get walletImportPrivateKeyFieldHint;

  /// No description provided for @walletImportPrivateKeyFieldHintShort.
  ///
  /// In en, this message translates to:
  /// **'0x...'**
  String get walletImportPrivateKeyFieldHintShort;

  /// No description provided for @walletImportWordProgress.
  ///
  /// In en, this message translates to:
  /// **'Current words: {current} / {total}'**
  String walletImportWordProgress(int current, int total);

  /// No description provided for @walletImportMnemonicSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security tips'**
  String get walletImportMnemonicSecurityTitle;

  /// No description provided for @walletImportMnemonicSecurityBody.
  ///
  /// In en, this message translates to:
  /// **'• Use a secure network\n• If the recovery phrase is lost, it cannot be recovered\n• Never share your recovery phrase\n• We do not store your recovery phrase on servers'**
  String get walletImportMnemonicSecurityBody;

  /// No description provided for @walletImportSelectChainSection.
  ///
  /// In en, this message translates to:
  /// **'Select blockchain type'**
  String get walletImportSelectChainSection;

  /// No description provided for @walletImportTapSwitchChain.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch chain type'**
  String get walletImportTapSwitchChain;

  /// No description provided for @walletImportEnterPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Enter security key'**
  String get walletImportEnterPrivateKey;

  /// No description provided for @walletImportPkFormatExample.
  ///
  /// In en, this message translates to:
  /// **'Security key format example'**
  String get walletImportPkFormatExample;

  /// No description provided for @walletImportPkSevereTitle.
  ///
  /// In en, this message translates to:
  /// **'Critical warning'**
  String get walletImportPkSevereTitle;

  /// No description provided for @walletImportPkSevereBody.
  ///
  /// In en, this message translates to:
  /// **'• The security key grants full control of your note account\n• Anyone with it can fully manage your notes\n• Do not enter it on unsafe devices\n• Do not screenshot or send via chat apps'**
  String get walletImportPkSevereBody;

  /// No description provided for @walletImportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm restore'**
  String get walletImportConfirm;

  /// No description provided for @walletImportMnemonicNeedCount.
  ///
  /// In en, this message translates to:
  /// **'Enter all {count} recovery phrase words'**
  String walletImportMnemonicNeedCount(int count);

  /// No description provided for @walletImportMnemonicWrongCount.
  ///
  /// In en, this message translates to:
  /// **'Enter {count} words (currently {current})'**
  String walletImportMnemonicWrongCount(int count, int current);

  /// No description provided for @walletImportMnemonicInvalidWords.
  ///
  /// In en, this message translates to:
  /// **'Invalid recovery phrase words; use lowercase English words'**
  String get walletImportMnemonicInvalidWords;

  /// No description provided for @walletImportPkEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter security key'**
  String get walletImportPkEmpty;

  /// No description provided for @walletImportPkNeed0x.
  ///
  /// In en, this message translates to:
  /// **'Security key should start with 0x'**
  String get walletImportPkNeed0x;

  /// No description provided for @walletImportPkNeedWif.
  ///
  /// In en, this message translates to:
  /// **'Security key should start with 5, K, or L'**
  String get walletImportPkNeedWif;

  /// No description provided for @walletImportPkWifLength.
  ///
  /// In en, this message translates to:
  /// **'Security key length should be 51–52 characters'**
  String get walletImportPkWifLength;

  /// No description provided for @walletImportPkLengthExpected.
  ///
  /// In en, this message translates to:
  /// **'Security key length should be {length} characters'**
  String walletImportPkLengthExpected(int length);

  /// No description provided for @walletImportPkInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid security key format'**
  String get walletImportPkInvalidFormat;

  /// No description provided for @walletImportEvmOnly.
  ///
  /// In en, this message translates to:
  /// **'Only EVM security key import is supported'**
  String get walletImportEvmOnly;

  /// No description provided for @walletImportDeriveAddressFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not derive address from security key; check format'**
  String get walletImportDeriveAddressFailed;

  /// No description provided for @walletImportDuplicatePk.
  ///
  /// In en, this message translates to:
  /// **'This address already exists. Do not restore again'**
  String get walletImportDuplicatePk;

  /// No description provided for @walletImportDuplicateMnemonic.
  ///
  /// In en, this message translates to:
  /// **'This note account is already restored. Do not restore again'**
  String get walletImportDuplicateMnemonic;

  /// No description provided for @walletImportInvalidPrivateKeyRetry.
  ///
  /// In en, this message translates to:
  /// **'Invalid security key. Check and try again'**
  String get walletImportInvalidPrivateKeyRetry;

  /// No description provided for @walletImportInvalidMnemonicRetry.
  ///
  /// In en, this message translates to:
  /// **'Invalid recovery phrase. Check and try again'**
  String get walletImportInvalidMnemonicRetry;

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get clipboardEmpty;

  /// No description provided for @mnemonicViewLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase length'**
  String get mnemonicViewLengthTitle;

  /// No description provided for @mnemonicViewInputMode.
  ///
  /// In en, this message translates to:
  /// **'Input mode'**
  String get mnemonicViewInputMode;

  /// No description provided for @mnemonicViewSingleWord.
  ///
  /// In en, this message translates to:
  /// **'Word by word'**
  String get mnemonicViewSingleWord;

  /// No description provided for @mnemonicViewFullPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste paragraph'**
  String get mnemonicViewFullPaste;

  /// No description provided for @mnemonicViewImportCta.
  ///
  /// In en, this message translates to:
  /// **'Use recovery phrase'**
  String get mnemonicViewImportCta;

  /// No description provided for @mnemonicViewEnterOrdered.
  ///
  /// In en, this message translates to:
  /// **'Enter {count} words in order'**
  String mnemonicViewEnterOrdered(int count);

  /// No description provided for @mnemonicViewPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the full recovery phrase, words separated by spaces'**
  String get mnemonicViewPasteHint;

  /// No description provided for @mnemonicCountMismatch.
  ///
  /// In en, this message translates to:
  /// **'Enter {expected} words (currently {current})'**
  String mnemonicCountMismatch(int expected, int current);

  /// No description provided for @mnemonicInvalidBip39.
  ///
  /// In en, this message translates to:
  /// **'Invalid recovery phrase; check spelling'**
  String get mnemonicInvalidBip39;

  /// No description provided for @walletSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'My note accounts'**
  String get walletSelectorTitle;

  /// No description provided for @walletSelectorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage all your note accounts'**
  String get walletSelectorSubtitle;

  /// No description provided for @walletNumberedName.
  ///
  /// In en, this message translates to:
  /// **'Note account {n}'**
  String walletNumberedName(int n);

  /// No description provided for @walletDefaultCreatedNameFirst.
  ///
  /// In en, this message translates to:
  /// **'My Note account'**
  String get walletDefaultCreatedNameFirst;

  /// No description provided for @walletDefaultCreatedNameNumbered.
  ///
  /// In en, this message translates to:
  /// **'My Note account {n}'**
  String walletDefaultCreatedNameNumbered(int n);

  /// No description provided for @walletDefaultPrivateKeyNameFirst.
  ///
  /// In en, this message translates to:
  /// **'My security key note account'**
  String get walletDefaultPrivateKeyNameFirst;

  /// No description provided for @walletDefaultPrivateKeyNameNumbered.
  ///
  /// In en, this message translates to:
  /// **'My security key note account {n}'**
  String walletDefaultPrivateKeyNameNumbered(int n);

  /// No description provided for @walletBackupNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not backed up'**
  String get walletBackupNotYet;

  /// No description provided for @walletBackupPromptLine1.
  ///
  /// In en, this message translates to:
  /// **'Back up your note account'**
  String get walletBackupPromptLine1;

  /// No description provided for @walletBackupPromptLine2.
  ///
  /// In en, this message translates to:
  /// **'Tap to back up your recovery phrase now'**
  String get walletBackupPromptLine2;

  /// No description provided for @walletDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note account?'**
  String get walletDeleteConfirmTitle;

  /// No description provided for @walletDeleteConfirmLine1.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Make sure you have backed up your recovery phrase.'**
  String get walletDeleteConfirmLine1;

  /// No description provided for @walletDeleteConfirmLine2Notes.
  ///
  /// In en, this message translates to:
  /// **'Local notes linked to this note account will also be removed.'**
  String get walletDeleteConfirmLine2Notes;

  /// No description provided for @walletDeleteCannotCurrent.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the note account in use'**
  String get walletDeleteCannotCurrent;

  /// No description provided for @walletDeleteLastHint.
  ///
  /// In en, this message translates to:
  /// **'No note account will remain; you will return to onboarding to create or restore.'**
  String get walletDeleteLastHint;

  /// No description provided for @walletEditNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an easy-to-recognize name'**
  String get walletEditNameSubtitle;

  /// No description provided for @walletNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Note account name'**
  String get walletNameFieldLabel;

  /// No description provided for @walletNameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note account name'**
  String get walletNameFieldHint;

  /// No description provided for @networkNodeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add node'**
  String get networkNodeAdd;

  /// No description provided for @networkNodeTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get networkNodeTest;

  /// No description provided for @networkNodeSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get networkNodeSetDefault;

  /// No description provided for @networkNodeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get networkNodeOnline;

  /// No description provided for @networkNodeOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get networkNodeOffline;

  /// No description provided for @networkNodeConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Node connection failed'**
  String get networkNodeConnectionFailed;

  /// No description provided for @networkRpcUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTP or HTTPS RPC URL.'**
  String get networkRpcUrlInvalid;

  /// No description provided for @networkNodeDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This RPC URL is already in the list.'**
  String get networkNodeDuplicate;

  /// No description provided for @networkNodeNameRpcRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter node name and RPC URL'**
  String get networkNodeNameRpcRequired;

  /// No description provided for @networkNodeAdded.
  ///
  /// In en, this message translates to:
  /// **'Node added'**
  String get networkNodeAdded;

  /// No description provided for @networkRpcCopied.
  ///
  /// In en, this message translates to:
  /// **'RPC URL copied'**
  String get networkRpcCopied;

  /// No description provided for @networkNodeSwitched.
  ///
  /// In en, this message translates to:
  /// **'Switched to this node'**
  String get networkNodeSwitched;

  /// No description provided for @networkNodeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Node deleted'**
  String get networkNodeDeleted;

  /// No description provided for @networkSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Network settings'**
  String get networkSettingsTitle;

  /// No description provided for @networkSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure blockchain RPC nodes'**
  String get networkSettingsSubtitle;

  /// No description provided for @networkLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed: {message}'**
  String networkLoadFailed(String message);

  /// No description provided for @networkSectionMainnet.
  ///
  /// In en, this message translates to:
  /// **'Mainnet'**
  String get networkSectionMainnet;

  /// No description provided for @networkSectionTestnet.
  ///
  /// In en, this message translates to:
  /// **'Testnets'**
  String get networkSectionTestnet;

  /// No description provided for @networkTestnetListHint.
  ///
  /// In en, this message translates to:
  /// **'Chains marked as testnet in the app data source are listed here.'**
  String get networkTestnetListHint;

  /// No description provided for @networkCountNetworks.
  ///
  /// In en, this message translates to:
  /// **'{count} networks'**
  String networkCountNetworks(int count);

  /// No description provided for @networkAboutNodesTitle.
  ///
  /// In en, this message translates to:
  /// **'About RPC nodes'**
  String get networkAboutNodesTitle;

  /// No description provided for @networkAboutNodesBullet1.
  ///
  /// In en, this message translates to:
  /// **'RPC nodes are your gateway to the blockchain network.'**
  String get networkAboutNodesBullet1;

  /// No description provided for @networkAboutNodesBullet2.
  ///
  /// In en, this message translates to:
  /// **'Add custom nodes to improve speed or reliability.'**
  String get networkAboutNodesBullet2;

  /// No description provided for @networkAboutNodesBullet3.
  ///
  /// In en, this message translates to:
  /// **'Prefer trusted public nodes or nodes you run yourself.'**
  String get networkAboutNodesBullet3;

  /// No description provided for @networkStatusConnectionOk.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get networkStatusConnectionOk;

  /// No description provided for @networkStatusConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection issue'**
  String get networkStatusConnectionError;

  /// No description provided for @networkStatusCustomized.
  ///
  /// In en, this message translates to:
  /// **'Customized'**
  String get networkStatusCustomized;

  /// No description provided for @networkNodeCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} nodes'**
  String networkNodeCountLabel(int count);

  /// No description provided for @networkAllNodesTitle.
  ///
  /// In en, this message translates to:
  /// **'All nodes ({count})'**
  String networkAllNodesTitle(int count);

  /// No description provided for @networkDetailHeaderNodeCount.
  ///
  /// In en, this message translates to:
  /// **'Total {count} nodes'**
  String networkDetailHeaderNodeCount(int count);

  /// No description provided for @networkQuickAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick add nodes'**
  String get networkQuickAddTitle;

  /// No description provided for @networkQuickAddLine1.
  ///
  /// In en, this message translates to:
  /// **'Tap a network to open its details and add custom RPC URLs.'**
  String get networkQuickAddLine1;

  /// No description provided for @networkQuickAddLine2.
  ///
  /// In en, this message translates to:
  /// **'You can add multiple nodes; the list is kept for future improvements (e.g. picking the fastest).'**
  String get networkQuickAddLine2;

  /// No description provided for @networkNodeProbeOk.
  ///
  /// In en, this message translates to:
  /// **'Node connection OK'**
  String get networkNodeProbeOk;

  /// No description provided for @networkNodeProbeOkLatency.
  ///
  /// In en, this message translates to:
  /// **'Node connection OK, latency {ms} ms'**
  String networkNodeProbeOkLatency(int ms);

  /// No description provided for @networkCurrentNodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Current node'**
  String get networkCurrentNodeTitle;

  /// No description provided for @networkNodeActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get networkNodeActiveBadge;

  /// No description provided for @networkNoNodeSelected.
  ///
  /// In en, this message translates to:
  /// **'No node selected'**
  String get networkNoNodeSelected;

  /// No description provided for @networkNodeLatencyMs.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String networkNodeLatencyMs(int ms);

  /// No description provided for @networkAddRpcDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add RPC node'**
  String get networkAddRpcDialogTitle;

  /// No description provided for @networkAddRpcDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a custom RPC node for the {networkName} network.'**
  String networkAddRpcDialogSubtitle(String networkName);

  /// No description provided for @networkNodeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Node name'**
  String get networkNodeNameLabel;

  /// No description provided for @networkNodeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My node 1'**
  String get networkNodeNameHint;

  /// No description provided for @networkRpcUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'RPC URL'**
  String get networkRpcUrlLabel;

  /// No description provided for @networkRpcUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get networkRpcUrlHint;

  /// No description provided for @networkExampleRpcLabel.
  ///
  /// In en, this message translates to:
  /// **'Example RPC URL'**
  String get networkExampleRpcLabel;

  /// No description provided for @networkConfirmAddNode.
  ///
  /// In en, this message translates to:
  /// **'Add node'**
  String get networkConfirmAddNode;

  /// No description provided for @networkTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get networkTipsTitle;

  /// No description provided for @networkTipsLine1.
  ///
  /// In en, this message translates to:
  /// **'Add several nodes as backups.'**
  String get networkTipsLine1;

  /// No description provided for @networkTipsLine2.
  ///
  /// In en, this message translates to:
  /// **'Test a node to see connection status and latency.'**
  String get networkTipsLine2;

  /// No description provided for @networkTipsLine3.
  ///
  /// In en, this message translates to:
  /// **'Lower latency often means faster transactions.'**
  String get networkTipsLine3;

  /// No description provided for @networkTipsLine4.
  ///
  /// In en, this message translates to:
  /// **'Built-in default nodes cannot be deleted.'**
  String get networkTipsLine4;

  /// No description provided for @networkNodeInUseBadge.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get networkNodeInUseBadge;

  /// No description provided for @networkCannotDeleteDefaultNode.
  ///
  /// In en, this message translates to:
  /// **'Default nodes cannot be deleted.'**
  String get networkCannotDeleteDefaultNode;

  /// No description provided for @networkDeleteSwitchNodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Switch to another node before deleting this one.'**
  String get networkDeleteSwitchNodeFirst;

  /// No description provided for @homeFiatApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}'**
  String homeFiatApprox(String amount);

  /// No description provided for @homeUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price: {price}'**
  String homeUnitPrice(String price);

  /// No description provided for @homeUnitPriceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unit price: --'**
  String get homeUnitPriceUnavailable;

  /// No description provided for @homeTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Note creation records'**
  String get homeTransactionHistory;

  /// No description provided for @homeTransactionHistoryNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Note creation records are not configured'**
  String get homeTransactionHistoryNotConfigured;

  /// No description provided for @transactionHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your note creation records'**
  String get transactionHistorySubtitle;

  /// No description provided for @transactionHistoryStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get transactionHistoryStatTotal;

  /// No description provided for @transactionHistoryStatSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get transactionHistoryStatSuccess;

  /// No description provided for @transactionHistoryStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get transactionHistoryStatPending;

  /// No description provided for @transactionHistoryStatFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get transactionHistoryStatFailed;

  /// No description provided for @transactionHistoryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get transactionHistoryFilterAll;

  /// No description provided for @transactionHistoryFilterSend.
  ///
  /// In en, this message translates to:
  /// **'Note created'**
  String get transactionHistoryFilterSend;

  /// No description provided for @transactionHistoryFilterReceive.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get transactionHistoryFilterReceive;

  /// No description provided for @transactionHistorySelectChain.
  ///
  /// In en, this message translates to:
  /// **'Select network'**
  String get transactionHistorySelectChain;

  /// No description provided for @transactionHistoryCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get transactionHistoryCopied;

  /// No description provided for @transactionHistoryExplorerInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid explorer link'**
  String get transactionHistoryExplorerInvalidUrl;

  /// No description provided for @transactionHistoryExplorerLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the browser. Check system settings.'**
  String get transactionHistoryExplorerLaunchFailed;

  /// No description provided for @transactionHistoryExplorerOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open: {error}'**
  String transactionHistoryExplorerOpenError(String error);

  /// No description provided for @transactionHistoryRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Note creation records updated'**
  String get transactionHistoryRefreshed;

  /// No description provided for @transactionHistoryTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get transactionHistoryTimeJustNow;

  /// No description provided for @transactionHistoryTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String transactionHistoryTimeMinutesAgo(int count);

  /// No description provided for @transactionHistoryTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String transactionHistoryTimeHoursAgo(int count);

  /// No description provided for @transactionHistoryTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String transactionHistoryTimeDaysAgo(int count);

  /// No description provided for @transactionHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No note creation records yet'**
  String get transactionHistoryEmptyTitle;

  /// No description provided for @transactionHistoryEmptyHintFiltered.
  ///
  /// In en, this message translates to:
  /// **'No note creation records match this filter'**
  String get transactionHistoryEmptyHintFiltered;

  /// No description provided for @transactionHistoryEmptyHintAll.
  ///
  /// In en, this message translates to:
  /// **'You have no note creation records yet'**
  String get transactionHistoryEmptyHintAll;

  /// No description provided for @transactionHistoryTypeSend.
  ///
  /// In en, this message translates to:
  /// **'Note created'**
  String get transactionHistoryTypeSend;

  /// No description provided for @transactionHistoryTypeReceive.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get transactionHistoryTypeReceive;

  /// No description provided for @transactionHistoryStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get transactionHistoryStatusSuccess;

  /// No description provided for @transactionHistoryStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get transactionHistoryStatusFailed;

  /// No description provided for @transactionHistoryStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get transactionHistoryStatusPending;

  /// No description provided for @transactionHistoryDetailFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get transactionHistoryDetailFrom;

  /// No description provided for @transactionHistoryDetailTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get transactionHistoryDetailTo;

  /// No description provided for @transactionHistoryDetailTxHash.
  ///
  /// In en, this message translates to:
  /// **'On-chain hash'**
  String get transactionHistoryDetailTxHash;

  /// No description provided for @transactionHistoryDetailBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get transactionHistoryDetailBlock;

  /// No description provided for @transactionHistoryGasLine.
  ///
  /// In en, this message translates to:
  /// **'Gas: {fee} {symbol}'**
  String transactionHistoryGasLine(String fee, String symbol);

  /// No description provided for @homeGasBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'{symbol} gas balance'**
  String homeGasBalanceTitle(String symbol);

  /// No description provided for @homeTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get homeTotalAssets;

  /// No description provided for @homeRefreshBalance.
  ///
  /// In en, this message translates to:
  /// **'Refresh balance'**
  String get homeRefreshBalance;

  /// No description provided for @homeGetGas.
  ///
  /// In en, this message translates to:
  /// **'Get gas'**
  String get homeGetGas;

  /// No description provided for @homeGasHelp.
  ///
  /// In en, this message translates to:
  /// **'Gas is required to send transactions on-chain. Please keep enough balance.'**
  String get homeGasHelp;

  /// No description provided for @getGasDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Get {symbol} for gas'**
  String getGasDialogTitle(String symbol);

  /// No description provided for @getGasDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to add funds to your {chainName} note account'**
  String getGasDialogSubtitle(String chainName);

  /// No description provided for @getGasOptionReceiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Receive tokens'**
  String get getGasOptionReceiveTitle;

  /// No description provided for @getGasBadgeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get getGasBadgeRecommended;

  /// No description provided for @getGasReceiveHint.
  ///
  /// In en, this message translates to:
  /// **'Transfer {symbol} from another note account or exchange'**
  String getGasReceiveHint(String symbol);

  /// No description provided for @getGasWalletAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Note account address'**
  String get getGasWalletAddressLabel;

  /// No description provided for @getGasShowQr.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get getGasShowQr;

  /// No description provided for @getGasHideQr.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get getGasHideQr;

  /// No description provided for @getGasTransferWarning.
  ///
  /// In en, this message translates to:
  /// **'Use network {chainName} for transfers, or notes may be lost.'**
  String getGasTransferWarning(String chainName);

  /// No description provided for @getGasFaucetTitle.
  ///
  /// In en, this message translates to:
  /// **'Testnet faucet'**
  String get getGasFaucetTitle;

  /// No description provided for @getGasBadgeFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get getGasBadgeFree;

  /// No description provided for @getGasFaucetHint.
  ///
  /// In en, this message translates to:
  /// **'Claim free testnet {symbol} from a faucet'**
  String getGasFaucetHint(String symbol);

  /// No description provided for @getGasFaucetOpen.
  ///
  /// In en, this message translates to:
  /// **'Open faucet {index}'**
  String getGasFaucetOpen(int index);

  /// No description provided for @getGasBuyExchangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy on an exchange'**
  String get getGasBuyExchangeTitle;

  /// No description provided for @getGasBadgeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get getGasBadgeComingSoon;

  /// No description provided for @getGasBuyExchangeHint.
  ///
  /// In en, this message translates to:
  /// **'Buy {symbol} on an exchange and withdraw to your note account'**
  String getGasBuyExchangeHint(String symbol);

  /// No description provided for @getGasDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get getGasDialogCancel;

  /// No description provided for @getGasAddressCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get getGasAddressCopied;

  /// No description provided for @getGasInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid link'**
  String get getGasInvalidLink;

  /// No description provided for @getGasCouldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link. Check that a browser is available.'**
  String get getGasCouldNotOpenLink;

  /// No description provided for @getGasOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open: {error}'**
  String getGasOpenFailed(String error);

  /// No description provided for @homeRecentNotes.
  ///
  /// In en, this message translates to:
  /// **'Recent notes'**
  String get homeRecentNotes;

  /// No description provided for @homeRefreshRecentNotes.
  ///
  /// In en, this message translates to:
  /// **'Refresh recent notes'**
  String get homeRefreshRecentNotes;

  /// No description provided for @homeLoadingOnChainNotes.
  ///
  /// In en, this message translates to:
  /// **'Loading on-chain notes'**
  String get homeLoadingOnChainNotes;

  /// No description provided for @homeSyncingOnChainNotes.
  ///
  /// In en, this message translates to:
  /// **'Syncing on-chain notes…'**
  String get homeSyncingOnChainNotes;

  /// No description provided for @homeNoNotesInLastMonth.
  ///
  /// In en, this message translates to:
  /// **'No notes in the last month'**
  String get homeNoNotesInLastMonth;

  /// No description provided for @homeCreateNewNotePrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a new note'**
  String get homeCreateNewNotePrompt;

  /// No description provided for @notesAllChains.
  ///
  /// In en, this message translates to:
  /// **'All chains'**
  String get notesAllChains;

  /// No description provided for @notesSwitchedToAllChains.
  ///
  /// In en, this message translates to:
  /// **'Switched to all chains'**
  String get notesSwitchedToAllChains;

  /// No description provided for @notesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notesFilterAll;

  /// No description provided for @notesFilterOnChain.
  ///
  /// In en, this message translates to:
  /// **'On-chain'**
  String get notesFilterOnChain;

  /// No description provided for @notesFilterOffChain.
  ///
  /// In en, this message translates to:
  /// **'Not on-chain'**
  String get notesFilterOffChain;

  /// No description provided for @notesSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get notesSortNewest;

  /// No description provided for @notesSortUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get notesSortUpdated;

  /// No description provided for @notesSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get notesSortOldest;

  /// No description provided for @notesSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notesSortTitle;

  /// No description provided for @notesTimelineNoteCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesTimelineNoteCount(int count);

  /// No description provided for @noteStatsTotalNotes.
  ///
  /// In en, this message translates to:
  /// **'Total notes'**
  String get noteStatsTotalNotes;

  /// No description provided for @noteStatsOnChainCount.
  ///
  /// In en, this message translates to:
  /// **'On-chain'**
  String get noteStatsOnChainCount;

  /// No description provided for @noteStatsImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get noteStatsImages;

  /// No description provided for @noteStatsChars.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get noteStatsChars;

  /// No description provided for @noteDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get noteDeleteNote;

  /// No description provided for @noteDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get noteDeleteConfirmTitle;

  /// No description provided for @noteDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this note? This cannot be undone.'**
  String get noteDeleteConfirmBody;

  /// No description provided for @noteDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeletedSnackbar;

  /// No description provided for @noteDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String noteDeleteFailed(String error);

  /// No description provided for @noteUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String noteUpdatedAt(String date);

  /// No description provided for @noteCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String noteCreatedAt(String date);

  /// No description provided for @noteNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noteNoContent;

  /// No description provided for @noteEditorCreateNewNote.
  ///
  /// In en, this message translates to:
  /// **'Create new note'**
  String get noteEditorCreateNewNote;

  /// No description provided for @noteEditorChainLine.
  ///
  /// In en, this message translates to:
  /// **'{chainName} network'**
  String noteEditorChainLine(String chainName);

  /// No description provided for @noteEditorSelectChainToPublish.
  ///
  /// In en, this message translates to:
  /// **'Select a network to publish on-chain'**
  String get noteEditorSelectChainToPublish;

  /// No description provided for @noteEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get noteEditorSave;

  /// No description provided for @noteEditorSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get noteEditorSaving;

  /// No description provided for @noteTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleLabel;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Give your note a title…'**
  String get noteTitleHint;

  /// No description provided for @noteCoverImages.
  ///
  /// In en, this message translates to:
  /// **'Cover image (optional)'**
  String get noteCoverImages;

  /// No description provided for @noteCoverAdd.
  ///
  /// In en, this message translates to:
  /// **'Add cover'**
  String get noteCoverAdd;

  /// No description provided for @noteCoverUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get noteCoverUploading;

  /// No description provided for @noteCoverTapUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload a cover image'**
  String get noteCoverTapUpload;

  /// No description provided for @noteCoverFormatsHint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG, and other formats supported'**
  String get noteCoverFormatsHint;

  /// No description provided for @noteRichTextGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Rich text tools'**
  String get noteRichTextGuideTitle;

  /// No description provided for @noteRichTextHeadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Headings:'**
  String get noteRichTextHeadingLabel;

  /// No description provided for @noteRichTextHeadingBody.
  ///
  /// In en, this message translates to:
  /// **'Use the toolbar “Heading” to insert numbered headings.'**
  String get noteRichTextHeadingBody;

  /// No description provided for @noteRichTextListLabel.
  ///
  /// In en, this message translates to:
  /// **'Lists:'**
  String get noteRichTextListLabel;

  /// No description provided for @noteRichTextListBody.
  ///
  /// In en, this message translates to:
  /// **'Insert bullets or numbered lists.'**
  String get noteRichTextListBody;

  /// No description provided for @noteRichTextEmojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Emoji:'**
  String get noteRichTextEmojiLabel;

  /// No description provided for @noteRichTextEmojiBody.
  ///
  /// In en, this message translates to:
  /// **'Insert common emoji and markers quickly.'**
  String get noteRichTextEmojiBody;

  /// No description provided for @noteRichTextTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Templates:'**
  String get noteRichTextTemplateLabel;

  /// No description provided for @noteRichTextTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a preset template to start writing.'**
  String get noteRichTextTemplateBody;

  /// No description provided for @noteRichTextImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Images:'**
  String get noteRichTextImageLabel;

  /// No description provided for @noteRichTextImageBody.
  ///
  /// In en, this message translates to:
  /// **'Use the image button in the toolbar to insert into the body.'**
  String get noteRichTextImageBody;

  /// No description provided for @noteRichTextPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: switch to “Preview” to see formatted output.'**
  String get noteRichTextPreviewHint;

  /// No description provided for @noteEditorContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write your ideas, inspiration, and plans…\n\nTip: the toolbar can quickly insert:\n• Headings and lists\n• Emoji and symbols\n• Quick templates\n• Images\n\nRich text is supported; the detail page renders it nicely.'**
  String get noteEditorContentPlaceholder;

  /// No description provided for @noteTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Writing tips'**
  String get noteTipsTitle;

  /// No description provided for @noteTipsBody.
  ///
  /// In en, this message translates to:
  /// **'• Use a meaningful title\n• Capture ideas, plans, or important information\n• Add images to enrich your note\n• After saving you can publish on-chain for permanent storage'**
  String get noteTipsBody;

  /// No description provided for @noteReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get noteReadyTitle;

  /// No description provided for @noteReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Content looks good. Tap “Save” at the top right to create your note.'**
  String get noteReadyBody;

  /// No description provided for @noteTypeSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Note type:'**
  String get noteTypeSectionLabel;

  /// No description provided for @notePublishToChain.
  ///
  /// In en, this message translates to:
  /// **'Publish on-chain'**
  String get notePublishToChain;

  /// No description provided for @notePublishing.
  ///
  /// In en, this message translates to:
  /// **'Publishing…'**
  String get notePublishing;

  /// No description provided for @noteOnChainPublished.
  ///
  /// In en, this message translates to:
  /// **'Published on-chain'**
  String get noteOnChainPublished;

  /// No description provided for @selectBlockchainFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a blockchain network first'**
  String get selectBlockchainFirst;

  /// No description provided for @noteImageAdded.
  ///
  /// In en, this message translates to:
  /// **'Image added'**
  String get noteImageAdded;

  /// No description provided for @noteImagePickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not pick image'**
  String get noteImagePickFailed;

  /// No description provided for @noteSavedToLocal.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get noteSavedToLocal;

  /// No description provided for @notePublishFailedKeptDraft.
  ///
  /// In en, this message translates to:
  /// **'Publish failed; saved as draft'**
  String get notePublishFailedKeptDraft;

  /// No description provided for @noteSavedAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Saved as draft'**
  String get noteSavedAsDraft;

  /// No description provided for @richTextPreviewMode.
  ///
  /// In en, this message translates to:
  /// **'Preview mode'**
  String get richTextPreviewMode;

  /// No description provided for @richTextEditMode.
  ///
  /// In en, this message translates to:
  /// **'Edit mode'**
  String get richTextEditMode;

  /// No description provided for @richTextPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get richTextPreview;

  /// No description provided for @richTextEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get richTextEdit;

  /// No description provided for @richTextLineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lines'**
  String richTextLineCount(int count);

  /// No description provided for @richTextCharCount.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String richTextCharCount(int count);

  /// No description provided for @richTextToolbarBottomHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: use the toolbar for quick formatting, or type emoji and symbols manually.'**
  String get richTextToolbarBottomHint;

  /// No description provided for @richTextToolbarHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get richTextToolbarHeading;

  /// No description provided for @richTextTooltipInsertHeading.
  ///
  /// In en, this message translates to:
  /// **'Insert heading'**
  String get richTextTooltipInsertHeading;

  /// No description provided for @richTextTooltipBulletList.
  ///
  /// In en, this message translates to:
  /// **'Insert bullet list'**
  String get richTextTooltipBulletList;

  /// No description provided for @richTextTooltipNumberedList.
  ///
  /// In en, this message translates to:
  /// **'Insert numbered list'**
  String get richTextTooltipNumberedList;

  /// No description provided for @richTextTooltipStatusMarkers.
  ///
  /// In en, this message translates to:
  /// **'Insert status markers'**
  String get richTextTooltipStatusMarkers;

  /// No description provided for @richTextToolbarEmojiMenu.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get richTextToolbarEmojiMenu;

  /// No description provided for @richTextTooltipInsertEmoji.
  ///
  /// In en, this message translates to:
  /// **'Insert emoji'**
  String get richTextTooltipInsertEmoji;

  /// No description provided for @richTextToolbarTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get richTextToolbarTemplate;

  /// No description provided for @richTextTooltipQuickTemplate.
  ///
  /// In en, this message translates to:
  /// **'Quick templates'**
  String get richTextTooltipQuickTemplate;

  /// No description provided for @richTextTooltipAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get richTextTooltipAddImage;

  /// No description provided for @richTextMdImageAlt.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get richTextMdImageAlt;

  /// No description provided for @richTextInsertNumberedHeading.
  ///
  /// In en, this message translates to:
  /// **'\n1️⃣ Title\n'**
  String get richTextInsertNumberedHeading;

  /// No description provided for @richTextInsertBulletLines.
  ///
  /// In en, this message translates to:
  /// **'\n• List item 1\n• List item 2\n• List item 3\n'**
  String get richTextInsertBulletLines;

  /// No description provided for @richTextInsertNumberedLines.
  ///
  /// In en, this message translates to:
  /// **'\n1. First item\n2. Second item\n3. Third item\n'**
  String get richTextInsertNumberedLines;

  /// No description provided for @richTextInsertStatusMarkers.
  ///
  /// In en, this message translates to:
  /// **'\n🟢 Done\n🔵 In progress\n🟡 Pending\n'**
  String get richTextInsertStatusMarkers;

  /// No description provided for @richTextEmojiGroupNumberedTitle.
  ///
  /// In en, this message translates to:
  /// **'Numbered titles'**
  String get richTextEmojiGroupNumberedTitle;

  /// No description provided for @richTextEmojiGroupStatus.
  ///
  /// In en, this message translates to:
  /// **'Status markers'**
  String get richTextEmojiGroupStatus;

  /// No description provided for @richTextEmojiGroupSymbols.
  ///
  /// In en, this message translates to:
  /// **'Common symbols'**
  String get richTextEmojiGroupSymbols;

  /// No description provided for @richTextEmojiGroupEmoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get richTextEmojiGroupEmoji;

  /// No description provided for @richTextEmojiHeadingWord.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get richTextEmojiHeadingWord;

  /// No description provided for @richTextEmojiBodyWord.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get richTextEmojiBodyWord;

  /// No description provided for @richTextTplStandardNoteName.
  ///
  /// In en, this message translates to:
  /// **'📝 Standard note'**
  String get richTextTplStandardNoteName;

  /// No description provided for @richTextTplStandardNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Title\n\nMain content:\n• Point 1\n• Point 2\n• Point 3\n\nSummary:\n'**
  String get richTextTplStandardNoteBody;

  /// No description provided for @richTextTplTaskName.
  ///
  /// In en, this message translates to:
  /// **'✅ Task list'**
  String get richTextTplTaskName;

  /// No description provided for @richTextTplTaskBody.
  ///
  /// In en, this message translates to:
  /// **'Task list\n\nToday:\n✓ Completed\n✗ Not done\n→ In progress\n\nNotes:\n'**
  String get richTextTplTaskBody;

  /// No description provided for @richTextTplStudyName.
  ///
  /// In en, this message translates to:
  /// **'📚 Study notes'**
  String get richTextTplStudyName;

  /// No description provided for @richTextTplStudyBody.
  ///
  /// In en, this message translates to:
  /// **'Study notes - Topic\n\n1️⃣ Key ideas\n• Idea 1: details\n• Idea 2: details\n\n2️⃣ Summary\n• Takeaway 1\n• Takeaway 2\n\n3️⃣ Practice\n'**
  String get richTextTplStudyBody;

  /// No description provided for @richTextTplIdeaName.
  ///
  /// In en, this message translates to:
  /// **'💡 Idea capture'**
  String get richTextTplIdeaName;

  /// No description provided for @richTextTplIdeaBody.
  ///
  /// In en, this message translates to:
  /// **'💡 Idea capture\n\nThought:\n🟢 Core idea\n\nPros:\n• Pro 1\n• Pro 2\n\nNext:\n→ Next step\n'**
  String get richTextTplIdeaBody;

  /// No description provided for @richTextTplProjectName.
  ///
  /// In en, this message translates to:
  /// **'📊 Project plan'**
  String get richTextTplProjectName;

  /// No description provided for @richTextTplProjectBody.
  ///
  /// In en, this message translates to:
  /// **'Project plan\n\n🎯 Goal:\n\n📝 Steps:\n1. Step one\n2. Step two\n3. Step three\n\n⏰ Timeline:\n'**
  String get richTextTplProjectBody;

  /// No description provided for @gasPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Gas fee preview'**
  String get gasPreviewTitle;

  /// No description provided for @gasPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a gas speed and confirm to publish on-chain.'**
  String get gasPreviewSubtitle;

  /// No description provided for @gasPreviewLoading.
  ///
  /// In en, this message translates to:
  /// **'Fetching gas fees…'**
  String get gasPreviewLoading;

  /// No description provided for @gasPreviewPickSpeed.
  ///
  /// In en, this message translates to:
  /// **'Gas speed'**
  String get gasPreviewPickSpeed;

  /// No description provided for @gasPreviewLiveRates.
  ///
  /// In en, this message translates to:
  /// **'Live estimates'**
  String get gasPreviewLiveRates;

  /// No description provided for @gasSpeedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get gasSpeedSlow;

  /// No description provided for @gasSpeedStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get gasSpeedStandard;

  /// No description provided for @gasSpeedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get gasSpeedFast;

  /// No description provided for @gasTimeSlow.
  ///
  /// In en, this message translates to:
  /// **'~3–5 min'**
  String get gasTimeSlow;

  /// No description provided for @gasTimeStandard.
  ///
  /// In en, this message translates to:
  /// **'~1–2 min'**
  String get gasTimeStandard;

  /// No description provided for @gasTimeFast.
  ///
  /// In en, this message translates to:
  /// **'~15–30 sec'**
  String get gasTimeFast;

  /// No description provided for @gasDescSlow.
  ///
  /// In en, this message translates to:
  /// **'baseFee×1.1; priority fee = max(30 Gwei, suggested) + 3 Gwei.'**
  String get gasDescSlow;

  /// No description provided for @gasDescStandard.
  ///
  /// In en, this message translates to:
  /// **'baseFee×1.25; priority fee = max(30 Gwei, suggested) + 8 Gwei.'**
  String get gasDescStandard;

  /// No description provided for @gasDescFast.
  ///
  /// In en, this message translates to:
  /// **'baseFee×1.5; priority fee = max(30 Gwei, suggested) + 20 Gwei.'**
  String get gasDescFast;

  /// No description provided for @gasLabelGasPrice.
  ///
  /// In en, this message translates to:
  /// **'Gas price'**
  String get gasLabelGasPrice;

  /// No description provided for @gasLabelEstCost.
  ///
  /// In en, this message translates to:
  /// **'Est. cost'**
  String get gasLabelEstCost;

  /// No description provided for @gasRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get gasRecommendedBadge;

  /// No description provided for @gasPreviewGweiMax.
  ///
  /// In en, this message translates to:
  /// **'{value} Gwei (max)'**
  String gasPreviewGweiMax(String value);

  /// No description provided for @gasFeeBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee breakdown'**
  String get gasFeeBreakdownTitle;

  /// No description provided for @gasFeeRowBase.
  ///
  /// In en, this message translates to:
  /// **'Base fee'**
  String get gasFeeRowBase;

  /// No description provided for @gasFeeRowPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority fee'**
  String get gasFeeRowPriority;

  /// No description provided for @gasFeeRowNoteSize.
  ///
  /// In en, this message translates to:
  /// **'Note size'**
  String get gasFeeRowNoteSize;

  /// No description provided for @gasFeeRowTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get gasFeeRowTotal;

  /// No description provided for @gasFeeNoteSizeKb.
  ///
  /// In en, this message translates to:
  /// **'{kb} KB'**
  String gasFeeNoteSizeKb(String kb);

  /// No description provided for @gasWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you continue'**
  String get gasWarningTitle;

  /// No description provided for @gasWarningBody.
  ///
  /// In en, this message translates to:
  /// **'• Gas is paid to the network, not to this app.\n• Actual cost may vary slightly with congestion.\n• On-chain notes cannot be deleted or edited afterward.'**
  String get gasWarningBody;

  /// No description provided for @gasConfirmOnChain.
  ///
  /// In en, this message translates to:
  /// **'Confirm on-chain'**
  String get gasConfirmOnChain;

  /// No description provided for @gasOnChainConfirmDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot be changed after on-chain'**
  String get gasOnChainConfirmDialogTitle;

  /// No description provided for @gasOnChainConfirmDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This note will be written to the blockchain (IPFS + on-chain attestation).\nOnce submitted, it cannot be deleted or edited. Please make sure the content is correct before continuing.'**
  String get gasOnChainConfirmDialogBody;

  /// No description provided for @gasOnChainConfirmDialogQuestion.
  ///
  /// In en, this message translates to:
  /// **'Publish on-chain?'**
  String get gasOnChainConfirmDialogQuestion;

  /// No description provided for @onChainConfirmParamSummarySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Call parameters'**
  String get onChainConfirmParamSummarySectionTitle;

  /// No description provided for @noteOnChainParamJsonKeyNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get noteOnChainParamJsonKeyNetwork;

  /// No description provided for @noteOnChainParamJsonKeyChainId.
  ///
  /// In en, this message translates to:
  /// **'Chain ID'**
  String get noteOnChainParamJsonKeyChainId;

  /// No description provided for @noteOnChainParamJsonKeyFeeToken.
  ///
  /// In en, this message translates to:
  /// **'Gas token'**
  String get noteOnChainParamJsonKeyFeeToken;

  /// No description provided for @noteOnChainParamJsonKeySender.
  ///
  /// In en, this message translates to:
  /// **'Sender (your note account)'**
  String get noteOnChainParamJsonKeySender;

  /// No description provided for @noteOnChainParamJsonKeyContract.
  ///
  /// In en, this message translates to:
  /// **'Contract address'**
  String get noteOnChainParamJsonKeyContract;

  /// No description provided for @noteOnChainParamJsonKeyContractName.
  ///
  /// In en, this message translates to:
  /// **'Contract name'**
  String get noteOnChainParamJsonKeyContractName;

  /// No description provided for @noteOnChainParamJsonKeyFunction.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get noteOnChainParamJsonKeyFunction;

  /// No description provided for @noteOnChainParamJsonKeyNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get noteOnChainParamJsonKeyNoteTitle;

  /// No description provided for @noteOnChainParamJsonKeyContentSha256.
  ///
  /// In en, this message translates to:
  /// **'Note body fingerprint (SHA-256)'**
  String get noteOnChainParamJsonKeyContentSha256;

  /// No description provided for @noteOnChainParamJsonGroupMintCall.
  ///
  /// In en, this message translates to:
  /// **'On-chain call (contract args)'**
  String get noteOnChainParamJsonGroupMintCall;

  /// No description provided for @noteOnChainParamJsonGroupContext.
  ///
  /// In en, this message translates to:
  /// **'Details you can verify now'**
  String get noteOnChainParamJsonGroupContext;

  /// No description provided for @noteOnChainParamJsonValueUriPending.
  ///
  /// In en, this message translates to:
  /// **'Actual ipfs:// values are filled after you sign and content is uploaded to IPFS'**
  String get noteOnChainParamJsonValueUriPending;

  /// No description provided for @noteOnChainConfirmPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm publishing on-chain'**
  String get noteOnChainConfirmPageTitle;

  /// No description provided for @noteOnChainConfirmPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save this note permanently on the blockchain'**
  String get noteOnChainConfirmPageSubtitle;

  /// No description provided for @noteOnChainConfirmNoExplorer.
  ///
  /// In en, this message translates to:
  /// **'This network has no block explorer configured; cannot open the contract.'**
  String get noteOnChainConfirmNoExplorer;

  /// No description provided for @noteOnChainConfirmMintStatusUncertain.
  ///
  /// In en, this message translates to:
  /// **'On-chain status is unclear. Check the note or a block explorer later.'**
  String get noteOnChainConfirmMintStatusUncertain;

  /// No description provided for @noteOnChainConfirmSignButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm verification'**
  String get noteOnChainConfirmSignButton;

  /// No description provided for @noteOnChainConfirmTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you publish'**
  String get noteOnChainConfirmTipTitle;

  /// No description provided for @noteOnChainConfirmTipBody.
  ///
  /// In en, this message translates to:
  /// **'• After publishing, the note cannot be edited or deleted\n• Your note will be on-chain permanently and belongs to you\n• A small gas fee is required, one time only'**
  String get noteOnChainConfirmTipBody;

  /// No description provided for @noteOnChainConfirmNoteContentSection.
  ///
  /// In en, this message translates to:
  /// **'Note content'**
  String get noteOnChainConfirmNoteContentSection;

  /// No description provided for @noteOnChainConfirmNoteTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteOnChainConfirmNoteTitleLabel;

  /// No description provided for @noteOnChainConfirmContentPreview.
  ///
  /// In en, this message translates to:
  /// **'Content preview'**
  String get noteOnChainConfirmContentPreview;

  /// No description provided for @noteOnChainConfirmNoteHashLabel.
  ///
  /// In en, this message translates to:
  /// **'Note hash (SHA-256)'**
  String get noteOnChainConfirmNoteHashLabel;

  /// No description provided for @noteOnChainConfirmChainDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'On-chain details'**
  String get noteOnChainConfirmChainDetailsSection;

  /// No description provided for @noteOnChainConfirmMyWallet.
  ///
  /// In en, this message translates to:
  /// **'My note account'**
  String get noteOnChainConfirmMyWallet;

  /// No description provided for @noteOnChainConfirmTargetContract.
  ///
  /// In en, this message translates to:
  /// **'Target contract'**
  String get noteOnChainConfirmTargetContract;

  /// No description provided for @noteOnChainConfirmContractOwnershipHint.
  ///
  /// In en, this message translates to:
  /// **'The contract mints your note (NFT). The note (NFT) belongs to your note account—you hold permanent ownership of the note.'**
  String get noteOnChainConfirmContractOwnershipHint;

  /// No description provided for @noteOnChainConfirmNoteRecipientAddress.
  ///
  /// In en, this message translates to:
  /// **'Note recipient address: {address}'**
  String noteOnChainConfirmNoteRecipientAddress(String address);

  /// No description provided for @noteOnChainConfirmNetworkFee.
  ///
  /// In en, this message translates to:
  /// **'Network fee'**
  String get noteOnChainConfirmNetworkFee;

  /// No description provided for @noteOnChainConfirmGasPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Gas price'**
  String get noteOnChainConfirmGasPriceLabel;

  /// No description provided for @noteOnChainConfirmGasLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Gas limit'**
  String get noteOnChainConfirmGasLimitLabel;

  /// No description provided for @noteOnChainConfirmOnChainFee.
  ///
  /// In en, this message translates to:
  /// **'On-chain fee'**
  String get noteOnChainConfirmOnChainFee;

  /// No description provided for @noteOnChainConfirmGasOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Gas only'**
  String get noteOnChainConfirmGasOnlyHint;

  /// No description provided for @noteOnChainConfirmAdvancedSection.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get noteOnChainConfirmAdvancedSection;

  /// No description provided for @noteOnChainConfirmNonceLabel.
  ///
  /// In en, this message translates to:
  /// **'Nonce'**
  String get noteOnChainConfirmNonceLabel;

  /// No description provided for @noteOnChainConfirmNetworkLabel.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get noteOnChainConfirmNetworkLabel;

  /// No description provided for @noteOnChainConfirmGasSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get noteOnChainConfirmGasSlow;

  /// No description provided for @noteOnChainConfirmGasNormal.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get noteOnChainConfirmGasNormal;

  /// No description provided for @noteOnChainConfirmGasFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get noteOnChainConfirmGasFast;

  /// No description provided for @noteOnChainConfirmGasTimeSlow.
  ///
  /// In en, this message translates to:
  /// **'~5 min'**
  String get noteOnChainConfirmGasTimeSlow;

  /// No description provided for @noteOnChainConfirmGasTimeNormal.
  ///
  /// In en, this message translates to:
  /// **'~1 min'**
  String get noteOnChainConfirmGasTimeNormal;

  /// No description provided for @noteOnChainConfirmGasTimeFast.
  ///
  /// In en, this message translates to:
  /// **'~15 sec'**
  String get noteOnChainConfirmGasTimeFast;

  /// No description provided for @saveOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how to save'**
  String get saveOptionsTitle;

  /// No description provided for @saveOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the option that fits what you need.'**
  String get saveOptionsSubtitle;

  /// No description provided for @saveOnChainTitle.
  ///
  /// In en, this message translates to:
  /// **'Save on-chain'**
  String get saveOnChainTitle;

  /// No description provided for @saveOnChainDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanent on the blockchain; tamper-resistant.'**
  String get saveOnChainDescription;

  /// No description provided for @saveOnChainFeature1.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get saveOnChainFeature1;

  /// No description provided for @saveOnChainFeature2.
  ///
  /// In en, this message translates to:
  /// **'Verifiable'**
  String get saveOnChainFeature2;

  /// No description provided for @saveOnChainFeature3.
  ///
  /// In en, this message translates to:
  /// **'Decentralized'**
  String get saveOnChainFeature3;

  /// No description provided for @ipfsUploadConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload to IPFS'**
  String get ipfsUploadConfirmTitle;

  /// No description provided for @ipfsUploadConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This note has local images. Before going on-chain, they need to be uploaded to decentralized storage (IPFS). After upload you can continue to write to the blockchain.\n\nUpload to IPFS and continue?'**
  String get ipfsUploadConfirmBody;

  /// No description provided for @saveBadgeSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get saveBadgeSecure;

  /// No description provided for @saveDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get saveDraftTitle;

  /// No description provided for @saveDraftDescription.
  ///
  /// In en, this message translates to:
  /// **'Continue editing later; no chain resources yet.'**
  String get saveDraftDescription;

  /// No description provided for @saveDraftFeature1.
  ///
  /// In en, this message translates to:
  /// **'Edit anytime'**
  String get saveDraftFeature1;

  /// No description provided for @saveDraftFeature2.
  ///
  /// In en, this message translates to:
  /// **'Stored locally'**
  String get saveDraftFeature2;

  /// No description provided for @saveDraftFeature3.
  ///
  /// In en, this message translates to:
  /// **'Quick save'**
  String get saveDraftFeature3;

  /// No description provided for @saveBadgeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get saveBadgeRecommended;

  /// No description provided for @saveLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Save locally'**
  String get saveLocalTitle;

  /// No description provided for @saveLocalDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep this note on this device only.'**
  String get saveLocalDescription;

  /// No description provided for @saveLocalFeature1.
  ///
  /// In en, this message translates to:
  /// **'Offline friendly'**
  String get saveLocalFeature1;

  /// No description provided for @saveLocalFeature2.
  ///
  /// In en, this message translates to:
  /// **'Instant save'**
  String get saveLocalFeature2;

  /// No description provided for @saveLocalFeature3.
  ///
  /// In en, this message translates to:
  /// **'No fees'**
  String get saveLocalFeature3;

  /// No description provided for @saveWillPublishToChain.
  ///
  /// In en, this message translates to:
  /// **'Will be saved on {chainName}'**
  String saveWillPublishToChain(String chainName);

  /// No description provided for @guideWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to On Chain Notes'**
  String get guideWelcomeTitle;

  /// No description provided for @guideWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Before we start, let’s set up your note account.'**
  String get guideWelcomeSubtitle;

  /// No description provided for @guideSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data, your control'**
  String get guideSecurityTitle;

  /// No description provided for @guideSecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Your keys stay on your device. We do not store sensitive data on our servers. Keep your recovery phrase and security key safe.'**
  String get guideSecurityBody;

  /// No description provided for @guideCreateWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new note account'**
  String get guideCreateWalletTitle;

  /// No description provided for @guideCreateWalletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh with a new note account address and recovery phrase.'**
  String get guideCreateWalletSubtitle;

  /// No description provided for @guideRecommendedNewUser.
  ///
  /// In en, this message translates to:
  /// **'Recommended for new users'**
  String get guideRecommendedNewUser;

  /// No description provided for @guideImportWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore existing note account'**
  String get guideImportWalletTitle;

  /// No description provided for @guideImportWalletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore with your recovery phrase or security key.'**
  String get guideImportWalletSubtitle;

  /// No description provided for @guideTagMnemonic.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase'**
  String get guideTagMnemonic;

  /// No description provided for @guideTagPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Security key'**
  String get guideTagPrivateKey;

  /// No description provided for @guideICloudRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from iCloud'**
  String get guideICloudRestoreTitle;

  /// No description provided for @guideICloudRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you backed up your note account to iCloud, you can restore it quickly.'**
  String get guideICloudRestoreSubtitle;

  /// No description provided for @guideBadgeIosOnly.
  ///
  /// In en, this message translates to:
  /// **'iOS only'**
  String get guideBadgeIosOnly;

  /// No description provided for @guideGoogleRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from Google Drive'**
  String get guideGoogleRestoreTitle;

  /// No description provided for @guideGoogleRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you backed up your note account to Google Drive, you can restore it quickly.'**
  String get guideGoogleRestoreSubtitle;

  /// No description provided for @guideBadgeAllDevices.
  ///
  /// In en, this message translates to:
  /// **'All devices'**
  String get guideBadgeAllDevices;

  /// No description provided for @guideFooterHint.
  ///
  /// In en, this message translates to:
  /// **'Choose any option to continue.\nYour keys are stored securely on this device.'**
  String get guideFooterHint;

  /// No description provided for @guideProviderICloud.
  ///
  /// In en, this message translates to:
  /// **'iCloud'**
  String get guideProviderICloud;

  /// No description provided for @guideProviderGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get guideProviderGoogleDrive;

  /// No description provided for @guideLoadingWalletMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading note account…'**
  String get guideLoadingWalletMessage;

  /// No description provided for @googlePlayReviewModeTapHint.
  ///
  /// In en, this message translates to:
  /// **'{remaining} more tap(s) to enter review mode'**
  String googlePlayReviewModeTapHint(int remaining);

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ & user guide'**
  String get helpCenterSubtitle;

  /// No description provided for @helpSectionQuickGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick guides'**
  String get helpSectionQuickGuide;

  /// No description provided for @helpSectionFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get helpSectionFaq;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search questions…'**
  String get helpSearchHint;

  /// No description provided for @helpCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get helpCategoryAll;

  /// No description provided for @helpCategoryBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get helpCategoryBasics;

  /// No description provided for @helpCategoryBlockchain.
  ///
  /// In en, this message translates to:
  /// **'Blockchain'**
  String get helpCategoryBlockchain;

  /// No description provided for @helpCategoryWalletSecurity.
  ///
  /// In en, this message translates to:
  /// **'Note account security'**
  String get helpCategoryWalletSecurity;

  /// No description provided for @helpCategoryWalletMgmt.
  ///
  /// In en, this message translates to:
  /// **'Note account management'**
  String get helpCategoryWalletMgmt;

  /// No description provided for @helpCategoryAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get helpCategoryAdvanced;

  /// No description provided for @helpCategoryCommon.
  ///
  /// In en, this message translates to:
  /// **'Common issues'**
  String get helpCategoryCommon;

  /// No description provided for @helpComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get helpComingSoon;

  /// No description provided for @helpEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching questions'**
  String get helpEmptyTitle;

  /// No description provided for @helpEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords or contact support'**
  String get helpEmptySubtitle;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get helpContactTitle;

  /// No description provided for @helpContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No answer? Email us'**
  String get helpContactSubtitle;

  /// No description provided for @helpContactSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get helpContactSendFeedback;

  /// No description provided for @helpContactYourEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Your email (optional)'**
  String get helpContactYourEmailOptional;

  /// No description provided for @helpContactEmailHint.
  ///
  /// In en, this message translates to:
  /// **''**
  String get helpContactEmailHint;

  /// No description provided for @helpContactMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get helpContactMessageLabel;

  /// No description provided for @helpContactMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or suggestion…'**
  String get helpContactMessageHint;

  /// No description provided for @helpContactSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get helpContactSending;

  /// No description provided for @helpContactSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get helpContactSend;

  /// No description provided for @helpCopySupportEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address copied'**
  String get helpCopySupportEmail;

  /// No description provided for @helpFeedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your feedback'**
  String get helpFeedbackEmpty;

  /// No description provided for @helpFeedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get helpFeedbackThanks;

  /// No description provided for @helpFeedbackMailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open email. Try again later.'**
  String get helpFeedbackMailFailed;

  /// No description provided for @helpFeedbackMailSubject.
  ///
  /// In en, this message translates to:
  /// **'User feedback'**
  String get helpFeedbackMailSubject;

  /// No description provided for @helpQuickGuide1Title.
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get helpQuickGuide1Title;

  /// No description provided for @helpQuickGuide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Learn the basics in 5 minutes'**
  String get helpQuickGuide1Desc;

  /// No description provided for @helpQuickGuide2Title.
  ///
  /// In en, this message translates to:
  /// **'Create your first note'**
  String get helpQuickGuide2Title;

  /// No description provided for @helpQuickGuide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Create a note and publish on-chain'**
  String get helpQuickGuide2Desc;

  /// No description provided for @helpQuickGuide3Title.
  ///
  /// In en, this message translates to:
  /// **'Back up your recovery phrase'**
  String get helpQuickGuide3Title;

  /// No description provided for @helpQuickGuide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Keep your notes and data safe'**
  String get helpQuickGuide3Desc;

  /// No description provided for @helpQuickGuide4Title.
  ///
  /// In en, this message translates to:
  /// **'Manage multiple note accounts'**
  String get helpQuickGuide4Title;

  /// No description provided for @helpQuickGuide4Desc.
  ///
  /// In en, this message translates to:
  /// **'Create, import, and switch note accounts'**
  String get helpQuickGuide4Desc;

  /// No description provided for @helpFaq1Question.
  ///
  /// In en, this message translates to:
  /// **'What is On Chain Notes?'**
  String get helpFaq1Question;

  /// No description provided for @helpFaq1Answer.
  ///
  /// In en, this message translates to:
  /// **'On Chain Notes lets you store notes permanently on a blockchain so content stays tamper-evident and traceable. Once published on-chain, it typically cannot be changed or removed.'**
  String get helpFaq1Answer;

  /// No description provided for @helpFaq2Question.
  ///
  /// In en, this message translates to:
  /// **'How do I create a note?'**
  String get helpFaq2Question;

  /// No description provided for @helpFaq2Answer.
  ///
  /// In en, this message translates to:
  /// **'You can:\n1. Tap “Create note” on the home screen\n2. Or tap the “+” button on the notes page\n3. Add title, content, and images'**
  String get helpFaq2Answer;

  /// No description provided for @helpFaq3Question.
  ///
  /// In en, this message translates to:
  /// **'What save options are available?'**
  String get helpFaq3Question;

  /// No description provided for @helpFaq3Answer.
  ///
  /// In en, this message translates to:
  /// **'There are three options:\n1. Draft: saved locally, editable anytime\n2. Local save: finalized locally\n3. On-chain: permanent on blockchain, not editable\n\nWe recommend using a draft first, then publishing when ready.'**
  String get helpFaq3Answer;

  /// No description provided for @helpFaq4Question.
  ///
  /// In en, this message translates to:
  /// **'What is on-chain save? Do I pay?'**
  String get helpFaq4Question;

  /// No description provided for @helpFaq4Answer.
  ///
  /// In en, this message translates to:
  /// **'On-chain save stores your note on-chain permanently. You pay network fees (Gas) charged by the blockchain, not an app fee. Fees vary by network; many L2s are cheaper.'**
  String get helpFaq4Answer;

  /// No description provided for @helpFaq5Question.
  ///
  /// In en, this message translates to:
  /// **'Which networks are supported?'**
  String get helpFaq5Question;

  /// No description provided for @helpFaq5Answer.
  ///
  /// In en, this message translates to:
  /// **'The app supports eight mainstream EVM networks, including Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Fantom, and Base. You can switch networks from the home screen.'**
  String get helpFaq5Answer;

  /// No description provided for @helpFaq6Question.
  ///
  /// In en, this message translates to:
  /// **'How do I verify a note is on-chain?'**
  String get helpFaq6Question;

  /// No description provided for @helpFaq6Answer.
  ///
  /// In en, this message translates to:
  /// **'After publishing, you get a transaction hash. In note details you can view the hash, use Verify, or copy the hash to a block explorer for that network.'**
  String get helpFaq6Answer;

  /// No description provided for @helpFaq7Question.
  ///
  /// In en, this message translates to:
  /// **'What is a recovery phrase? Why back it up?'**
  String get helpFaq7Question;

  /// No description provided for @helpFaq7Answer.
  ///
  /// In en, this message translates to:
  /// **'A recovery phrase (often 12 English words) is the master key to recover your note account.\n\nIf you lose it, you may lose access forever.\nIf it leaks, your notes may be permanently lost or managed by others.\nThe app cannot recover it for you.\nWrite it on paper and store it safely.'**
  String get helpFaq7Answer;

  /// No description provided for @helpFaq8Question.
  ///
  /// In en, this message translates to:
  /// **'How do I back up my recovery phrase?'**
  String get helpFaq8Question;

  /// No description provided for @helpFaq8Answer.
  ///
  /// In en, this message translates to:
  /// **'1. Open Profile\n2. Tap backup recovery phrase\n3. Read the warnings\n4. Write down all words in order\n5. Verify in order\n6. Finish backup\n\nDo this in a private environment.'**
  String get helpFaq8Answer;

  /// No description provided for @helpFaq9Question.
  ///
  /// In en, this message translates to:
  /// **'Recovery phrase vs security key?'**
  String get helpFaq9Question;

  /// No description provided for @helpFaq9Answer.
  ///
  /// In en, this message translates to:
  /// **'Both can restore an note account.\n\nRecovery phrase: 12 words, easier to write down, derives keys (recommended backup).\n\nSecurity key: long hex string, harder to handle, single address (advanced users).'**
  String get helpFaq9Answer;

  /// No description provided for @helpFaq10Question.
  ///
  /// In en, this message translates to:
  /// **'How do I switch note accounts?'**
  String get helpFaq10Question;

  /// No description provided for @helpFaq10Answer.
  ///
  /// In en, this message translates to:
  /// **'1. Tap the note account address on the home header\n2. Pick another note account in the selector\n3. Or go to Note account management to create/import\n\nYou can manage multiple note accounts.'**
  String get helpFaq10Answer;

  /// No description provided for @helpFaq11Question.
  ///
  /// In en, this message translates to:
  /// **'How do I see addresses on other chains?'**
  String get helpFaq11Question;

  /// No description provided for @helpFaq11Answer.
  ///
  /// In en, this message translates to:
  /// **'In My note account:\n1. Expand the card with the arrow\n2. See supported chains and addresses\n3. Tap to copy\n\nFor EVM-compatible chains, the address format is the same.'**
  String get helpFaq11Answer;

  /// No description provided for @helpFaq12Question.
  ///
  /// In en, this message translates to:
  /// **'How do I customize an RPC node?'**
  String get helpFaq12Question;

  /// No description provided for @helpFaq12Answer.
  ///
  /// In en, this message translates to:
  /// **'1. Profile → Network settings\n2. Choose a network\n3. Add node\n4. Enter name and RPC URL\n5. Test connection\n6. Set as default\n\nCustom RPC can improve speed and reliability.'**
  String get helpFaq12Answer;

  /// No description provided for @helpFaq13Question.
  ///
  /// In en, this message translates to:
  /// **'What rich text formats are supported?'**
  String get helpFaq13Question;

  /// No description provided for @helpFaq13Answer.
  ///
  /// In en, this message translates to:
  /// **'Bold, italic, underline, headings (H1–H3), ordered/bullet lists, quotes, code blocks, and image upload—via the editor toolbar.'**
  String get helpFaq13Answer;

  /// No description provided for @helpFaq14Question.
  ///
  /// In en, this message translates to:
  /// **'Can on-chain notes be edited or deleted?'**
  String get helpFaq14Question;

  /// No description provided for @helpFaq14Answer.
  ///
  /// In en, this message translates to:
  /// **'Generally not—that is a property of blockchains.\n\nPublished notes are permanent and tamper-evident.\nUse drafts to iterate, then publish only when sure. Avoid putting highly sensitive data on-chain.'**
  String get helpFaq14Answer;

  /// No description provided for @helpFaq15Question.
  ///
  /// In en, this message translates to:
  /// **'Why does on-chain publishing take time?'**
  String get helpFaq15Question;

  /// No description provided for @helpFaq15Answer.
  ///
  /// In en, this message translates to:
  /// **'After fees are accepted, the transaction must be mined. Time depends on congestion and gas speed (fast often ~15–30s, standard ~1–2m, slow longer). Usually under a couple of minutes.'**
  String get helpFaq15Answer;

  /// No description provided for @helpFaq16Question.
  ///
  /// In en, this message translates to:
  /// **'What if I forgot my password?'**
  String get helpFaq16Question;

  /// No description provided for @helpFaq16Answer.
  ///
  /// In en, this message translates to:
  /// **'You can re-import the note account with your recovery phrase and set a new password. Local data may be retained depending on your setup.\n\nRemember: password encrypts locally; recovery phrase is the ultimate recovery key—keep it backed up.'**
  String get helpFaq16Answer;

  /// No description provided for @helpFeedbackMailBody.
  ///
  /// In en, this message translates to:
  /// **'Contact email: {email}\n\n{message}'**
  String helpFeedbackMailBody(String email, String message);

  /// No description provided for @termsOfServiceLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get termsOfServiceLastUpdatedLabel;

  /// No description provided for @termsOfServiceIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get termsOfServiceIntroTitle;

  /// No description provided for @termsOfServiceIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Please read these Terms of Service and {privacyDoc} carefully. By using the service you acknowledge these rules. If you do not agree, please do not use the service.'**
  String termsOfServiceIntroBody(String privacyDoc);

  /// No description provided for @termsOfServiceHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get termsOfServiceHelpTitle;

  /// No description provided for @termsOfServiceHelpBody.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about these terms, open the in-app Help Center or contact us via feedback or email. We will do our best to respond within a reasonable time.'**
  String get termsOfServiceHelpBody;

  /// No description provided for @termsOfServiceHelpMailFeedback.
  ///
  /// In en, this message translates to:
  /// **'Email feedback'**
  String get termsOfServiceHelpMailFeedback;

  /// No description provided for @termsOfServiceSection01Title.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance'**
  String get termsOfServiceSection01Title;

  /// No description provided for @termsOfServiceSection01Body.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appTitle} (“the Service”). Please read these Terms of Service (“the Terms”) before use.\nBy tapping agree, security verification up, security verification in, or using the Service, you agree to be bound by the Terms. If you disagree, stop using the Service.\nWe may update the Terms from time to time. Continued use after notice or updates means you accept the revised Terms.'**
  String termsOfServiceSection01Body(String appTitle);

  /// No description provided for @termsOfServiceSection02Title.
  ///
  /// In en, this message translates to:
  /// **'2. Description of the Service'**
  String get termsOfServiceSection02Title;

  /// No description provided for @termsOfServiceSection02Body.
  ///
  /// In en, this message translates to:
  /// **'The Service combines local storage with blockchain-related features: you can create, edit, and manage notes on your device and optionally perform on-chain actions (such as transactions, hashes, or metadata—see in-app flows and prompts).\nCurrent characteristics may evolve with releases:\n• Local storage: note data is mainly stored on your device (e.g. local database); uninstalling the app may erase local data—back up on your own.\n• On-chain features: you may voluntarily submit on-chain operations for proof, sync, or display; on-chain records are often public and hard to delete.\n• Multi-chain: multiple EVM-compatible networks as listed in the app.\n• Note account: keys are generated or imported by you on the device; you are responsible for safeguarding keys and recovery phrases.\nThe Service provides technical tools only and does not warrant the legality, accuracy, completeness, or fitness for a particular purpose of your content.'**
  String get termsOfServiceSection02Body;

  /// No description provided for @termsOfServiceSection03Title.
  ///
  /// In en, this message translates to:
  /// **'3. Note account and security'**
  String get termsOfServiceSection03Title;

  /// No description provided for @termsOfServiceSection03Body.
  ///
  /// In en, this message translates to:
  /// **'3.1 Note account and credentials: after creating or importing an note account, the app manages addresses and key material on the device. Recovery phrases and security keys are among the only practical ways to recover notes—back them up offline and keep them secret.\n3.2 Your responsibility: actions performed while the app or note account is unlocked on your device are treated as yours or authorized by you. Losses from leaked phrases/keys, lost devices, malware, phishing, or failure to follow prompts are yours to bear.\n3.3 Security tips:\n• Never share your recovery phrase or security key with anyone\n• Use a strong app password and device lock / biometrics where available\n• Back up your phrase in a trusted environment and verify the backup\n• Beware of fake apps and phishing links\n3.4 We and our staff will never ask for your full recovery phrase or security key. Reject such requests and report them through official channels.'**
  String get termsOfServiceSection03Body;

  /// No description provided for @termsOfServiceSection04Title.
  ///
  /// In en, this message translates to:
  /// **'4. Blockchain transactions and fees'**
  String get termsOfServiceSection04Title;

  /// No description provided for @termsOfServiceSection04Body.
  ///
  /// In en, this message translates to:
  /// **'4.1 Gas and network fees: on-chain transactions require fees paid to the network (e.g. gas). Fees are collected by the network, not by {appTitle} as a software provider on your behalf; amounts depend on the network and congestion.\n4.2 Confirmation time: transactions need network confirmation; timing depends on network conditions and your fee settings—we do not guarantee a specific duration.\n4.3 Failures and charges: insufficient balance, RPC errors, user cancellation, or contract reverts may cause failure; network fees already spent may be non-refundable per network rules.\n4.4 Irreversibility: once sufficiently confirmed, on-chain transactions usually cannot be undone. Double-check network, amounts, and contract calls before security verification and broadcasting.\n4.5 You are responsible for all on-chain actions you initiate. To the extent permitted by law, we are not liable for losses from blockchain protocols, nodes, smart contracts, or your own mistakes.'**
  String termsOfServiceSection04Body(String appTitle);

  /// No description provided for @termsOfServiceSection05Title.
  ///
  /// In en, this message translates to:
  /// **'5. Acceptable use'**
  String get termsOfServiceSection05Title;

  /// No description provided for @termsOfServiceSection05Body.
  ///
  /// In en, this message translates to:
  /// **'You must not:\n• Create, upload, or distribute illegal, infringing, defamatory, obscene, violent, hateful, or otherwise unlawful content\n• Use the Service for fraud, money laundering, illegal fundraising, IP infringement, or other conduct prohibited by regulators\n• Access, probe, disrupt, or damage the Service or related infrastructure without authorization\n• Scrape, abuse APIs, or harm other users’ normal use (unless we agree in writing)\n• Send bulk harassment or unsolicited commercial messages\nIf you breach the above, we may warn you, restrict features, suspend, or terminate access, and cooperate with lawful or regulatory requests where required.'**
  String get termsOfServiceSection05Body;

  /// No description provided for @termsOfServiceSection06Title.
  ///
  /// In en, this message translates to:
  /// **'6. Intellectual property'**
  String get termsOfServiceSection06Title;

  /// No description provided for @termsOfServiceSection06Body.
  ///
  /// In en, this message translates to:
  /// **'6.1 The Service itself: client software, UI, branding, and documentation are protected by us or right holders. Without permission, you may not copy, reverse engineer, crack, or commercially redistribute the core software (except as allowed by law).\n6.2 Your content: you retain rights in notes and content you create; the Terms do not transfer those rights to us.\n6.3 License to us: solely to operate and improve the Service (sync, display, backup, on-chain submission, etc.), you grant us a non-exclusive, royalty-free license, revocable as permitted by the Terms.\n6.4 Do not use our trademarks, app name, or logos in a confusing way without written consent.'**
  String get termsOfServiceSection06Body;

  /// No description provided for @termsOfServiceSection07Title.
  ///
  /// In en, this message translates to:
  /// **'7. Disclaimers'**
  String get termsOfServiceSection07Title;

  /// No description provided for @termsOfServiceSection07Body.
  ///
  /// In en, this message translates to:
  /// **'7.1 “As is”: to the fullest extent permitted by law, the Service is provided “as is” and “as available.” We disclaim warranties of uninterrupted operation, error-free use, suitability for your needs, or compatibility with all devices or software.\n7.2 Data and security: we use reasonable measures but cannot guarantee there will never be data loss, leaks, or outages due to force majeure, lost devices, malware, attacks, or external systems (blockchain / IPFS, etc.).\n7.3 Third parties: the Service may rely on nodes, gateways, decentralized storage, push messaging, etc.; we do not warrant third parties’ availability, accuracy, or compliance—assess risks yourself.\n7.4 On-chain notes and protocol risks: on-chain notes and related protocols involve network issues, contract bugs, forks, and other risks—you assume them.\n7.5 Liability cap: except where law forbids, we are not liable for indirect, incidental, special, or consequential damages; our total liability is capped at fees you actually paid us for the disputed Service (zero if none).'**
  String get termsOfServiceSection07Body;

  /// No description provided for @termsOfServiceSection08Title.
  ///
  /// In en, this message translates to:
  /// **'8. Changes, suspension, and termination'**
  String get termsOfServiceSection08Title;

  /// No description provided for @termsOfServiceSection08Body.
  ///
  /// In en, this message translates to:
  /// **'8.1 We may change, suspend, or discontinue features for business, compliance, or technical reasons; we will notify you in-app when practicable.\n8.2 You may stop using the Service and uninstall at any time; export or back up important data beforehand.\n8.3 We may suspend or terminate access if you materially breach the Terms.\n8.4 After termination, unless the law requires otherwise, we have no obligation to retain or return data already on-chain, on third-party networks, or locally under your control.'**
  String get termsOfServiceSection08Body;

  /// No description provided for @termsOfServiceSection09Title.
  ///
  /// In en, this message translates to:
  /// **'9. Governing law and disputes'**
  String get termsOfServiceSection09Title;

  /// No description provided for @termsOfServiceSection09Body.
  ///
  /// In en, this message translates to:
  /// **'9.1 These Terms are governed by the laws of mainland China (for these Terms only, excluding conflict-of-law rules that would select foreign law, unless mandatory law says otherwise).\n9.2 Disputes should first be resolved through good-faith negotiation.\n9.3 If negotiation fails, either party may bring a suit in a court with jurisdiction (e.g. where our principal office is located), subject to mandatory jurisdictional rules.'**
  String get termsOfServiceSection09Body;

  /// No description provided for @termsOfServiceSection10Title.
  ///
  /// In en, this message translates to:
  /// **'10. Miscellaneous'**
  String get termsOfServiceSection10Title;

  /// No description provided for @termsOfServiceSection10Body.
  ///
  /// In en, this message translates to:
  /// **'10.1 Entire agreement: these Terms, {privacyDoc}, and in-app rules together govern use of the Service; special rules prevail for their topic if they conflict (without violating mandatory law).\n10.2 Severability: if a provision is invalid, the rest remain in effect and should be interpreted as closely as legally possible to the original intent.\n10.3 No waiver: failure to enforce a right is not a waiver.\n10.4 Contact: unless the law requires another channel, ask about these Terms via the in-app Help Center or feedback.'**
  String termsOfServiceSection10Body(String privacyDoc);

  /// No description provided for @termsOfServiceFooterLine1.
  ///
  /// In en, this message translates to:
  /// **'Thank you for trusting and using {appTitle}.'**
  String termsOfServiceFooterLine1(String appTitle);

  /// No description provided for @connectEvmAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect an EVM note account first'**
  String get connectEvmAccountFirst;

  /// No description provided for @createAccountFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Failed to create note account. Please try again later.'**
  String get createAccountFailedRetry;

  /// No description provided for @createAccountFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create note account: {error}'**
  String createAccountFailedWithError(String error);

  /// No description provided for @transactionHistoryConnectEvm.
  ///
  /// In en, this message translates to:
  /// **'Select a network and ensure an EVM note account is connected'**
  String get transactionHistoryConnectEvm;

  /// No description provided for @transactionHistoryUnsupportedNetwork.
  ///
  /// In en, this message translates to:
  /// **'This network does not support note creation records yet. Switch to a common EVM network.'**
  String get transactionHistoryUnsupportedNetwork;

  /// No description provided for @securityVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Security verification failed'**
  String get securityVerificationFailed;

  /// No description provided for @walletImportPrivateKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your security key. Never share it with anyone.'**
  String get walletImportPrivateKeyHint;

  /// No description provided for @walletImportPrivateKeySubmit.
  ///
  /// In en, this message translates to:
  /// **'Import security key'**
  String get walletImportPrivateKeySubmit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
