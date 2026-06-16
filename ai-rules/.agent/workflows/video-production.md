# ワークフロー: video-production — 医療クリニックYouTube動画制作

## 説明

クリニック患者向けWebアニメーション動画を、市場調査から公開まで一貫して制作するワークフローです。
全フェーズを通じて医療広告ガイドラインへの適合を維持し、患者プライバシーを保護します。

## 呼び出し方

```text
/video-production
```

---

## Steps

### Phase 1: 市場調査 (video-market-researcher)

1. `video-market-researcher` スキルを実行します。
2. 診療科・ターゲット患者・FAQの確認後、YouTube競合チャンネル・検索ニーズ・医療広告ガイドラインを調査します。
3. 調査結果を `projects/media/youtube-clinic/research/` に保存します。
   - `research_report.md` — 人間向けレポート
   - `competitor_data.json` — 次フェーズへの引き渡しデータ
4. 参入推奨テーマ・ガイドライン注意事項をユーザーに提示し、承認を得ます。

**完了条件**: 参入推奨テーマ3件以上が特定され、医療広告ガイドラインの制約事項がリスト化されている

### Phase 2: 動画企画 (video-planner)

1. `video-planner` スキルを実行します。
2. `research/competitor_data.json` をインプットとして、動画テーマ・タイムライン構成・Remotionアニメーション演出コンセプトを設計します。
3. 医療広告ガイドライン適合チェックを行います。
4. 企画書を `projects/media/youtube-clinic/plans/video_plan_{No}.md` として保存します。
5. 企画書のサマリーをユーザーに提示し、承認を得ます。

**完了条件**: 企画書にタイムライン構成と医療広告ガイドライン確認チェックリストが全項目完了している

### Phase 3: スクリプト作成 (video-script-writer)

1. `video-script-writer` スキルを実行します。
2. `plans/video_plan_{No}.md` をインプットとして、ナレーションスクリプトとRemotionアニメーション仕様書を作成します。
3. 最終チェックリストを通過させます。
4. 成果物を `projects/media/youtube-clinic/scripts/` に保存します。
   - `script_{No}.md` — ナレーションスクリプト
   - `animation_spec_{No}.md` — Remotionアニメーション仕様書
5. スクリプトのサマリーをユーザーに提示し、承認を得ます。

**完了条件**: 全シーンのナレーション・テロップ・アニメーション指示が揃い、禁止表現なし・受診促進クロージングあり

### Phase 4: Remotion実装（将来フェーズ）

1. `project-manager` スキルで `animation_spec_{No}.md` をもとにWBSを作成します。
2. `dev-step` ワークフローで1ステップずつ実装します。
3. 技術スタック: Remotion + React + TypeScript + TailwindCSS

### Phase 5: レビュー

1. 映像内容の医療的正確性を医師が確認します（必須・省略不可）。
2. 医療広告ガイドラインの最終確認を行います。
3. 動画尺・音声・テロップの最終確認を行います。
4. `projects/media/youtube-clinic/review/review_checklist_{No}.md` に確認結果を記録します。

**完了条件**: 医師による内容確認OK・全チェックリスト通過

### Phase 6: 公開

1. Remotionでmp4レンダリングします（`npx remotion render`）。
2. YouTubeへ手動アップロードします。
3. タイトル・概要欄・タグ・サムネイルを設定します。
4. `projects/media/youtube-clinic/publish/publish_log.md` に公開記録を追記します。

---

## 医療コンテンツ共通ルール（全フェーズ適用）

以下のルールは全フェーズで例外なく適用する：

1. 患者個人情報・実症例・写真は一切使用しない
2. 厚生労働省「医療広告ガイドライン」に準拠した表現のみ使用する
3. 治療効果の断定・保証表現は使用しない
4. 全動画のエンドカードに「詳しくはご相談ください」等の受診促進文言を入れる
5. 公開前に必ず医師による内容確認を得る（省略不可）

---

*このワークフローは `.agent/workflows/video-production.md` で定義されています*
*最終更新: 2026-06-07*
