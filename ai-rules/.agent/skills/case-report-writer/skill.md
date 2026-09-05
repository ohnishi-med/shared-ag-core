---
name: case-report-writer
description: 医学雑誌向け症例報告(Case Report)をpython-docxで自動生成・査読・投稿準備するスキル。Journal提案、投稿規定準拠フォーマット、CAREガイドライン準拠、Reference管理、Table/Figure配置、日付匿名化、論理構成の一貫性、診断根拠の明示性を一貫して扱う。BMC Nephrology症例報告プロジェクトでの実践(構成の大幅圧縮、CT/エコー所見の追加、Child-Pugh採点の訂正、LVP等の用語精査を含む)を一般化したもの。
---

# スキル: case-report-writer — 症例報告作成・投稿準備エージェント

## このスキルについて

医学雑誌(BMCシリーズ等)向けの症例報告(Case Report)原稿を、python-docxスクリプトで自動生成し、CAREガイドライン準拠のチェック、論理構成の一貫性チェック、診断根拠の明示性チェック、査読、投稿前の匿名化までを一貫して支援する。Word文書は手動編集ではなく、必ずPythonスクリプト経由で生成・再生成すること(再現性と版管理のため)。

このファイルはコアワークフローのみを扱う。トピック別の詳細ルールは `references/` 配下に分割してあるので、該当する作業に入るタイミングで都度読み込む(全部を毎回読む必要はない)。

## 使用方法

```
case-report-writer スキルを使って、[症例の概要] のCase Reportを作成してください
```

既存原稿の改訂・投稿前チェック:
```
case-report-writer スキルを使って、この原稿をCAREガイドライン準拠・投稿前チェックしてください
```

## 参照ファイル一覧(該当作業に入る時に読む)

| ファイル | 読むタイミング |
|---|---|
| `references/care-compliance.md` | Case Presentationの構成を組む・CARE準拠を確認する時 |
| `references/narrative-logic.md` | 初稿作成時、構成を大きく変更(圧縮・Figure差し替え等)するたびのセルフレビュー |
| `references/clinical-evidence.md` | 診断根拠・重症度分類・画像所見など臨床判断を記述する時 |
| `references/terminology.md` | 医学専門用語・略語を使う時 |
| `references/data-integrity.md` | 測定値・統計的な閾値判定を扱う時 |
| `references/references-management.md` | 文献番号を追加・削除する時 |
| `references/tables-figures.md` | Table/Figureを配置する時 |
| `references/image-handling.md` | CT/エコー等の画像データを扱う時 |
| `references/anonymization.md` | 投稿前の匿名化、実患者データ(PHI)を扱う時 |
| `references/writing-polish.md` | 大幅改稿完了後・投稿直前の文章洗練 |

## コアワークフロー

### 1. Journal選定の提案

症例の診療科・疾患・症例としての新規性を踏まえ、候補となる雑誌を2〜3誌提案する。各誌について以下を簡潔に整理して提示する:
- Case Report受け入れの有無、査読方針
- Abstract/本文の語数制限
- 図表数の目安、Additional file(補足資料)の扱い
- CARE checklist提出要否
- オープンアクセス可否・APC(投稿料)の有無

ユーザーが既に投稿先を決めている場合はこのステップを省略し、その誌の投稿規定確認に進む。

### 2. 結語(Key Message)を最初に一文で確定し、そこから逆算して構成する

執筆・改訂作業に入る前に、**この症例報告が読者に持ち帰るべき結論を一文(Key Message)で確定し、書き出す**。症例報告は「事実の羅列」ではなく「一つの結論に向けた論証」であるため、Key Messageを決めずに書き始めると、各セクションが個別最適化され論旨が拡散する。

- Key Messageは、症例の新規性・臨床的含意を凝縮した一文にする(例: 「IAHの症例では、腹水穿刺がむしろ循環動態を改善させることがある」)。ユーザーに確認して確定し、プロジェクトの管理ドキュメント(`AGENTS.md`等)に明記する。
- 確定後、以下の対応関係が成立しているかを、初稿作成時および大きな構成変更のたびに検証する: Title(介入と転帰の関係を含むか)、Abstract Conclusions(Key Messageをほぼそのまま述べているか)、Background(Key Messageが覆す/埋める「定説・既知の期待」を明示しているか)、Case Presentation(提示するエピソード・データがKey Messageを支持する証拠連鎖になっているか)、Discussion Mechanism(Key Messageが成立する理由を明示的な因果連鎖で説明しているか)、Discussion Alternative Explanations(Key Messageを弱めうる対立仮説を正面から検討しているか)、Conclusions(Key Messageを同じ骨子で再掲しているか)。
- **新規の事実・段落・データを追加する際は、必ず「これはKey Messageを強化するか、弱めるか、無関係か」を判定してから配置場所を決める。** 無関係なら本文でなくAdditional Fileへ。Key Messageを弱める所見(相反するデータ等)は隠さず、Alternative ExplanationsまたはLimitationsで正直に扱う(cherry-pickingの回避、`references/data-integrity.md`参照)。
- 治療方針・介入の記述で「臨床的に必要と判断された場合に」「適宜」のような**判断根拠を示さない表現**を使っていないか注意する。投与基準となりうる検査値が経過中ずっと異常値のまま(例: 低アルブミン血症が常時存在)である場合、その検査値自体は介入タイミングの説明にならない。実際に介入の引き金となった具体的事象(血行動態不安定化のエピソード等)を明記し、Discussion内の対立仮説排除の論理とも整合させる。

### 3. フォーマッティング(python-docx自動生成)

- 対象誌の投稿規定(用紙サイズ、余白、フォント、行間、行番号有無、ページ番号)を確認し、`create_<journal>_word.py` のようなスクリプトでWord文書を直接生成する。
- スクリプトの保存処理には必ず以下を組み込む:
  - プロジェクトフォルダ本体へのコピー保存
  - `versions/` フォルダへのタイムスタンプ付き(`YYYYMMDD_HHMMSS`)履歴保存
  - 生成成功時に保存先パス一覧を print する
- Structured Abstract(Background/Case presentation/Conclusions 等)は都度語数をカウントし、規定内に収まっているか確認する。
- **出力先のWordファイルがユーザー側で開かれていると `PermissionError` で保存に失敗する。** その場合はワークスペース直下のコピー等、ロックされていない保存先が更新されているか確認し、それをユーザーに送付する。ユーザーがファイルを閉じたと報告してから、改めてスクリプトを再実行してロックされていたコピーを同期する。
- **投稿先が確定・変更されたら、その誌の投稿規定ページを実際に取得して確認する。** Springer/BMC系のジャーナルサイト(`link.springer.com` 等)はログイン・Cookieチェックのリダイレクトで自動取得(WebFetch)がブロックされることが多い。その場合は、誌専用ドメイン(例: `<journal>.biomedcentral.com`)や、既に掲載済みの論文のDOI解決を試す。それでも取得できない場合は、**同一パブリッシャー・同一プラットフォームの姉妹誌(例: BMC Nephrologyの規定)を代替根拠として使ってよいが、その旨と「投稿直前に手動で規定ページを確認すること」を必ずユーザーに明示する。** 規定を確認できないまま断定的に「この誌の規定はこうです」と述べない。

## 投稿直前チェックリスト

- [ ] Journal選定・投稿規定を確認済み(パブリッシャーサイトがログイン壁で自動取得できない場合、姉妹誌の規定を代替根拠にしたことをユーザーに明示し、最終確認を促した)
- [ ] Abstract語数が規定内
- [ ] CARE checklist全項目に対応(特にTimelineとFollow-up and Outcomes)。`references/care-compliance.md`参照
- [ ] Known→Unknown、原因→発見→一般化の順序が保たれている(結論の重複・前倒しがない)。`references/narrative-logic.md`参照
- [ ] 見出し番号(あれば)が文書全体で一貫している
- [ ] 予告文("we discuss...")や権威依存の断り書き("not a formal reading"等)が残っていない。`references/writing-polish.md`参照
- [ ] Figure差し替え・構成圧縮の後、全文コヒーレンスチェック済み(Abstract/Conclusions/Limitations/Abbreviations/Table脚注/Timelineへの追従漏れがない)
- [ ] 重症度分類等の複合スコアは採点内訳を明記、臨床診断は正式な診断基準に基づいているか確認済み。`references/clinical-evidence.md`参照
- [ ] 画像所見の記載が読影の専門性の範囲を超えていない(正式なレポートがない場合はその旨を明記)
- [ ] 技術的定義を伴う用語(LVP等)は定義を確認済みで、実測値と整合している。`references/terminology.md`参照
- [ ] Reference番号の整合性(追加・削除後の全箇所チェック)、新規引用文献は一次資料で確認済み。`references/references-management.md`参照
- [ ] 本文の Table/Figure が標準的な数(3〜4個+Figure)に収まっている。`references/tables-figures.md`参照
- [ ] 詳細な生データは Additional file に分離済み、本文から参照されている
- [ ] 画像ファイルは原本を加工せず別名コピーで作業している。`references/image-handling.md`参照
- [ ] 絶対日付を匿名化(相対日付化 or シフト)。`references/anonymization.md`参照
- [ ] 施設名・氏名等の識別情報が残っていない(画像の焼き込み文字含む)
- [ ] 著者情報・Corresponding author の実データが入力されている(プレースホルダーが残っていない)
- [ ] Consent for publication の記載
- [ ] バージョン管理(`versions/`)が機能している
- [ ] Scientific writingとしての文章洗練を全文通しで実施済み(曖昧な代名詞連鎖、1段落に複数論点、機械的な列挙、弱い婉曲表現、免責表現の重複がないか)。`references/writing-polish.md`参照
- [ ] 見出しの追加・削除・統合(小見出しのフラット化等)を行った場合、本文中の相互参照("see X, above"等)が実在の見出し・節を指しているかgrepで確認済み

---

*このスキルは `.agent/skills/case-report-writer/skill.md` で定義されています*
