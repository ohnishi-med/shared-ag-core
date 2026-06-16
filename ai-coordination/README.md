# AI 協調作業ハブ (ai-coordination)

Cursor と Claude Code がタスクを引き継ぎながら協調作業するための共有ハブです。

## フォルダ構成

```
ai-coordination/
├── README.md         ← このファイル
├── HANDOFF.md        ← 現在の引き継ぎ状態（常に最新を維持）
├── roles.md          ← 役割分担の定義
└── handoff-log/      ← 完了済みタスクのアーカイブ
    └── YYYY-MM-DD_task-name.md
```

## 基本的な使い方

### 作業を開始するとき
1. `HANDOFF.md` を読む
2. ステータスを `作業中` に変更し、担当者を自分のツール名に更新する
3. 作業を進める

### 作業を終了・引き継ぐとき
1. `HANDOFF.md` の「完了済みの作業」を更新する
2. 「次にやること」を具体的に記述する
3. 担当者を次の担当（Cursor / Claude Code / Human）に変更する
4. ステータスを適切な値に変更する

### タスクが完了したとき
1. `HANDOFF.md` を `handoff-log/YYYY-MM-DD_task-name.md` にコピーする
2. `HANDOFF.md` を初期状態にリセットする

## 変更履歴の識別ルール

誰（どのAI、または人間）がどの変更を加えたかを明確にするため、以下のルールを適用します。

### 1. Gitコミットメッセージのプレフィックス
コミットを行う際、メッセージの先頭に以下のプレフィックスを必ず付与します。
- **Antigravity**: `[Antigravity] <メッセージ>`
- **Cursor**: `[Cursor] <メッセージ>`
- **Claude Code**: `[Claude] <メッセージ>`
- **Human**: `[Human] <メッセージ>`

### 2. 開発ログ（devlog.md）への記録
プロジェクトの開発ログ（`devlog.md`）に作業を記録する際は、タイトルやセクション名に実行したツール名を明記します。
（例: `## 2026-06-06 13:45 [Antigravity] ○○のバグ修正`）

## スキル共有

共通スキルは `shared-ag-core/ai-rules/.agent/skills/` に格納されています。
CursorもClaude CodeもAntigravityも同じスキル定義を参照します。

利用可能なスキル:
- `app-tester/` — アプリ動作確認
- `code-reviewer/` — コードレビュー
- `dev-logger/` — 開発ログ記録
- `document-writer/` — ドキュメント作成
- `environment-manager/` — 環境管理
- `project-manager/` — プロジェクト管理
- `requirements-definer/` — 要件定義
