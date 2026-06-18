# Active Handoff

## 現在の担当: Cursor
## タスク: 「主訴・所見」ボタン化実装完了 → Cursorでの動作確認
## ステータス: 引き継ぎ可能
## 更新日時: 2026-06-18

## コンテキスト（背景・経緯）
デジカルおよびWeborcaの運用における病名設定漏れ（検査に対する病名漏れ、急性期病名の放置）の課題に対し、実運用で知識のない方でも簡単に病名チェックおよび修正ができる解決策を実装する。

## 完了済みの作業
- **春日部市 URL修正・追加（計8施設）**（`projects/tools/maps/src/data/corrections.json`）（Claude Code / claude-sonnet-4-6）
  - 無効URL修正: 埼玉県-2282（杉浦眼科 豊春分院）、埼玉県-2315（黄川田クリニック）
  - URL追加: 埼玉県-2235（さだまつ眼科）、-2265（サテライトクリニックしょうわ）、-2284（小児救急夜間診療所）、-2290（かすかべララ眼科）、-2304（iCAREクリニック）、-2324（ミントクリニック春日部）
  - `rebuild_and_merge.py` → `tools/build.py` で dist/ まで反映済み
  - 注意: `rebuild_saitama_only.py` は corrections.json を適用しないため使用不可
  - URL未取得（公式サイトなし）: 埼玉県-2211, -2216, -2239, -2247, -2288
- **医療機関マップデータの更新およびPythonスクリプトのポータブル化（パス直書きの修正）**（`projects/tools/maps/`）（Antigravity / Gemini 3.5 Flash）
  - 埼玉県内 63 市町村の JSON データと `municipalities_meta.json` を再構築。
  - キャッシュ対策の `dataVersion` バージョンアップと `tools/build.py` による `dist/` への書き出しを完了。
- クリニックYouTube動画制作スキル・ワークフロー構築（Claude Code / claude-sonnet-4-6）
- M3デジカル病名チェック＆クレンジング・アシスタントの要件定義・仕様策定、および実装計画書（`implementation_plan.md`）の作成。
- スプレッドシート連携GAS APIおよびTampermonkeyスクリプトのプロトタイプコード（下書き）の作成。
- **腎臓透析・内科クリニック YouTube市場調査レポート作成**（`projects/media/youtube-clinic/research/research_report.md`、`competitor_data.json`）（Claude Code / claude-sonnet-4-6）
- **介護主治医意見書用 家族問診票の作成・デザイン調整**（`projects/clinic/nursing-care-inquiry/`）（Antigravity / Gemini 3.5 Flash）
- **デザイン確認用スキルの新規作成**（`.agent/skills/doc-visual-reviewer/`）（Antigravity / Gemini 3.5 Flash）
- **特定健診データ入力フォーム新規患者送信時のエラー（性別初期値入力規則違反）の修正**（`projects/clinic/health-check-form/`）（Antigravity / Gemini 3.5 Flash）
- **特定健診入力フォームへの性別（男女）入力欄の追加および保存・同期対応**（`projects/clinic/health-check-form/`）（Antigravity / Gemini 3.5 Flash）
- **推定塩分摂取量・FE指標計算プログラムの複数列対応およびFEUA追加・単位/表記揺れ対応改修**（`projects/m3-tampermonkey-scripts/js/salt-intake-calculator.user.js`）（Antigravity / Gemini 3.5 Flash）
  - 最新列が空欄であっても、1つ前の列（右から2列目）まで遡って有効な検査値を補完するよう抽出処理を拡張。
  - 取得された日付が最新検査日と異なる場合に「⚠️ 異なる日付のデータが含まれています」とモーダルUI上で警告を表示する仕組みを追加。
  - 新たに **FEUA（尿酸排泄率）** の計算ロジック（小数第1位）を実装し、モーダルへの表示および `FEUA[5.5-11.1%]` フィールドへの自動登録マッピングに対応。
  - 尿中尿酸のカルテ表示（mg/dL）と尿中クレアチニン（g/L）の単位の不一致に対応するため、FEUA計算ロジック内に100分の1換算を追加。
  - 検査項目名の表記揺れ（`尿中尿酸`や`尿酸（尿）`など）を許容して誤判定なく抽出できるよう、抽出条件を拡張。
  - `salt-intake-calculator/test.js` にて、DOMモックを用いた複数列補完、日付混在警告、FEUA計算精度・単位換算、表記揺れ抽出、および3列目以前の無視処理のユニットテストを完了。
- **問診票SOAP直接置換アシスタントの個人情報除外・日付変換・要望分類・お薬手帳URL置換・ダブル改行バグ修正・AP統合の改修**（`projects/m3-tampermonkey-scripts/js/inquiry-soap-formatter.user.js`）（Antigravity / Gemini 3.5 Flash）
  - カルテに不要な個人情報（住所、電話番号、生年月日、誕生日）をSOAP出力から自動除外。
  - 相対日付「本日」を今日の日付に基づいた絶対日付（例：「6月16日頃から」）に変換できるように正規表現を拡張。また、「今日まで」のように直後に「まで」が続く場合は絶対日付（から）に置換されないよう否定先読み正規表現を追加。
  - 「診察へのメッセージ」（例：「PIT予防薬希望」）が `S:` ではなく `P:` セクションの「ご要望」に分類されるようマッピングを追加。
  - 「お薬の手帳」およびひらがなの「おくすり手帳」項目にデジスマスマート診察などのURLが含まれる場合、出力ラベルを「お薬手帳」にし、値を「デジスマ送信」に置換するように修正。
  - `editor.innerText` のブラウザ依存挙動により、カルテ上の置換対象外部分（S・O・A/P欄）に1行ずつ意図しない改行が挟まってしまう問題を解消するため、エディタ子要素の `childNodes` をループして正確な改行を復元する `getEditorText` を実装。
  - `A:` と `P:` を `A/P:` として統合し、不要な空のプレースホルダー `（医師評価記入用）` を削除。設定画面からも「A欄を含める」のチェックボックスを削除。
  - バージョンを `1.3.7` に更新し、Node.jsのテストスクリプト（`test_formatter.js`）で期待通りに整形されることを検証完了。
- **インストーラーバッチのChromeブラウザ指定対応**（`projects/m3-tampermonkey-scripts/install_scripts.bat`）（Antigravity / Gemini 3.5 Flash）
  - デフォルトブラウザではなく Google Chrome を明示的に指定して各インストールURLを開くように `start chrome "URL"` 形式へ改修。
- **インストーラーバッチへのvital-sign-formatter追加**（`projects/m3-tampermonkey-scripts/install_scripts.bat`）（Claude Code / claude-sonnet-4-6）
  - `vital-sign-formatter.user.js` を10番目のインストール対象として追記。スクリプト数カウントを9→10に更新。
- **バイタルサインフォーマッター v1.3.0 改修**（`projects/m3-tampermonkey-scripts/js/vital-sign-formatter.user.js`）（Claude Code / claude-sonnet-4-6）
  - 体重必須バリデーションを撤廃。身長のみ・血圧のみなど柔軟な入力が可能に。
  - 身長行の更新対応：`│身長 cm`（数値なし行）がある場合、新規追加ではなくその行を数値で更新。
  - 同日データの**マージ処理**：既存行に不足フィールドを補完して1行にまとめる。体重が異なる場合のみ新行として併記。異なるBPはBP②として同一行に統合。
  - 血圧・脈拍①② の入力フォームに一体化（各セットに BP sys/dia + 脈拍を入力）。出力形式を `BP①  120/ 68  90 ②  130/ 78  86` に変更。
  - **非構造化バイタルテキストの自動変換**：バイタルボタン押下時、標準ブロックがない場合に以下の形式を自動検出・変換。
    - `身長173cm` → 身長行、`7/27 72.4kg` / `4/15 75㎏` → 日付+体重行
    - `血圧　138/83 脈拍104　4/15測定` → BP+HR+日付行
    - `130/74/98 5/11` → 収縮期/拡張期/脈拍+日付（3スラッシュ形式）
    - `Home 130/80程度` など近似値は除去。`体重` 単独ヘッダーは除去。日付順にソート。
- **M3デジカル バイタルサインフォーマッター開発、問診整理ツールとのフォーマット統一、および共通仕様書ドキュメントの作成**（`projects/m3-tampermonkey-scripts/`）（Antigravity / Gemini 3.5 Flash）
  - カルテO欄にバイタル（身長・体重・BMI・血圧・脈拍）を統一フォーマットで入力・追記する新規スクリプト（`vital-sign-formatter.user.js`）を開発。
  - 標準カルテフォーマットに準拠し、ブロックの境界線にボックス描画文字（`┌─`、`│`、`└─`）を使用。
  - 時系列のデータにおいて縦の列が等幅フォント環境で揃うよう、日付の `MM/DD` 化、および `padStart` を用いた体重（5桁）、BMI（4桁）、血圧（7桁）、脈拍（3桁）の固定幅パディング表示を実装。
  - 問診票SOAP直接置換アシスタント（`inquiry-soap-formatter.user.js`）にも同様のバイタルサインパースおよびボックス罫線・桁揃えの出力フォーマットを適用し、両ツールのバイタルデータ表記を統一。
  - 共通のレイアウト及びパディング規則を定義した仕様書ドキュメント `doc/vital-sign-format-spec.md` を作成。
  - スクラッチテストにより両スクリプトでのパース・フォーマット処理が正常動作することを検証完了。
- **M3デジカル 「主訴・所見」ボタン化および標準SOAPテンプレート挿入機能の仕様策定**（`projects/m3-tampermonkey-scripts/`）（Antigravity / Gemini 3.5 Flash）
  - カルテ画面左上の「主訴・所見」テキストをボタン化し、クリック時に標準SOAPテンプレートを挿入する仕様を策定。仕様を `HANDOFF.md` に記載。
- **M3デジカル 「主訴・所見」ボタン化および標準SOAPテンプレート挿入の実装**（`projects/m3-tampermonkey-scripts/js/inquiry-soap-formatter.user.js`）（Claude Code / claude-sonnet-4-6）
  - `inquiry-soap-formatter.user.js` v1.3.9 → v1.4.0
  - `injectSoapTemplateButton()` 関数を追加。カルテ画面の「主訴・所見」テキストをtealカラーのクリック可能ボタン化。
  - クリック時: 空なら即挿入、テキストありなら confirm で上書き or カーソル位置挿入を選択。
  - `execCommand('insertText')` でProseMirror履歴を保持したまま挿入。
  - `handleInquiryInjection()` から isKartePage 条件で常時呼び出し（MutationObserver対応済み）。

## 次にやること
- **M3デジカル 「主訴・所見」ボタン化の動作確認**（Cursor担当）:
  - `inquiry-soap-formatter.user.js` v1.4.0 をM3デジカルにインストール後、カルテ画面で「主訴・所見」がtealカラー表示されクリック可能になっているか確認。
- **医療機関マップのCursorでの動作確認・UI微調整**:
  - 更新された医療機関データ（春日部市等）が正しくマップ上に読み込まれるかの最終チェックと、必要に応じたUI微調整（Cursor担当）。
- **Remotion実装**: `animation_spec_01_dialysis_delay_habits.md` をもとにReact/TypeScriptコンポーネントを実装する（`video-remotion-developer` スキルが必要）。
- **M3デジカル病名チェック実装**（並行して）: `implementation_plan.md` を元にGASコード・Tampermonkeyスクリプトを実装する。

## 次の担当者へのメモ
YouTube企画設計完了。
- 6ヶ月カレンダー: `projects/media/youtube-clinic/plans/calendar_6months.md`（月4本×24本分）
- 第1本詳細企画書: `projects/media/youtube-clinic/plans/video_plan_01_dialysis_delay_habits.md`
次は `/video-script-writer` で動画01のナレーションスクリプトとRemotionコンポーネント仕様を作成する。
Phase 4（Remotion実装）は将来フェーズ。`video-remotion-developer` スキルが必要になった時点で追加する。

---

## 作業中ファイル（相手は編集禁止）

| ファイル | 担当 | 開始時刻 |
|---------|------|---------|
| （なし） | — | — |

---

## 運用ルール

- **作業開始時**: このファイルを必ず読んでから着手する。編集するファイルを「作業中ファイル」テーブルに追記する
- **作業終了時**: 「作業中ファイル」から自分の行を削除する。「完了済みの作業」「次にやること」を更新し、担当者を変更する
- **タスク完了時**: `handoff-log/YYYY-MM-DD_task-name.md` にコピーしてからこのファイルをリセットする
- **ステータス値**: `作業中` / `レビュー待ち` / `引き継ぎ可能` / `ブロック中` / `待機中`
- **競合防止**: 「作業中ファイル」に載っているファイルは、担当者が行を削除するまで相手のAIは編集しない

## AI完了報告・引き継ぎ時の詳細記述テンプレート（必須）

AIは作業を終了・引き継ぎする際、「完了済みの作業」および「次にやること」に以下の情報を**詳細に**記載しなければならない（単なる1行の要約記述は禁止）：

1. **変更ファイルと具体的な修正箇所**:
   - 変更したすべてのファイルの相対パス、およびそれらのファイルに対して加えた具体的な変更内容（クラス、関数、UI要素レベル）。
2. **実行した動作検証・テストとその結果**:
   - 実行したテストコマンド（例：`npm test`）、テスト対象ファイル、およびその実行結果（テスト成功ログなど）。
   - 手動検証を行った場合は、検証時の手順と結果（エラーが出ないことの確認、ボタンが動作したことの確認等）。
3. **未解決の課題・懸念事項・注意点**:
   - 検証できなかった箇所、実装上の制限、将来発生しうる問題点（パフォーマンス、他機能との競合など）。
4. **次に作業するAIが最初に行うべきステップ**:
   - 次の担当者がまずどのファイルをどう開いて、何のコマンドから実行すべきか。


