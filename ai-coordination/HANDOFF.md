# Active Handoff

## 現在の担当: Cursor
## タスク: 医療機関マップのデータ更新およびポータブル化完了 → Cursorでの検証・UI微調整
## ステータス: 引き継ぎ可能
## 更新日時: 2026-06-13

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



## 次にやること
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
