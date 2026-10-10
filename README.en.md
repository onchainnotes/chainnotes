# ChainNotes

ChainNotes is a Flutter client for writing notes and anchoring a permanent record of them on EVM blockchains. A note can stay on the device as a draft or a local note. Publishing uploads the note and its images to IPFS, anchors a SHA-256 content hash with an ERC-721 mint, and lets the same self-custodial note account load that record again later.

This repository is the Android and iOS app. Clone it, build it, and send improvements back through pull requests.

Official website: [https://chainnotes.org/](https://chainnotes.org/)

## Features

- **Draft, local, and on-chain notes.** Write first, then choose when a note should be published.
- **On-chain record.** Published notes are pinned to IPFS. The content hash, token URI, and transaction are recorded through the ChainNotes note contract.
- **Self-custodial note accounts.** Create a new account or restore one with a recovery phrase or private key. Keys stay on the device and are encrypted with the account password.
- **Multi-chain publishing.** Switch networks and publish on the chain you select. Custom RPC endpoints can be added in network settings.
- **Verification and history.** Check a published note against its on-chain record, and review the transactions created by the account.
- **Everyday writing tools.** Rich text, images, balance and gas estimates before publishing, light and dark themes, and in-app help.

## Supported networks

Mainnets:

- Ethereum
- BNB Smart Chain
- Polygon
- Arbitrum
- Optimism
- Avalanche

Testnets:

- Sepolia
- Polygon Amoy
- BNB Smart Chain Testnet

Publishing spends the native gas token of the selected network. Testnets are the safer place to try a publish while developing.

## Languages

English, Simplified Chinese, Traditional Chinese, Japanese, and Korean. Source strings live in `lib/l10n/`. `app_en.arb` is the template.

## Tech stack

| Area | Choice |
| --- | --- |
| App | Flutter (Dart SDK `^3.10.4`) |
| State and navigation | Riverpod, go_router |
| Local data | Realm, SharedPreferences, flutter_secure_storage |
| Keys and signing | Trust Wallet Core, web3dart |
| Content storage | IPFS (Pinata) |
| On-chain record | ERC-721 note contract |
| Platforms | Android and iOS |

## Requirements

- Flutter SDK matching `environment.sdk` in `pubspec.yaml` (`^3.10.4`)
- Android Studio, or Xcode plus CocoaPods, for the platform you run
- Network access for `flutter pub get` and, on iOS, for the Trust Wallet Core download

## Build from source

```bash
git clone https://github.com/onchainnotes/chainnotes.git
cd chainnotes
flutter pub get
flutter run
```

iOS also needs the Trust Wallet Core frameworks before the native build:

```bash
bash scripts/setup_ios_wallet_core.sh
flutter run
```

The script downloads the Wallet Core xcframeworks and runs `pod install`. If those frameworks are already present, it only installs pods.

### Local configuration

The app can be built and used for local notes without extra services. Publishing and push notifications depend on credentials that must be your own:

- **IPFS.** Uploads go through Pinata. Put your own token in `lib/features/note/data/service/ipfs_service.dart` before you publish a note. Do not commit a real token.
- **Firebase.** Messaging uses the Firebase options bundled for this app. Use your own Firebase project if you ship a build.
- **RPC.** Public endpoints in the repo are for development. Add your own endpoint in the app when you need a reliable node.

Never commit recovery phrases, private keys, API tokens, keystores, or signing files.

## Development

After changing Riverpod or JSON annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

After changing `lib/l10n/*.arb`:

```bash
flutter gen-l10n
```

Before opening a pull request:

```bash
flutter analyze
flutter test
```

## Project layout

```text
lib/
  app/            # app shell, routing, theme
  features/
    auth/         # account password
    guide/        # create and restore flows
    home/         # home, chain selection, transaction history
    note/         # editor, IPFS upload, on-chain confirm
    settings/     # profile, networks, help, about
    wallet/       # note accounts, keys, signing
  l10n/           # translations
packages/         # shared UI, base utilities, Trust Wallet Core binding
scripts/          # iOS Wallet Core setup
```

## Contributing

1. Fork the repository and create a branch for your change.
2. Keep the change focused. Match the style of the surrounding code.
3. Run `flutter analyze` and `flutter test`.
4. Open a pull request that explains why the change is needed and how you checked it.

Bug reports and feature requests are welcome. Include the platform, app version, and steps to reproduce. Leave out recovery phrases, private keys, and addresses that you do not want public.

## Security

This app holds note-account keys on the device. Review the code before you rely on a build, and do not install a binary you did not build yourself if you are unsure of its origin.

Report security issues privately to [support@chainnotes.org](mailto:support@chainnotes.org). Please do not file a public issue that includes a live recovery phrase, private key, or exploit details.

## License

Copyright (c) 2026 Yiwanying Tech

This project is licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE). You may use, modify, and share it for noncommercial purposes. Commercial use is not permitted under this license.

For a commercial license, contact [colin@chainnotes.org](mailto:colin@chainnotes.org).

## Contact

**Website**  
[https://chainnotes.org/](https://chainnotes.org/)

### Technical Support

For technical issues, bug reports, or feature requests:

[support@chainnotes.org](mailto:support@chainnotes.org)

### Business & Partnerships

Chengdu Yiwanying Technology Co., Ltd.

For business inquiries, partnerships, commercial licensing, or general questions:

[colin@chainnotes.org](mailto:colin@chainnotes.org)
