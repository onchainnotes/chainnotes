#!/usr/bin/env python3
"""Merge Help Center strings into lib/l10n/app_*.arb (run from repo root: python3 tools/merge_help_center_l10n.py)"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
L10N = ROOT / "lib" / "l10n"

COMMON_UI = {
    "helpCenterSubtitle": {
        "en": "FAQ & user guide",
        "zh": "常见问题与使用指南",
        "zh_TW": "常見問題與使用指南",
        "ja": "よくある質問とガイド",
        "ko": "자주 묻는 질문 및 이용 안내",
    },
    "helpSectionQuickGuide": {
        "en": "Quick guides",
        "zh": "快速指南",
        "zh_TW": "快速指南",
        "ja": "クイックガイド",
        "ko": "빠른 안내",
    },
    "helpSectionFaq": {
        "en": "FAQ",
        "zh": "常见问题",
        "zh_TW": "常見問題",
        "ja": "よくある質問",
        "ko": "자주 묻는 질문",
    },
    "helpSearchHint": {
        "en": "Search questions…",
        "zh": "搜索问题…",
        "zh_TW": "搜尋問題…",
        "ja": "質問を検索…",
        "ko": "질문 검색…",
    },
    "helpCategoryAll": {
        "en": "All",
        "zh": "全部",
        "zh_TW": "全部",
        "ja": "すべて",
        "ko": "전체",
    },
    "helpCategoryBasics": {
        "en": "Basics",
        "zh": "基础使用",
        "zh_TW": "基礎使用",
        "ja": "基本操作",
        "ko": "기본 사용",
    },
    "helpCategoryBlockchain": {
        "en": "Blockchain",
        "zh": "区块链",
        "zh_TW": "區塊鏈",
        "ja": "ブロックチェーン",
        "ko": "블록체인",
    },
    "helpCategoryWalletSecurity": {
        "en": "Wallet security",
        "zh": "钱包安全",
        "zh_TW": "錢包安全",
        "ja": "ウォレットの安全",
        "ko": "지갑 보안",
    },
    "helpCategoryWalletMgmt": {
        "en": "Wallet management",
        "zh": "钱包管理",
        "zh_TW": "錢包管理",
        "ja": "ウォレット管理",
        "ko": "지갑 관리",
    },
    "helpCategoryAdvanced": {
        "en": "Advanced",
        "zh": "高级功能",
        "zh_TW": "進階功能",
        "ja": "高度な機能",
        "ko": "고급 기능",
    },
    "helpCategoryCommon": {
        "en": "Common issues",
        "zh": "常见问题",
        "zh_TW": "常見問題",
        "ja": "よくあるトラブル",
        "ko": "자주 있는 문제",
    },
    "helpComingSoon": {
        "en": "Coming soon",
        "zh": "敬请期待",
        "zh_TW": "敬請期待",
        "ja": "近日公開",
        "ko": "곧 제공 예정",
    },
    "helpEmptyTitle": {
        "en": "No matching questions",
        "zh": "没有找到相关问题",
        "zh_TW": "找不到相關問題",
        "ja": "該当する質問がありません",
        "ko": "일치하는 질문이 없습니다",
    },
    "helpEmptySubtitle": {
        "en": "Try other keywords or contact support",
        "zh": "试试其他关键词或联系客服",
        "zh_TW": "試試其他關鍵字或聯絡客服",
        "ja": "別のキーワードを試すかサポートへ",
        "ko": "다른 키워드를 시도하거나 고객 지원으로 문의하세요",
    },
    "helpContactTitle": {
        "en": "Contact support",
        "zh": "联系客服",
        "zh_TW": "聯絡客服",
        "ja": "サポートに連絡",
        "ko": "고객 지원",
    },
    "helpContactSubtitle": {
        "en": "No answer? Email us",
        "zh": "没有找到答案？发送邮件给我们",
        "zh_TW": "找不到答案？請寄信給我們",
        "ja": "回答がない場合はメールで",
        "ko": "답이 없으면 이메일로 문의하세요",
    },
    "helpContactSendFeedback": {
        "en": "Send feedback",
        "zh": "发送反馈",
        "zh_TW": "傳送意見",
        "ja": "フィードバックを送る",
        "ko": "의견 보내기",
    },
    "helpContactYourEmailOptional": {
        "en": "Your email (optional)",
        "zh": "您的邮箱（选填）",
        "zh_TW": "您的電子郵件（選填）",
        "ja": "メール（任意）",
        "ko": "이메일（선택）",
    },
    "helpContactEmailHint": {
        "en": "",
        "zh": "",
        "zh_TW": "",
        "ja": "",
        "ko": "",
    },
    "helpContactMessageLabel": {
        "en": "Message",
        "zh": "反馈内容",
        "zh_TW": "意見內容",
        "ja": "内容",
        "ko": "내용",
    },
    "helpContactMessageHint": {
        "en": "Describe your issue or suggestion…",
        "zh": "请描述您遇到的问题或建议…",
        "zh_TW": "請描述您遇到的問題或建議…",
        "ja": "問題やご提案を入力…",
        "ko": "문제나 제안을 입력하세요…",
    },
    "helpContactSending": {
        "en": "Sending…",
        "zh": "发送中…",
        "zh_TW": "傳送中…",
        "ja": "送信中…",
        "ko": "전송 중…",
    },
    "helpContactSend": {
        "en": "Send",
        "zh": "发送",
        "zh_TW": "傳送",
        "ja": "送信",
        "ko": "보내기",
    },
    "helpCopySupportEmail": {
        "en": "Email address copied",
        "zh": "邮箱地址已复制",
        "zh_TW": "已複製電子郵件地址",
        "ja": "メールアドレスをコピーしました",
        "ko": "이메일 주소가 복사되었습니다",
    },
    "helpFeedbackEmpty": {
        "en": "Please enter your feedback",
        "zh": "请输入反馈内容",
        "zh_TW": "請輸入意見內容",
        "ja": "フィードバックを入力してください",
        "ko": "의견을 입력하세요",
    },
    "helpFeedbackThanks": {
        "en": "Thank you for your feedback!",
        "zh": "感谢您的反馈！",
        "zh_TW": "感謝您的意見！",
        "ja": "ありがとうございます！",
        "ko": "피드백 감사합니다!",
    },
    "helpFeedbackMailFailed": {
        "en": "Could not open email. Try again later.",
        "zh": "打开邮件失败，请稍后重试",
        "zh_TW": "無法開啟郵件，請稍後再試",
        "ja": "メールを開けませんでした",
        "ko": "메일을 열 수 없습니다. 나중에 다시 시도하세요.",
    },
    "helpFeedbackMailSubject": {
        "en": "User feedback",
        "zh": "用户反馈",
        "zh_TW": "使用者意見",
        "ja": "ユーザーフィードバック",
        "ko": "사용자 의견",
    },
    "helpQuickGuide1Title": {
        "en": "Quick start",
        "zh": "快速入门",
        "zh_TW": "快速入門",
        "ja": "クイックスタート",
        "ko": "빠른 시작",
    },
    "helpQuickGuide1Desc": {
        "en": "Learn the basics in 5 minutes",
        "zh": "5分钟了解链上笔记的基本功能",
        "zh_TW": "5 分鐘了解鏈上筆記的基本功能",
        "ja": "5分で基本機能を把握",
        "ko": "5분 안에 기본 기능 알아보기",
    },
    "helpQuickGuide2Title": {
        "en": "Create your first note",
        "zh": "创建第一条笔记",
        "zh_TW": "建立第一篇筆記",
        "ja": "最初のノートを作成",
        "ko": "첫 번째 노트 만들기",
    },
    "helpQuickGuide2Desc": {
        "en": "Create a note and publish on-chain",
        "zh": "手把手教您创建并上链保存笔记",
        "zh_TW": "建立並上鏈儲存筆記的步驟說明",
        "ja": "ノートを作成してオンチェーン保存",
        "ko": "노트를 만들고 온체인에 게시",
    },
    "helpQuickGuide3Title": {
        "en": "Back up your mnemonic",
        "zh": "备份助记词",
        "zh_TW": "備份助記詞",
        "ja": "ニーモニックのバックアップ",
        "ko": "니모닉 백업",
    },
    "helpQuickGuide3Desc": {
        "en": "Keep your assets and data safe",
        "zh": "确保您的资产和数据安全",
        "zh_TW": "確保您的資產與資料安全",
        "ja": "資産とデータを守る",
        "ko": "자산과 데이터를 안전하게",
    },
    "helpQuickGuide4Title": {
        "en": "Manage multiple wallets",
        "zh": "管理多个钱包",
        "zh_TW": "管理多個錢包",
        "ja": "複数ウォレットの管理",
        "ko": "여러 지갑 관리",
    },
    "helpQuickGuide4Desc": {
        "en": "Create, import, and switch wallets",
        "zh": "创建、导入和切换钱包",
        "zh_TW": "建立、匯入與切換錢包",
        "ja": "作成・インポート・切り替え",
        "ko": "만들기, 가져오기 및 전환",
    },
}

def faq_pairs_zh():
    return [
        (
            "什么是链上笔记？",
            "链上笔记是一个基于区块链技术的笔记应用。您可以将笔记永久保存到区块链上，实现数据的不可篡改和永久保存。笔记一旦上链，任何人都无法修改或删除，确保内容的真实性和可追溯性。",
        ),
        (
            "如何创建一条新笔记？",
            "您可以通过以下方式创建笔记：\n1. 在首页点击“创建笔记”按钮\n2. 在笔记页面点击右下角的“+”按钮\n3. 创建后可以添加标题、内容和图片",
        ),
        (
            "笔记有哪些保存方式？",
            "系统提供三种保存方式：\n1. 保存为草稿：本地保存，可随时编辑\n2. 保存到本地：完成编辑，本地存储\n3. 上链保存：永久保存到区块链，不可修改\n\n建议先保存为草稿，确认内容无误后再选择上链保存。",
        ),
        (
            "什么是上链保存？需要付费吗？",
            "上链保存是指将笔记内容通过区块链技术永久存储。上链需要支付 Gas 费用（网络手续费），这是由区块链网络收取的，并非应用费用。不同区块链网络的 Gas 费用不同，通常 L2 网络（如 Arbitrum、Optimism）的费用更低。",
        ),
        (
            "支持哪些区块链网络？",
            "目前支持 8 条主流区块链：\n• Ethereum（以太坊主网）\n• BSC（币安智能链）\n• Polygon（马蹄链）\n• Arbitrum（L2 网络）\n• Optimism（L2 网络）\n• Avalanche（雪崩链）\n• Fantom（FTM 链）\n• Base（Base 链）\n\n您可以在首页随时切换网络。",
        ),
        (
            "如何验证笔记是否真的上链了？",
            "笔记上链后会生成区块链哈希值（Hash），您可以：\n1. 在笔记详情页查看哈希值\n2. 点击“验证”按钮查看完整的区块链信息\n3. 复制哈希值到对应链的区块链浏览器查询\n\n系统会显示该笔记在区块链上的完整记录。",
        ),
        (
            "什么是助记词？为什么要备份？",
            "助记词是恢复钱包的唯一凭证，通常由 12 个英文单词组成。它是您钱包的“主密钥”。\n\n重要性：\n• 助记词丢失 = 钱包永久丢失\n• 助记词泄露 = 资产完全丢失\n• 应用无法帮您找回助记词\n\n务必妥善保管，建议抄写在纸上保存在安全的地方。",
        ),
        (
            "如何备份助记词？",
            "备份助记词的步骤：\n1. 进入“我的”页面\n2. 点击“备份助记词”\n3. 阅读安全提示\n4. 抄写 12 个助记词\n5. 按顺序验证助记词\n6. 完成备份\n\n注意：请在安全的环境下备份，确保无人窥视。",
        ),
        (
            "私钥和助记词有什么区别？",
            "助记词和私钥都可以恢复钱包，但有所不同：\n\n助记词：\n• 12 个英文单词\n• 易于抄写和记忆\n• 可以派生多个私钥\n• 推荐的备份方式\n\n私钥：\n• 64 位十六进制字符串\n• 难以记忆\n• 对应单个地址\n• 适合高级用户",
        ),
        (
            "如何切换钱包？",
            "切换钱包的方法：\n1. 点击首页顶部的钱包地址\n2. 在弹出的钱包选择器中选择要切换的钱包\n3. 或点击“钱包管理”创建/导入新钱包\n\n系统支持管理多个钱包，可随时切换。",
        ),
        (
            "如何查看不同链的地址？",
            "在“我的钱包”页面：\n1. 点击钱包卡片右侧的下拉箭头\n2. 会展开显示所有支持的 8 条链\n3. 每条链都显示对应的地址\n4. 点击地址可以快速复制\n\n注意：同一个钱包在不同链上的地址是相同的（EVM 兼容链）。",
        ),
        (
            "如何自定义 RPC 节点？",
            "自定义 RPC 节点的步骤：\n1. 进入“我的”→“网络设置”\n2. 选择要配置的网络\n3. 点击“添加节点”按钮\n4. 输入节点名称和 RPC URL\n5. 测试连接\n6. 设为默认节点\n\n自定义节点可以提高连接速度和稳定性。",
        ),
        (
            "富文本编辑器支持哪些格式？",
            "富文本编辑器支持多种格式：\n• 粗体、斜体、下划线\n• 标题（H1-H3）\n• 有序列表、无序列表\n• 引用块\n• 代码块\n• 图片上传\n\n使用工具栏按钮即可快速格式化文本。",
        ),
        (
            "上链后的笔记可以修改或删除吗？",
            "不可以。这正是区块链技术的特点：\n\n上链后：\n• 内容永久保存\n• 无法修改\n• 无法删除\n• 任何人都无法篡改\n\n因此建议：\n1. 先保存为草稿反复修改\n2. 确认无误后再上链\n3. 敏感信息不要上链",
        ),
        (
            "为什么上链需要等待？",
            "Gas 费用确认后，笔记会提交到区块链网络。等待时间取决于：\n\n1. 网络拥堵程度\n2. 您选择的 Gas 速度\n   • 快速：15-30 秒\n   • 标准：1-2 分钟\n   • 慢速：3-5 分钟\n3. 区块确认时间\n\n通常 1-2 分钟即可完成。",
        ),
        (
            "忘记密码怎么办？",
            "如果忘记密码：\n\n1. 可以使用助记词重新导入钱包\n2. 导入后重新设置密码\n3. 原有的笔记数据会保留\n\n重要提醒：\n• 密码用于本地加密\n• 助记词是最终凭证\n• 务必备份助记词",
        ),
    ]

def faq_pairs_en():
    return [
        (
            "What is On Chain Notes?",
            "On Chain Notes lets you store notes permanently on a blockchain so content stays tamper-evident and traceable. Once published on-chain, it typically cannot be changed or removed.",
        ),
        (
            "How do I create a note?",
            "You can:\n1. Tap “Create note” on the home screen\n2. Or tap the “+” button on the notes page\n3. Add title, content, and images",
        ),
        (
            "What save options are available?",
            "There are three options:\n1. Draft: saved locally, editable anytime\n2. Local save: finalized locally\n3. On-chain: permanent on blockchain, not editable\n\nWe recommend using a draft first, then publishing when ready.",
        ),
        (
            "What is on-chain save? Do I pay?",
            "On-chain save stores your note on-chain permanently. You pay network fees (Gas) charged by the blockchain, not an app fee. Fees vary by network; many L2s are cheaper.",
        ),
        (
            "Which networks are supported?",
            "The app supports eight mainstream EVM networks, including Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Fantom, and Base. You can switch networks from the home screen.",
        ),
        (
            "How do I verify a note is on-chain?",
            "After publishing, you get a transaction hash. In note details you can view the hash, use Verify, or copy the hash to a block explorer for that network.",
        ),
        (
            "What is a mnemonic? Why back it up?",
            "A mnemonic (often 12 English words) is the master key to recover your wallet.\n\nIf you lose it, you may lose access forever.\nIf it leaks, funds can be stolen.\nThe app cannot recover it for you.\nWrite it on paper and store it safely.",
        ),
        (
            "How do I back up my mnemonic?",
            "1. Open Profile\n2. Tap backup mnemonic\n3. Read the warnings\n4. Write down all words in order\n5. Verify in order\n6. Finish backup\n\nDo this in a private environment.",
        ),
        (
            "Mnemonic vs private key?",
            "Both can restore a wallet.\n\nMnemonic: 12 words, easier to write down, derives keys (recommended backup).\n\nPrivate key: long hex string, harder to handle, single address (advanced users).",
        ),
        (
            "How do I switch wallets?",
            "1. Tap the wallet address on the home header\n2. Pick another wallet in the selector\n3. Or go to Wallet management to create/import\n\nYou can manage multiple wallets.",
        ),
        (
            "How do I see addresses on other chains?",
            "In My wallet:\n1. Expand the card with the arrow\n2. See supported chains and addresses\n3. Tap to copy\n\nFor EVM-compatible chains, the address format is the same.",
        ),
        (
            "How do I customize an RPC node?",
            "1. Profile → Network settings\n2. Choose a network\n3. Add node\n4. Enter name and RPC URL\n5. Test connection\n6. Set as default\n\nCustom RPC can improve speed and reliability.",
        ),
        (
            "What rich text formats are supported?",
            "Bold, italic, underline, headings (H1–H3), ordered/bullet lists, quotes, code blocks, and image upload—via the editor toolbar.",
        ),
        (
            "Can on-chain notes be edited or deleted?",
            "Generally not—that is a property of blockchains.\n\nPublished notes are permanent and tamper-evident.\nUse drafts to iterate, then publish only when sure. Avoid putting highly sensitive data on-chain.",
        ),
        (
            "Why does on-chain publishing take time?",
            "After fees are accepted, the transaction must be mined. Time depends on congestion and gas speed (fast often ~15–30s, standard ~1–2m, slow longer). Usually under a couple of minutes.",
        ),
        (
            "What if I forgot my password?",
            "You can re-import the wallet with your mnemonic and set a new password. Local data may be retained depending on your setup.\n\nRemember: password encrypts locally; mnemonic is the ultimate recovery key—keep it backed up.",
        ),
    ]

def _to_zh_tw(text: str) -> str:
    pairs = [
        ("网络", "網路"),
        ("钱包", "錢包"),
        ("点击", "點擊"),
        ("设置", "設定"),
        ("联系", "聯絡"),
        ("页面", "頁面"),
        ("导入", "匯入"),
        ("记录", "記錄"),
        ("验证", "驗證"),
        ("浏览器", "瀏覽器"),
        ("区块链", "區塊鏈"),
        ("帐户", "帳戶"),
        ("账户", "帳戶"),
        ("数字", "數位"),
        ("激活", "啟用"),
        ("实现", "實現"),
        ("发", "發"),
        ("开", "開"),
        ("链", "鏈"),
        ("币", "幣"),
        ("过", "過"),
        ("进", "進"),
        ("际", "際"),
        ("东", "東"),
        ("选", "選"),
        ("钟", "鐘"),
        ("汇", "匯"),
        ("总", "總"),
        ("众", "眾"),
        ("优", "優"),
        ("关闭", "關閉"),
        ("说明", "說明"),
        ("高级", "進階"),
    ]
    for a, b in pairs:
        text = text.replace(a, b)
    return text

def faq_pairs_zh_tw():
    return [(_to_zh_tw(q), _to_zh_tw(a)) for q, a in faq_pairs_zh()]

def faq_pairs_ja():
    return [
        ("オンチェーンノートとは？", "ブロックチェーン上にノートを永続保存するアプリです。一度オンチェーンに載せると改ざん耐性と追跡性が高まり、原則として変更・削除はできません。"),
        ("ノートの作成方法は？", "ホームの「ノート作成」、またはノート一覧の「+」から作成します。タイトル・本文・画像を追加できます。"),
        ("保存方法は？", "下書き（いつでも編集）・ローカル保存・オンチェーン保存の3種類です。まず下書きで校正してから公開することをおすすめします。"),
        ("オンチェーン保存と手数料は？", "オンチェーン保存はブロックチェーンに永続記録します。ガス代はネットワークが請求し、ネットワークごとに異なります。"),
        ("対応ネットワークは？", "Ethereum、BSC、Polygon、Arbitrum、Optimism、Avalanche、Fantom、Base など主要EVMをサポートします。ホームで切り替え可能です。"),
        ("オンチェーンを確認するには？", "トランザクションハッシュを詳細画面やブロックエクスプローラーで確認できます。「検証」機能も利用できます。"),
        ("ニーモニックとは？バックアップは？", "多くの場合12語の英単語で、ウォレット復元の要です。紛失や流出は致命的です。紙に書き安全に保管してください。"),
        ("ニーモニックのバックアップ手順は？", "マイページ→バックアップ→注意事項を読む→順に書き写す→確認→完了。他者が見えない環境で行ってください。"),
        ("ニーモニックと秘密鍵の違いは？", "どちらも復元に使えます。ニーモニックは単語列で扱いやすく推奨。秘密鍵は長い16進で上級者向けです。"),
        ("ウォレットの切り替えは？", "ホーム上部のアドレスをタップして選択、またはウォレット管理で作成・インポートします。複数管理に対応します。"),
        ("チェーンごとのアドレスは？", "マイウォレットでカードを展開すると各チェーンのアドレスが表示され、タップでコピーできます。EVM互換では同一形式のアドレスになります。"),
        ("RPCをカスタムするには？", "マイページ→ネットワーク設定→ネットを選ぶ→ノード追加→URL入力→テスト→既定に設定。安定性向上に役立ちます。"),
        ("リッチテキストの対応は？", "太字・斜体・下線、見出し、リスト、引用、コード、画像アップロードなどに対応します。"),
        ("オンチェーン後に編集・削除できる？", "原則できません。下書きで十分に推敲してから公開し、機密は載せないようご注意ください。"),
        ("なぜ待ち時間がある？", "取引がマイニングされるまで時間がかかります。混雑とガス速度（速/標準/遅）に依存し、多くは数分以内です。"),
        ("パスワードを忘れたら？", "ニーモニックで再インポートして新パスワードを設定できます。パスワードは端末暗号化、最終的な復元はニーモニックです。"),
    ]

def faq_pairs_ko():
    return [
        ("온체인 노트란?", "블록체인에 노트를 영구 저장하는 앱입니다. 온체인에 게시되면 원칙적으로 변경·삭제가 어렵습니다."),
        ("노트는 어떻게 만드나요?", "홈의 ‘노트 만들기’ 또는 목록의 ‘+’로 생성합니다. 제목·본문·이미지를 추가할 수 있습니다."),
        ("저장 방식은?", "초안(언제든 편집)·로컬 저장·온체인 저장 세 가지입니다. 먼저 초안으로 다듬은 뒤 게시하는 것을 권장합니다."),
        ("온체인 저장과 수수료는?", "블록체인에 영구 기록됩니다. 가스 비용은 네트워크가 부과하며 네트워크마다 다릅니다."),
        ("지원 네트워크는?", "Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche, Fantom, Base 등 주요 EVM을 지원합니다. 홈에서 전환합니다."),
        ("온체인 여부는 어떻게 확인하나요?", "트랜잭션 해시를 상세 화면이나 블록 익스플로러에서 확인할 수 있습니다."),
        ("니모닉이란? 백업은?", "보통 12개 영단어로 지갑을 복구합니다. 분실·유출은 치명적입니다. 종이에 적어 안전하게 보관하세요."),
        ("니모닉 백업 순서는?", "프로필→백업→안내 확인→순서대로 적기→검증→완료. 타인이 볼 수 없는 곳에서 진행하세요."),
        ("니모닉과 개인 키 차이는?", "둘 다 복구에 사용됩니다. 니모닉은 단어열로 다루기 쉽고 권장됩니다. 개인 키는 긴 16진 문자열로 고급 사용자용입니다."),
        ("지갑 전환은?", "홈 상단 주소를 눌러 선택하거나 지갑 관리에서 생성·가져오기를 합니다. 여러 지갑을 관리할 수 있습니다."),
        ("체인별 주소는?", "내 지갑에서 카드를 펼치면 각 체인 주소가 보이며 탭으로 복사합니다. EVM 호환 체인은 같은 형식의 주소입니다."),
        ("RPC 사용자 정의는?", "프로필→네트워크 설정→네트워크 선택→노드 추가→URL 입력→테스트→기본 설정. 안정성에 도움이 됩니다."),
        ("리치 텍스트 지원은?", "굵게·기울임·밑줄, 제목, 목록, 인용, 코드, 이미지 업로드 등을 지원합니다."),
        ("온체인 후 수정·삭제가 되나요?", "원칙적으로 불가능합니다. 초안에서 충분히 검토한 뒤 게시하고 민감 정보는 올리지 마세요."),
        ("왜 대기 시간이 있나요?", "트랜잭션이 채굴될 때까지 걸립니다. 혼잡도와 가스 속도에 따라 보통 수분 이내입니다."),
        ("비밀번호를 잊었어요?", "니모닉으로 다시 가져온 뒤 새 비밀번호를 설정할 수 있습니다. 비밀번호는 기기 암호화용이며 최종 복구는 니모닉입니다."),
    ]

def build_faq_dict(pairs, lang_key):
    out = {}
    for i, (q, a) in enumerate(pairs, 1):
        out[f"helpFaq{i}Question"] = q
        out[f"helpFaq{i}Answer"] = a
    return out

def merge_locale(filename: str, lang: str):
    path = L10N / filename
    data = json.loads(path.read_text(encoding="utf-8"))
    extra = {}
    for key, langs in COMMON_UI.items():
        extra[key] = langs[lang]
    if lang == "zh":
        extra.update(build_faq_dict(faq_pairs_zh(), lang))
    elif lang == "en":
        extra.update(build_faq_dict(faq_pairs_en(), lang))
    elif lang == "zh_TW":
        extra.update(build_faq_dict(faq_pairs_zh_tw(), lang))
    elif lang == "ja":
        extra.update(build_faq_dict(faq_pairs_ja(), lang))
    elif lang == "ko":
        extra.update(build_faq_dict(faq_pairs_ko(), lang))
    data.update(extra)
    # @helpFeedbackMailBody
    data["@helpFeedbackMailBody"] = {
        "placeholders": {
            "email": {"type": "String"},
            "message": {"type": "String"},
        }
    }
    msgs = {
        "en": "Contact email: {email}\n\n{message}",
        "zh": "联系邮箱：{email}\n\n{message}",
        "zh_TW": "聯絡電子郵件：{email}\n\n{message}",
        "ja": "連絡メール：{email}\n\n{message}",
        "ko": "연락 이메일: {email}\n\n{message}",
    }
    data["helpFeedbackMailBody"] = msgs[lang]
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

def main():
    merge_locale("app_en.arb", "en")
    merge_locale("app_zh.arb", "zh")
    merge_locale("app_zh_TW.arb", "zh_TW")
    merge_locale("app_ja.arb", "ja")
    merge_locale("app_ko.arb", "ko")
    print("Merged help center strings into app_*.arb")

if __name__ == "__main__":
    main()
