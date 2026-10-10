#!/usr/bin/env python3
"""Update user-facing wallet terminology across l10n ARB files."""

from __future__ import annotations

import json
import re
from pathlib import Path

L10N_DIR = Path(__file__).resolve().parents[1] / "lib" / "l10n"

# Order matters: longer / more specific phrases first.
ZH_REPLACEMENTS = [
    ("我的钱包账户", "我的账户"),
    ("钱包账户", "账户"),
    ("Web3钱包", "链上账户"),
    ("数字钱包", "数字账户"),
    ("导入钱包", "恢复账户"),
    ("钱包地址", "账户地址"),
    ("助记词", "恢复短语"),
    ("确认并签名", "确认并安全验证"),
    ("签名确认", "安全验证确认"),
    ("签名与广播", "安全验证与广播"),
    ("钱包", "账户"),
]

ZH_TW_REPLACEMENTS = [
    ("我的錢包帳戶", "我的帳戶"),
    ("錢包帳戶", "帳戶"),
    ("Web3錢包", "鏈上帳戶"),
    ("數位錢包", "數位帳戶"),
    ("匯入錢包", "恢復帳戶"),
    ("導入錢包", "恢復帳戶"),
    ("錢包位址", "帳戶位址"),
    ("錢包地址", "帳戶地址"),
    ("助記詞", "恢復短語"),
    ("確認並簽名", "確認並安全驗證"),
    ("簽名確認", "安全驗證確認"),
    ("簽名與廣播", "安全驗證與廣播"),
    ("錢包", "帳戶"),
]

EN_REPLACEMENTS = [
    ("My wallet account", "My account"),
    ("wallet account", "account"),
    ("Web3 wallet", "On-chain account"),
    ("Digital wallet", "Digital account"),
    ("Import existing wallet", "Restore existing account"),
    ("import existing wallet", "restore existing account"),
    ("Import wallet", "Restore account"),
    ("import wallet", "restore account"),
    ("Import Wallet", "Restore Account"),
    ("Wallet addresses", "Account addresses"),
    ("wallet addresses", "account addresses"),
    ("Wallet address", "Account address"),
    ("wallet address", "account address"),
    ("Wallet Management", "Account Management"),
    ("wallet management", "account management"),
    ("Confirm and sign", "Confirm verification"),
    ("confirm and sign", "confirm verification"),
    ("After signing", "After security verification"),
    ("after signing", "after security verification"),
    ("before signing and broadcasting", "before security verification and broadcasting"),
    ("Before signing", "Before security verification"),
    ("signing confirms", "security verification confirms"),
    ("Signing", "Security verification"),
    ("signing", "security verification"),
    ("Mnemonic", "Recovery phrase"),
    ("mnemonic", "recovery phrase"),
    ("Wallet", "Account"),
    ("wallet", "account"),
]

JA_REPLACEMENTS = [
    ("Web3ウォレット", "オンチェーンアカウント"),
    ("Web3ウォレット", "オンチェーンアカウント"),
    ("デジタルウォレット", "デジタルアカウント"),
    ("ウォレットをインポート", "アカウントを復元"),
    ("ウォレットのインポート", "アカウントの復元"),
    ("ウォレットアドレス", "アカウントアドレス"),
    ("ニーモニック", "リカバリーフレーズ"),
    ("署名", "セキュリティ認証"),
    ("ウォレット", "アカウント"),
]

KO_REPLACEMENTS = [
    ("Web3 지갑", "온체인 계정"),
    ("디지털 지갑", "디지털 계정"),
    ("지갑 가져오기", "계정 복원"),
    ("지갑을 가져왔", "계정을 복원"),
    ("지갑 주소", "계정 주소"),
    ("니모닉", "복구 구문"),
    ("서명", "보안 인증"),
    ("지갑", "계정"),
]

LOCALE_RULES = {
    "app_zh.arb": ZH_REPLACEMENTS,
    "app_zh_TW.arb": ZH_TW_REPLACEMENTS,
    "app_en.arb": EN_REPLACEMENTS,
    "app_ja.arb": JA_REPLACEMENTS,
    "app_ko.arb": KO_REPLACEMENTS,
}

def apply_rules(text: str, rules: list[tuple[str, str]]) -> str:
    for old, new in rules:
        text = text.replace(old, new)
    return text

def transform_value(value, rules: list[tuple[str, str]]):
    if isinstance(value, str):
        return apply_rules(value, rules)
    if isinstance(value, dict):
        return {k: transform_value(v, rules) for k, v in value.items()}
    if isinstance(value, list):
        return [transform_value(v, rules) for v in value]
    return value

def process_arb(path: Path, rules: list[tuple[str, str]]) -> int:
    raw = path.read_text(encoding="utf-8")
    data = json.loads(raw)
    changed = 0
    out: dict = {}
    for key, value in data.items():
        if key.startswith("@@"):
            out[key] = value
            continue
        if key.startswith("@"):
            out[key] = value
            continue
        new_value = transform_value(value, rules)
        if new_value != value:
            changed += 1
        out[key] = new_value
    path.write_text(
        json.dumps(out, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return changed

def main() -> None:
    for filename, rules in LOCALE_RULES.items():
        path = L10N_DIR / filename
        n = process_arb(path, rules)
        print(f"{filename}: updated {n} entries")

if __name__ == "__main__":
    main()
