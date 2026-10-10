#!/usr/bin/env python3
"""Replace wallet/note-security copy: 控制资产→管理笔记, 资产→笔记 (keep gas/crypto 资产 as 代币/余额)."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

# Per-locale overrides for known keys (full string replacement).
LOCALE_OVERRIDES: dict[str, dict[str, str]] = {
    "zh": {
        "walletManagementDeleteAssetsLoss": "请确保您已经妥善保存了笔记账户的恢复短语或安全密钥，否则您的笔记将永久丢失。",
        "privateKeyExportWarnBullet1": "安全密钥是管理笔记的最高权限凭证",
        "privateKeyExportWarnBullet2": "任何人获得安全密钥即可完全管理您的笔记",
        "privateKeyExportReminderBullet1": "拥有安全密钥 = 可完全管理该地址下的笔记",
        "privateKeyExportReminderBullet2": "安全密钥泄露将导致笔记永久丢失，无法找回",
        "mnemonicBackupFlowSecurityTip2": "任何人获得恢复短语即可管理您的笔记",
        "mnemonicBackupFlowProcess3": "完成备份，保护您的笔记安全",
        "mnemonicBackupFlowFinalEncouragementBody": "您的笔记受到恢复短语的保护",
        "createWalletPasswordSubtitle": "保护您的笔记安全",
        "createWalletPasswordWhyBody": "笔记账户密码用于加密您的安全密钥和恢复短语，确保只有您能访问您的笔记。请务必牢记此密码，遗失后无法找回。",
        "walletImportPkSevereBody": "• 安全密钥是您笔记账户的最高权限凭证\n• 任何人获得安全密钥即可完全管理您的笔记\n• 请勿在不安全的设备上输入安全密钥\n• 请勿截图或通过聊天软件发送安全密钥",
        "homeTotalAssets": "总余额",
        "getGasTransferWarning": "请确保转账网络为 {chainName}，否则笔记可能丢失",
        "helpQuickGuide3Desc": "确保您的笔记和数据安全",
        "helpFaq7Answer": "恢复短语是恢复笔记账户的唯一凭证，通常由 12 个英文单词组成。它是您笔记账户的“主密钥”。\n\n重要性：\n• 恢复短语丢失 = 笔记账户永久丢失\n• 恢复短语泄露 = 笔记可能永久丢失或被他人管理\n• 应用无法帮您找回恢复短语\n\n务必妥善保管，建议抄写在纸上保存在安全的地方。",
    },
    "zh_TW": {
        "walletManagementDeleteAssetsLoss": "請確認已妥善保存恢復短語或安全密鑰，否則您的筆記可能永久遺失。",
        "privateKeyExportWarnBullet1": "安全密鑰是管理筆記的最高權限憑證",
        "privateKeyExportWarnBullet2": "任何人取得安全密鑰即可完全管理您的筆記",
        "privateKeyExportReminderBullet1": "擁有安全密鑰 = 可完全管理該地址下的筆記",
        "privateKeyExportReminderBullet2": "安全密鑰外洩將導致筆記永久遺失，無法找回",
        "mnemonicBackupFlowSecurityTip2": "任何人取得恢復短語即可管理您的筆記",
        "mnemonicBackupFlowProcess3": "完成備份，保護您的筆記安全",
        "mnemonicBackupFlowFinalEncouragementBody": "您的筆記受到恢復短語的保護",
        "createWalletPasswordSubtitle": "保護您的筆記安全",
        "createWalletPasswordWhyBody": "筆記帳戶密碼用於加密安全密鑰與恢復短語，僅您可存取筆記。請務必記住，遺失後無法復原。",
        "walletImportPkSevereBody": "• 安全密鑰是筆記帳戶最高權限\n• 取得安全密鑰者可完全管理您的筆記\n• 請勿在不安全裝置輸入安全密鑰\n• 請勿截圖或透過聊天軟體傳送安全密鑰",
        "homeTotalAssets": "總餘額",
        "getGasTransferWarning": "請確保轉帳網路為 {chainName}，否則筆記可能遺失",
        "helpQuickGuide3Desc": "確保您的筆記與資料安全",
        "helpFaq7Answer": "恢復短語是恢復筆記帳戶的唯一憑證，通常由 12 個英文單詞組成。它是您筆記帳戶的「主密鑰」。\n\n重要性：\n• 恢復短語遺失 = 筆記帳戶永久遺失\n• 恢復短語外洩 = 筆記可能永久遺失或被他人管理\n• 應用程式無法幫您找回恢復短語\n\n務必妥善保管，建議抄寫在紙上保存在安全的地方。",
    },
    "en": {
        "walletManagementDeleteAssetsLoss": "If you have not saved your recovery phrase or security key, you may permanently lose access to your notes.",
        "privateKeyExportWarnBullet1": "Your security key is the highest-level credential for managing your notes",
        "privateKeyExportWarnBullet2": "Anyone who obtains your security key can fully manage your notes",
        "privateKeyExportReminderBullet1": "Having the security key means you can fully manage notes for this address",
        "privateKeyExportReminderBullet2": "A leaked security key can cause permanent loss of notes with no recovery",
        "mnemonicBackupFlowSecurityTip2": "Anyone with your recovery phrase can manage your notes",
        "mnemonicBackupFlowProcess3": "Finish backup to protect your notes",
        "mnemonicBackupFlowFinalEncouragementBody": "Your notes are protected by your recovery phrase",
        "createWalletPasswordSubtitle": "Protect your notes",
        "createWalletPasswordWhyBody": "Your note account password encrypts security keys and recovery phrases so only you can access your notes. Remember it — it cannot be recovered if lost.",
        "walletImportPkSevereBody": "• The security key grants full control of your note account\n• Anyone with it can fully manage your notes\n• Do not enter it on unsafe devices\n• Do not screenshot or send via chat apps",
        "homeTotalAssets": "Total balance",
        "getGasTransferWarning": "Use network {chainName} for transfers, or notes may be lost.",
        "helpQuickGuide3Desc": "Keep your notes and data safe",
        "helpFaq7Answer": "A recovery phrase (often 12 English words) is the master key to recover your note account.\n\nIf you lose it, you may lose access forever.\nIf it leaks, your notes may be permanently lost or managed by others.\nThe app cannot recover it for you.\nWrite it on paper and store it safely.",
    },
    "ja": {
        "walletManagementDeleteAssetsLoss": "リカバリーフレーズまたはセキュリティキーを保管していない場合、ノートへアクセスできなくなる可能性があります。",
        "privateKeyExportWarnBullet1": "セキュリティキーはノートを管理する最高権限の認証情報です",
        "privateKeyExportWarnBullet2": "セキュリティキーを入手した者はノートを完全に管理できます",
        "privateKeyExportReminderBullet1": "セキュリティキーを持つ = そのアドレスのノートを完全に管理できる",
        "privateKeyExportReminderBullet2": "漏洩するとノートは永久に失われ、復元できません",
        "mnemonicBackupFlowSecurityTip2": "リカバリーフレーズを知られると、ノートを管理される可能性があります",
        "mnemonicBackupFlowProcess3": "バックアップを完了し、ノートを守る",
        "mnemonicBackupFlowFinalEncouragementBody": "あなたのノートはリカバリーフレーズによって保護されています",
        "createWalletPasswordSubtitle": "ノートを安全に保護",
        "createWalletPasswordWhyBody": "ノートアカウントパスワードでセキュリティキーとリカバリーフレーズを暗号化し、本人だけがノートにアクセスできます。紛失すると復元できないため必ず覚えてください。",
        "walletImportPkSevereBody": "• セキュリティキーはノートアカウントの完全な権限です\n• 入手された者がノートを完全に管理できます\n• 安全でない端末で入力しないでください\n• スクリーンショットやチャット送信は避けてください",
        "homeTotalAssets": "総残高",
        "getGasTransferWarning": "送金ネットワークが {chainName} であることを確認してください。違うとノートを失う可能性があります",
        "helpQuickGuide3Desc": "ノートとデータを守る",
        "helpFaq7Answer": "リカバリーフレーズ（多くは12語の英単語）はノートアカウントを復元するマスターキーです。\n\n紛失すると永久にアクセスできなくなる可能性があります。\n漏洩するとノートが永久に失われたり、他人に管理されたりする可能性があります。\nアプリは復元できません。\n紙に書き、安全な場所に保管してください。",
    },
    "ko": {
        "walletManagementDeleteAssetsLoss": "복구 구문 또는 보안 키를 보관하지 않으면 노트에 영구적으로 접근하지 못할 수 있습니다.",
        "privateKeyExportWarnBullet1": "보안 키는 노트를 관리하는 최고 권한 자격 증명입니다",
        "privateKeyExportWarnBullet2": "보안 키를 얻은 사람은 노트를 완전히 관리할 수 있습니다",
        "privateKeyExportReminderBullet1": "보안 키 보유 = 해당 주소의 노트를 완전히 관리할 수 있음",
        "privateKeyExportReminderBullet2": "유출 시 노트는 영구적으로 잃을 수 있으며 복구할 수 없습니다",
        "mnemonicBackupFlowSecurityTip2": "복구 구문을 아는 사람은 노트를 관리할 수 있습니다",
        "mnemonicBackupFlowProcess3": "백업을 마치고 노트 보호",
        "mnemonicBackupFlowFinalEncouragementBody": "노트는 복구 구문으로 보호됩니다",
        "createWalletPasswordSubtitle": "노트를 안전하게 보호",
        "createWalletPasswordWhyBody": "노트 계정 비밀번호는 보안 키와 복구 구문을 암호화하여 본인만 노트에 접근할 수 있게 합니다. 분실 시 복구할 수 없으니 반드시 기억하세요.",
        "walletImportPkSevereBody": "• 보안 키는 노트 계정의 최고 권한입니다\n• 탈취 시 노트를 완전히 관리당할 수 있습니다\n• 안전하지 않은 기기에서 입력하지 마세요\n• 캡처나 메신저 전송을 하지 마세요",
        "homeTotalAssets": "총 잔액",
        "getGasTransferWarning": "송금 네트워크가 {chainName}인지 확인하세요. 다르면 노트를 잃을 수 있습니다",
        "helpQuickGuide3Desc": "노트와 데이터를 안전하게",
        "helpFaq7Answer": "복구 구문(보통 영어 12단어)은 노트 계정을 복구하는 마스터 키입니다.\n\n분실하면 영구적으로 접근하지 못할 수 있습니다.\n유출하면 노트가 영구적으로 잃거나 다른 사람이 관리할 수 있습니다.\n앱이 대신 복구해 줄 수 없습니다.\n종이에 적어 안전한 곳에 보관하세요.",
    },
}

# Substring replacements inside long legal/help strings (order matters).
TERMS07_4_REPLACEMENTS: dict[str, list[tuple[str, str]]] = {
    "zh": [
        (
            "7.4 加密资产与协议风险：数字资产与链上协议具有价格波动、合约漏洞、治理分叉等固有风险；您应自行了解并承担。",
            "7.4 链上笔记与协议风险：链上笔记及相关协议具有网络异常、合约漏洞、治理分叉等固有风险；您应自行了解并承担。",
        ),
    ],
    "zh_TW": [
        (
            "7.4 加密資產與協定風險：數位資產與鏈上協定具有價格波動、合約漏洞、治理分叉等固有風險；您應自行了解並承擔。",
            "7.4 鏈上筆記與協定風險：鏈上筆記及相關協定具有網路異常、合約漏洞、治理分叉等固有風險；您應自行了解並承擔。",
        ),
    ],
    "en": [
        (
            "7.4 Crypto and protocol risks: digital assets and protocols involve price volatility, bugs, forks, and other risks—you assume them.",
            "7.4 On-chain notes and protocol risks: on-chain notes and related protocols involve network issues, contract bugs, forks, and other risks—you assume them.",
        ),
    ],
    "ja": [
        (
            "7.4 暗号資産・プロトコルのリスク：価格変動、バグ、フォーク等のリスクがあります。利用者が理解し負担します。",
            "7.4 オンチェーンノートとプロトコルのリスク：オンチェーンノートおよび関連プロトコルには、ネットワーク障害、コントラクトの不具合、フォーク等のリスクがあります。利用者が理解し負担します。",
        ),
    ],
    "ko": [
        (
            "7.4 암호자산·프로토콜 위험: 가격 변동, 버그, 포크 등 고유 위험이 있으며 사용자가 이해하고 부담합니다.",
            "7.4 온체인 노트 및 프로토콜 위험: 온체인 노트 및 관련 프로토콜에는 네트워크 이상, 버그, 포크 등 고유 위험이 있으며 사용자가 이해하고 부담합니다.",
        ),
    ],
}

TERMS03_REPLACEMENTS: dict[str, list[tuple[str, str]]] = {
    "zh": [("恢复资产的唯一有效凭据", "恢复笔记的唯一有效凭据")],
    "zh_TW": [("恢復資產的唯一起效憑據", "恢復筆記的唯一起效憑據")],
    "en": [("recover assets—", "recover notes—")],
    "ja": [("資産を復元するための重要な手段の一つ", "ノートを復元するための重要な手段の一つ")],
    "ko": [("자산 복구의 실질적 수단", "노트 복구의 실질적 수단")],
}

def main() -> None:
    locale_files = {
        "zh": ROOT / "app_zh.arb",
        "zh_TW": ROOT / "app_zh_TW.arb",
        "en": ROOT / "app_en.arb",
        "ja": ROOT / "app_ja.arb",
        "ko": ROOT / "app_ko.arb",
    }
    for locale, path in locale_files.items():
        data = json.loads(path.read_text(encoding="utf-8"))
        overrides = LOCALE_OVERRIDES.get(locale, {})
        for key, value in overrides.items():
            if key in data:
                data[key] = value
            else:
                print(f"WARN {locale}: missing key {key}")

        for key, replacements in (
            ("termsOfServiceSection03Body", TERMS03_REPLACEMENTS),
            ("termsOfServiceSection07Body", TERMS07_4_REPLACEMENTS),
        ):
            if key in data and locale in replacements:
                body = data[key]
                for old, new in replacements[locale]:
                    body = body.replace(old, new)
                data[key] = body

        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"Updated {path.name}")

if __name__ == "__main__":
    main()
