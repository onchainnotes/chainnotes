#!/usr/bin/env python3
"""Replace user-facing「账户」with「笔记账户」/ note account equivalents in ARB files."""

from __future__ import annotations

import json
import re
from pathlib import Path

L10N_DIR = Path(__file__).resolve().parents[1] / "lib" / "l10n"

def zh_replace(text: str) -> str:
    if "笔记账户" in text:
        return text
    return text.replace("账户", "笔记账户")

def zh_tw_replace(text: str) -> str:
    if "筆記帳戶" in text:
        return text
    return text.replace("帳戶", "筆記帳戶")

def en_replace(text: str) -> str:
    if re.search(r"note\s+account", text, re.I):
        return text

    def sub_word(match: re.Match[str]) -> str:
        word = match.group(0)
        lower = word.lower()
        is_title = word[0].isupper()
        if lower == "accounts":
            return "Note accounts" if is_title else "note accounts"
        if lower == "account":
            return "Note account" if is_title else "note account"
        return word

    return re.sub(r"\baccounts?\b", sub_word, text, flags=re.IGNORECASE)

def ja_replace(text: str) -> str:
    if "ノートアカウント" in text or "ノートアカウント" in text:
        return text
  # common patterns
    text = text.replace("アカウントパスワード", "ノートアカウントパスワード")
    text = text.replace("アカウント", "ノートアカウント")
    return text

def ko_replace(text: str) -> str:
    if "노트 계정" in text or "노트계정" in text:
        return text
    text = text.replace("계정 비밀번호", "노트 계정 비밀번호")
    text = text.replace("계정", "노트 계정")
    return text

LOCALE_FN = {
    "app_zh.arb": zh_replace,
    "app_zh_TW.arb": zh_tw_replace,
    "app_en.arb": en_replace,
    "app_ja.arb": ja_replace,
    "app_ko.arb": ko_replace,
}

def transform_value(value, fn):
    if isinstance(value, str):
        return fn(value)
    if isinstance(value, dict):
        return {k: transform_value(v, fn) for k, v in value.items()}
    if isinstance(value, list):
        return [transform_value(v, fn) for v in value]
    return value

def process(path: Path, fn) -> int:
    data = json.loads(path.read_text(encoding="utf-8"))
    changed = 0
    out: dict = {}
    for key, value in data.items():
        if key.startswith("@"):
            out[key] = value
            continue
        new_value = transform_value(value, fn)
        if new_value != value:
            changed += 1
        out[key] = new_value
    path.write_text(
        json.dumps(out, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return changed

def main() -> None:
    for name, fn in LOCALE_FN.items():
        n = process(L10N_DIR / name, fn)
        print(f"{name}: {n} entries")

if __name__ == "__main__":
    main()
