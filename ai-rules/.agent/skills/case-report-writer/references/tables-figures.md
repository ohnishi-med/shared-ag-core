# Table・Figureの配置(標準的な症例報告の体裁)

読むタイミング: Table/Figureを配置する時。

症例報告の本文における表の数は、典型的には**3〜4個程度**に収まる。以下の構成を目安にする:

- Table 1: Timeline of key clinical events
- Table 2: 代表的な観察データ(全データではなく代表例を5〜10行程度で抜粋)
- Table 3: 検査値・その他所見のサマリー(複数カテゴリがあっても1つの表に統合する)

**詳細な生データ(全セッション・全時点の検査値等)は本文に入れず、「Additional file」として別のWord文書に分離する。** 対応として:
- 本文の該当表・脚注に「Full data are provided in Additional file 1」と明記する
- Declarations の "Availability of data and materials" に Additional file への言及を追加する
- 本文末尾(Abbreviations の前後)に「Additional Files」セクションを新設し、各ファイルの内容を簡潔に説明する
- Additional file を生成するスクリプト(`create_additional_file.py`)も本文と同様にバージョン管理する

**時系列で追う価値のある指標(体重、バイタル、検査値、投与量等)があれば、matplotlibでFigureとして可視化し、python-docxで本文に埋め込むことを検討する。** Figureのcaptionは本文中の参照(”Figure 1” 等)と対応させ、データの欠測がある場合はcaption内に明記する(欠測をゼロ値と誤読されないように)。

表・図への色付けハイライトは、印刷時の可読性とジャーナルの投稿規定を踏まえ最小限に留める。**Additional file(補足資料)側は本文以上に淡々とした体裁が好まれる傾向があるため、本文で使った色分けハイライトを補足資料側では外す、という判断も一案。**
