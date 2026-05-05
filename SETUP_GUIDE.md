# Agent Manager セットアップ＆同期ガイド

このリポジトリ (`shared-ag-core`) は、複数プロジェクト・複数PC間でAIエージェントのルールやワークフロー (Skill) を共有・同期するための「マスター（大元）」です。

以下の手順に従って、**「他のPCで作成したSkillをこのリポジトリにまとめる」**作業と、**「新しいPC/プロジェクトでその設定を利用する」**作業を行ってください。

---

## 1. 他のPC（Skillを作成したPC）でやるべき作業

このPCでは、作成したSkill（ワークフローや追加ルール）を `shared-ag-core` にコミットし、GitHubへPushします。

### 手順
1. エクスプローラー等で、このリポジトリ (`shared-ag-core`) のフォルダを開きます。
2. 作成・変更したルールやワークフローファイル（`.agent/workflows` 内のファイルなど）を、この `shared-ag-core/ai-rules/.agent/` 配下にコピーして配置します。
3. PowerShellまたはターミナルを開き、以下のコマンドを実行してGitHubへPushします。

```powershell
# 1. 変更内容を確認
git status

# 2. 変更をステージング
git add .

# 3. コミットを作成
git commit -m "Add new skills and workflows from other PC"

# 4. GitHubへPush
git push origin master
```
※ `master` が現在のブランチ名です。もし `main` ブランチを使っている場合は `main` に変更してください。

---

## 2. 新しいPC（または現在のPC）で設定を同期・適用する作業

別のPCでPushしたSkillを、こちらのPCにPullして同期し、新規プロジェクトの作成に利用します。

### 手順
1. PowerShellを開き、この `shared-ag-core` フォルダに移動して最新版をPullします。

```powershell
cd c:\Users\farwe\antigravity\shared-ag-core
git pull origin master
```

2. 新しいプロジェクトを作成し、ルールを適用するには、自動化スクリプトを実行します。

```powershell
cd c:\Users\farwe\antigravity\shared-ag-core\utils

# 新しいプロジェクト「MyNewProject」を作成し、AIルールをシンボリックリンクで適用する
.\New-AgentProject.ps1 -ProjectName "MyNewProject" -UseSymlink
```

### スクリプト `New-AgentProject.ps1` が自動で行うこと
- 指定した名前のプロジェクトフォルダの作成
- 標準フォルダ構成（`Application`, `Documents`, `Progress`, `Project AI Rules`, `AI`）の自動生成
- `shared-ag-core/ai-rules/.agent` を、新しいプロジェクト内にシンボリックリンク（Junction）として配置
  - これにより、今後 `shared-ag-core` を `git pull` するだけで、すべてのプロジェクトのAIルールが自動で最新に保たれます。
- `project_rules.md`、`phase_management.md` などの必須ファイルのテンプレートを自動配置
- `git init` によるプロジェクト固有のGitリポジトリ初期化

---

> **💡 Tips:** 各プロジェクトごとの固有のルール（技術スタックや特定の要件など）は、共有の `.agent` フォルダには入れず、各プロジェクト内の `Project AI Rules/project_rules.md` に記載してください。
