# Claude Code 作業規範

このリポジトリで Claude Code が作業するときに守るルール。iPhone Claude Code セッションを開始したら、まず `brand.yaml` と本ファイルを参照すること。

## 世界観（brand.yaml と併読）

- ブランド名：`iPhone × Claude × セカンドブレイン`
- 筆者像：iPhone と Claude だけで知的生産を回す実験者。PC を手放し、AI を第二の脳として使い倒す
- ペルソナ口調：一人称は「私」。丁寧すぎず、冷静で実験報告的。感嘆符を多用しない

## 記事ディレクトリ方針

| ディレクトリ | 内容 |
|---|---|
| `content/drafts/` | 下書き Markdown。命名規則 `week-NN-slug.md` |
| `content/published/` | 公開済みのアーカイブ（note 公開後にここへ移動） |
| `products/etsy/` | Etsy 用 Notion テンプレ JSON + 商品説明（Month 2 以降） |
| `pins/` | Pinterest 投稿用 YAML（Month 3 以降） |

## note 記事フォーマット

```markdown
---
title: <タイトル>
magazine: weekly-second-brain   # または free / paid-single
price: 0 | 980 | 1980
ai_disclosure: true
week: 1
tags: [iPhone, Claude, セカンドブレイン, PKM]
---

# <タイトル>

> 本記事は AI 支援のもと執筆しています。

## 今週の実験

...
```

## 必須ルール

1. **AI 利用開示**：全ての記事・商品説明の冒頭に「本記事/本コンテンツは AI 支援のもと作成」を必ず入れる
2. **断定表現の禁止**：「絶対」「必ず」「確実に」「100%」「誰でも稼げる」等は使わない
3. **著作権**：他者の文章をそのまま引用しない。書籍・記事のアイデアを参考にした場合は出典を明記
4. **薬機法**：健康・医療・ダイエット系の効果効能を断定しない
5. **景表法**：他社サービス紹介時は `#PR` 明示（アフィリエイトリンクは使わない方針だが念のため）

## 生成品質基準

- 文字数：無料記事 1,500〜2,500 字 / 月額マガジン記事 2,500〜4,000 字 / 単発有料 6,000 字以上
- 構成：導入（実験の動機）→ 試した手順 → 結果と数値 → 次週への引き継ぎ
- **数値で語る**：「便利になった」ではなく「メモ検索が 12 秒 → 3 秒になった」
- **スクショ想定を書き込む**：`[スクショ: Claude Code の Memo 出力画面]` のように指定。撮影は人間側

## Etsy 商品生成時（Month 2 以降）

- 言語：英語（商品名・説明文・タグ全て）
- フォーマット：Notion JSON テンプレート + 英語 README.md + セットアップ動画の台本
- タグ：`notion template`, `second brain`, `productivity`, `PKM`, `knowledge management`, `iphone workflow`, `AI productivity`
- 価格帯：$9〜$29

## 禁止ワードリスト（自動チェック対象）

`scripts/ng_words.yaml` に定義（Month 2 で追加）。暫定：

```
- 絶対
- 必ず
- 100%
- 確実に
- 誰でも稼げる
- 即金
- 不労所得
- 奇跡の
- ○○だけで稼ぐ
```

## ワークフロー

1. Claude Code セッション開始時：`README.md` → `brand.yaml` → `CLAUDE.md` の順に読む
2. タスク指示を受けたら該当フェーズ（README の運用フロー参照）に沿って作業
3. 生成物は適切なディレクトリに commit
4. commit メッセージは `content: add week-01 draft` のように conventional commits 風に
