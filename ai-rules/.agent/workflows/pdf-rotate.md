# ワークフロー: pdf-rotate — PDF自動回転処理

## 説明

PDFAutoRotatorツールを使用してPDFファイルの向きを自動修正します。
NAS上のスキャンデータを監視・自動回転する既存スクリプトと連携します。

## 呼び出し方

```
/pdf-rotate
```

---

## 関連ファイル

- スクリプト: `projects/tools/pdf-auto-rotator/auto_rotate_monitor.py`
- 設定: `projects/tools/pdf-auto-rotator/config.json`
- 依存関係: `projects/tools/pdf-auto-rotator/requirements.txt`

## Steps

### Step 1: 実行モードの選択

ユーザーに確認する：

- 🔄 **単発実行** — 指定フォルダのPDFを一括処理
- 👁️ **監視モード起動** — フォルダを監視して自動処理
- ⚙️ **設定確認** — 現在の config.json を確認・修正

### Step 2: 設定確認（単発実行・監視モードの場合）

`config.json` を確認し、パスが正しいか確認する。

```json
{
  "watch_folder": "処理対象フォルダのパス",
  "output_folder": "出力先フォルダのパス"
}
```

パスが不正な場合は修正を提案する。

### Step 3: 実行

**単発実行の場合:**
```bash
python auto_rotate_monitor.py --once
```

**監視モードの場合:**
```bash
python auto_rotate_monitor.py
```

### Step 4: 完了報告

処理されたファイル数と結果を報告する。

---

*このワークフローは `.agent/workflows/pdf-rotate.md` で定義されています*
