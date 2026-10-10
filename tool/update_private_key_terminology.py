#!/usr/bin/env python3
"""Replace user-facing「私钥」/ private key with「安全密钥」/ security key in ARB files."""

from __future__ import annotations

import json
from pathlib import Path

L10N_DIR = Path(__file__).resolve().parents[1] / "lib" / "l10n"

LOCALE_RULES: dict[str, list[tuple[str, str]]] = {
    "app_zh.arb": [
        ("我的私钥账户", "我的安全密钥账户"),
        ("私钥导入", "安全密钥导入"),
        ("私钥", "安全密钥"),
    ],
    "app_zh_TW.arb": [
        ("我的私鑰帳戶", "我的安全密鑰帳戶"),
        ("私鑰匯入", "安全密鑰匯入"),
        ("私鑰導入", "安全密鑰導入"),
        ("私鑰", "安全密鑰"),
    ],
    "app_en.arb": [
        ("Private key–imported", "Security key–imported"),
        ("private key–imported", "security key–imported"),
        ("Private key", "Security key"),
        ("private key", "security key"),
    ],
    "app_ja.arb": [
        ("私钥导入", "安全密钥导入"),  # unlikely in ja file
        ("秘密鍵復元", "セキュリティキー復元"),
        ("秘密鍵", "セキュリティキー"),
    ],
    "app_ko.arb": [
        ("내 개인키 계정", "내 보안 키 계정"),
        ("개인키로 복원", "보안 키로 복원"),
        ("개인키 복원", "보안 키 복원"),
        ("개인키", "보안 키"),
    ],
}

def transform_value(value, rules: list[tuple[str, str]]):
    if isinstance(value, str):
        s = value
        for old, new in rules:
            s = s.replace(old, new)
        return s
    if isinstance(value, dict):
        return {k: transform_value(v, rules) for k, v in value.items()}
    if isinstance(value, list):
        return [transform_value(v, rules) for v in value]
    return value

def process_arb(path: Path, rules: list[tuple[str, str]]) -> int:
    data = json.loads(path.read_text(encoding="utf-8"))
    changed = 0
    out: dict = {}
    for key, value in data.items():
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
        n = process_arb(L10N_DIR / filename, rules)
        print(f"{filename}: {n} entries updated")

if __name__ == "__main__":
    main()
