# Product Build Essential

プロダクト開発時に繰り返し使える設計原則、実装フロー、品質基準、意思決定の型をまとめたガイドです。

特定のクラウド、フレームワーク、業務ドメインに依存しない形で整理しています。技術選定そのものを固定するためではなく、どの技術を選んでも崩れにくい進め方を共有するための土台として使います。

## 使い方

1. 新規プロジェクトの開始時は `docs/checklists/project-bootstrap.md` から確認する
2. 設計の方向性を固めるときは `docs/core/` を読む
3. 技術判断は `docs/decisions/adr-template.md` で記録する
4. 選定や設計の調査メモは `research/README.md` の運用ルールに従って記録する
5. 機能の詳細設計は `docs/design-doc/` に記録し、実装前にレビューを受ける
   - テンプレートは `docs/playbooks/design-doc-template.md` を参照
6. 機能追加の進め方を決めるときは `docs/playbooks/` を使う
7. 品質・セキュリティの最低基準は `docs/quality/` を参照する

## 開発フロー

実際に開発を進めるときは、以下の順で進める。

1. **着手準備**
   - `docs/checklists/project-bootstrap.md` を使って、目的、非対象、成功指標を定義する
2. **設計原則の固定**
   - `docs/core/product-development-principles.md` と `docs/core/architecture-principles.md` で責務分離と依存方向を決める
3. **モデル境界の定義**
   - `docs/core/domain-and-data-modeling.md` でドメイン、API 契約、永続化、UI モデルの境界を決める
4. **技術判断の記録**
   - 主要な選定事項を `docs/decisions/adr-template.md` で ADR 化する
5. **詳細設計（実装前）**
   - `docs/design-doc/[feature-name]/` に設計ドキュメントを作成する
   - テンプレートは `docs/playbooks/design-doc-template.md` を参照
   - 設計完了後、PR でレビューを受ける
6. **機能の縦切り実装（バックエンド先行）**
   - `docs/playbooks/backend-feature-delivery.md` と `docs/playbooks/api-contracts.md` に沿って 1 機能を端から端まで実装する
7. **フロントエンド統合**
   - `docs/playbooks/frontend-feature-delivery.md` に沿って UI と状態管理を分離して接続する
8. **品質ゲートの適用**
   - `docs/quality/testing-strategy.md`、`docs/quality/security-baseline.md`、`docs/quality/code-quality-and-workflow.md` を機能ごとに適用する
9. **完了確認とリリース確認**
   - `docs/checklists/feature-delivery.md` で機能完了を確認し、`docs/checklists/release-readiness.md` でリリース可否を判断する

この流れは、`設計を先に固定 -> 小さく実装 -> 品質で締める` を繰り返す運用を前提としている。

## ディレクトリ構成

- `apps/` : アプリケーションコードの配置場所（例: `frontend/`、`backend/`、`client/`、`api/`）
- `packages/` : 複数アプリから再利用する共有ライブラリや共通モジュールの配置場所
- `docs/` : プロダクト開発のドキュメント群
  - `core/` : プロダクト設計の中核原則
  - `design-doc/` : 機能ごとの詳細設計書（実装前）
  - `playbooks/` : 実装を進めるときの順序と責務分担
  - `quality/` : テスト、セキュリティ、コード品質の基準
  - `decisions/` : アーキテクチャ判断の記録方法
  - `checklists/` : 着手前、実装前、リリース前の確認項目
- `research/` : 一時的な選定・設計調査の記録

## 調査の記録場所

技術選定、設計比較、前提確認などの調査は `research/` に記録する。
運用ルールは `research/README.md` を参照する。

## 基本姿勢

- ドメイン知識と技術的都合を分離する
- 境界で必ず入力を検証する
- 型、契約、データ構造を曖昧にしない
- 実装順序を固定し、変更の影響範囲を狭く保つ
- 技術選定の理由を後から追えるように記録する
