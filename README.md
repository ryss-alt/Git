# iPhone × Claude × セカンドブレイン

iPhone の Claude Code アプリだけで運営する、セカンドブレイン（第二の脳）ブランドの運用リポジトリ。

## コンセプト

- 日本語：「AI と一緒に暮らす知的生産の実験記」
- 英語：`Claude-powered Second Brain for an iPhone-only workflow`

note（日本語・月額マガジン）と Etsy（英語・Notion テンプレ）の 2 市場で、どちらも underserved のセカンドブレインというニッチで戦う。

## 目標

- **月 20 万円以上**の生活費を本ブランド単体で到達させる
- 6 ヶ月目でライン突破、12 ヶ月目で月 30 万円到達を想定

## 予算

**Claude Code（iPhone アプリに含まれる範囲）以外は 0 円。**

Claude API はコスト発生するため一切使わない。Claude 関連の処理はすべて iPhone Claude Code セッション内で完結させる。GitHub Actions の無料枠（2000 分/月）、Etsy / Pinterest の無料 API のみで自動化を組む。

## ディレクトリ構成

```
.
├─ README.md                # このファイル
├─ CLAUDE.md                # Claude Code セッションの作業規範
├─ brand.yaml               # ブランドボイス・世界観定義
├─ content/
│  ├─ drafts/               # note 用 Markdown 下書き（Claude Code が生成）
│  └─ published/            # 公開済み記事のアーカイブ
├─ products/
│  └─ etsy/                 # Etsy 用 Notion テンプレ JSON + 商品説明
├─ pins/                    # Pinterest 投稿定義 YAML
├─ scripts/                 # 自動化スクリプト（Month 2 以降に追加）
└─ .github/workflows/       # GitHub Actions（Month 2 以降に追加）
```

## 運用フロー

### 日々（iPhone で完結）
1. Claude Code セッションで `CLAUDE.md` と `brand.yaml` を参照させる
2. 「今週の note 記事書いて」と依頼 → `content/drafts/week-NN.md` が生成
3. iPhone Safari で note を開き、生成された Markdown をコピペして公開
4. 公開済みファイルを `content/published/` に移動

### Month 2 以降
- Etsy 用 Notion テンプレを Claude Code に生成させ、GitHub Actions が自動アップロード
- Pinterest ピンを GitHub Actions から自動投稿

## 撤退基準

- **3 ヶ月で note 購読 30 人未満** → 単品販売主体に切替
- **6 ヶ月で合計月収 5 万円未満** → Claude Code 代行業を並走追加
- **12 ヶ月で目標未達** → テーマ再設計または完全別モデルへ転換

## 計画書

詳細は `/root/.claude/plans/iphone-claude-code-a8-delegated-minsky.md` に記載。
