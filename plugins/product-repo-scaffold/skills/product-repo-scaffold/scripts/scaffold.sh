#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
使い方:
  scaffold.sh <target-path> [--name <project-name>] [--with-starters] [--dirs-only] [--mode safe|force]

オプション:
  --name <project-name>   README のタイトルに使うプロジェクト名。
  --with-starters         スターター Markdown を作成する (デフォルト)。
  --dirs-only             フォルダのみ作成する。
  --mode <safe|force>     safe: 既存ファイルを上書きしない (デフォルト)、force: 生成対象を上書き。
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

TARGET_PATH="$1"
shift

PROJECT_NAME="Product Repository"
WITH_STARTERS=true
MODE="safe"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      PROJECT_NAME="${2:-}"
      shift 2
      ;;
    --with-starters)
      WITH_STARTERS=true
      shift
      ;;
    --dirs-only)
      WITH_STARTERS=false
      shift
      ;;
    --mode)
      MODE="${2:-safe}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "不明なオプションです: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "$MODE" != "safe" && "$MODE" != "force" ]]; then
  echo "無効なモードです: $MODE (safe または force を指定してください)" >&2
  exit 1
fi

mkdir -p "$TARGET_PATH"

DIRS=(
  "checklists"
  "core"
  "decisions"
  "playbooks"
  "quality"
  "research"
)

for dir in "${DIRS[@]}"; do
  mkdir -p "$TARGET_PATH/$dir"
done

write_file() {
  local file_path="$1"
  local content="$2"

  if [[ -f "$file_path" && "$MODE" == "safe" ]]; then
     echo "SKIP   $file_path"
    return
  fi

  printf "%s\n" "$content" > "$file_path"
  if [[ "$MODE" == "force" ]]; then
     echo "WRITE  $file_path"
  else
     echo "CREATE $file_path"
  fi
}

README_CONTENT="# ${PROJECT_NAME}

  このリポジトリは product-repo-scaffold スキルで生成されました。

  ## クイックスタート

  1. \
   \`checklists/project-bootstrap.md\`
    でスコープを定義する
  2. \
   \`core/\`
    で設計原則を整理する
  3. \
   \`playbooks/\`
    で実装フローを定義する
  4. \
   \`quality/\`
    の品質ゲートを適用する
  5. \
   \`decisions/\`
    でアーキテクチャ判断を記録する
"

  PROJECT_BOOTSTRAP="# プロジェクト着手チェックリスト

  ## 目的
  - [ ] 対象ユーザーと提供価値を定義する
  - [ ] 成功指標を定義する

  ## スコープ
  - [ ] 対象範囲の成果物を定義する
  - [ ] 非対象項目を定義する

  ## 制約
  - [ ] チーム体制の制約
  - [ ] 期間の制約
  - [ ] リスク前提
"

  FEATURE_DELIVERY="# 機能実装チェックリスト

  ## 実装前
  - [ ] 契約と境界が明確
  - [ ] バリデーションとエラー方針が定義済み

  ## 実装中
  - [ ] 合意した実装順序を守る
  - [ ] ドメインロジックを通信層や UI から分離する

  ## 完了前
  - [ ] 必要レベルのテストが通過
  - [ ] セキュリティと品質チェックが通過
"

  RELEASE_READINESS="# リリース準備チェックリスト

  ## 機能面
  - [ ] 主要シナリオを検証済み
  - [ ] ロールバック手順が明確

  ## 技術面
  - [ ] 監視とログが十分
  - [ ] エラーハンドリング経路を検証済み

  ## 運用面
  - [ ] デプロイ手順を文書化済み
  - [ ] 関係者への共有が完了
"

  ARCHITECTURE_PRINCIPLES="# アーキテクチャ原則

  ## 基本ルール
  - ドメイン、アプリケーション、インフラの責務を分離する。
  - 依存方向を明示し、一方向に保つ。
  - 外部システムは差し替え可能なアダプタとして扱う。
"

  DOMAIN_MODELING="# ドメインとデータモデリング

  ## ドメインモデル
  - エンティティ:
  - 値オブジェクト:
  - ドメインサービス:

  ## 境界
  - API 契約モデル:
  - 永続化モデル:
  - UI/ビュー モデル:
"

  PRODUCT_PRINCIPLES="# プロダクト開発原則

  ## 原則
  1. 実装詳細より先に責務を定義する。
  2. ドメインロジックをフレームワーク都合から守る。
  3. 外部入力は境界で必ず検証する。
  4. 機能ごとの実装順序を標準化する。
  5. トレードオフを含む意思決定を記録する。
"

  ADR_TEMPLATE="# ADR: <title>

- Status: Proposed | Accepted | Superseded
- Date: YYYY-MM-DD

  ## Context
  課題と制約を記述する。

  ## Decision
  採用した判断を記述する。

  ## Alternatives Considered
  - Option A:
  - Option B:

  ## Consequences
  - Positive:
  - Negative:
"

  DECISIONS_README="# Decisions

  このディレクトリに Architecture Decision Records (ADR) を保存します。
  連番を使い、1ファイル1意思決定で記録します。
"

  API_CONTRACTS="# API 契約

  ## Endpoint
  - Method:
  - Path:
  - Auth:

  ## Request
  - Schema:
  - Validation rules:

  ## Response
  - Success schema:
  - Error schema:
"

  BACKEND_PLAYBOOK="# バックエンド機能実装

  ## 実装順序
  1. ユースケースの振る舞いを定義する。
  2. 入出力契約を定義する。
  3. ドメインロジックを実装する。
  4. アダプタ/インフラ連携を実装する。
  5. テストを追加する。
"

  FRONTEND_PLAYBOOK="# フロントエンド機能実装

  ## 実装順序
  1. API 契約を確認する。
  2. UI/フォームスキーマを定義する。
  3. API クライアントを実装する。
  4. 状態とイベント処理を集約する。
  5. UI コンポーネントを組み立てる。
  6. ルート/ページへ統合する。
"

  QUALITY_WORKFLOW="# コード品質と開発フロー

  ## 基準
  - Lint と format のチェックを自動化する。
  - レビューは挙動と保守性を重視する。
  - 品質ゲート失敗時は CI でマージを止める。
"

  SECURITY_BASELINE="# セキュリティ基準

  ## 最低限の管理項目
  - すべての境界で入力検証を行う。
  - 認証とデータアクセスは安全なデフォルトを採用する。
  - CI で依存関係とシークレットのスキャンを行う。
"

  TESTING_STRATEGY="# テスト戦略

  ## テストレベル
  - ドメインロジックのユニットテスト。
  - 契約とアダプタの統合テスト。
  - ユーザー重要導線の E2E テスト。
"

  RESEARCH_README="# 調査メモ

  このディレクトリに調査記録を保存します。
  各メモには前提、比較した選択肢、最終提案を記載します。
"

if [[ "$WITH_STARTERS" == true ]]; then
  write_file "$TARGET_PATH/README.md" "$README_CONTENT"
  write_file "$TARGET_PATH/checklists/project-bootstrap.md" "$PROJECT_BOOTSTRAP"
  write_file "$TARGET_PATH/checklists/feature-delivery.md" "$FEATURE_DELIVERY"
  write_file "$TARGET_PATH/checklists/release-readiness.md" "$RELEASE_READINESS"
  write_file "$TARGET_PATH/core/architecture-principles.md" "$ARCHITECTURE_PRINCIPLES"
  write_file "$TARGET_PATH/core/domain-and-data-modeling.md" "$DOMAIN_MODELING"
  write_file "$TARGET_PATH/core/product-development-principles.md" "$PRODUCT_PRINCIPLES"
  write_file "$TARGET_PATH/decisions/adr-template.md" "$ADR_TEMPLATE"
  write_file "$TARGET_PATH/decisions/README.md" "$DECISIONS_README"
  write_file "$TARGET_PATH/playbooks/api-contracts.md" "$API_CONTRACTS"
  write_file "$TARGET_PATH/playbooks/backend-feature-delivery.md" "$BACKEND_PLAYBOOK"
  write_file "$TARGET_PATH/playbooks/frontend-feature-delivery.md" "$FRONTEND_PLAYBOOK"
  write_file "$TARGET_PATH/quality/code-quality-and-workflow.md" "$QUALITY_WORKFLOW"
  write_file "$TARGET_PATH/quality/security-baseline.md" "$SECURITY_BASELINE"
  write_file "$TARGET_PATH/quality/testing-strategy.md" "$TESTING_STRATEGY"
  write_file "$TARGET_PATH/research/README.md" "$RESEARCH_README"
else
  echo "フォルダのみ作成しました: $TARGET_PATH"
fi

echo "スキャフォールド完了: $TARGET_PATH"
