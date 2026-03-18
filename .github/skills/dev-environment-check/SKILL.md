---
name: dev-environment-check
description: 'プロダクト開発に必要な開発環境が整っているかチェックする。Use when: 開発環境の品質チェック、CI/CD確認、pre-commit/pre-push設定確認、mainブランチ保護確認、linter設定確認、VSCode拡張機能設定確認、新規メンバーのオンボーディング確認、リリース前環境チェック。'
argument-hint: 'チェック対象のリポジトリパスを指定（省略時はカレントリポジトリ）'
---

# 開発環境チェック

プロダクト開発を安全かつ一貫して進めるための環境が整っているかを確認するスキル。
CIが壊れたまま、セキュリティ問題のあるコードが混入したまま、環境差異で「自分の環境では動いた」が発生する状態を防ぐ。

## チェック項目一覧

| カテゴリ | チェック内容 |
|----------|------------|
| CI/CD | ワークフローファイルの存在・構成 |
| コミット品質 | pre-commit / pre-push フックの設定 |
| セキュリティ | シークレットスキャン・脆弱性チェックの有無 |
| ブランチ保護 | main への直プッシュ防止 |
| コード品質 | Linter / Formatter の設定と統一 |
| エディター統一 | `.editorconfig` によるエディター非依存の設定 |
| VSCode 拡張機能 | `.vscode/extensions.json` による拡張機能の標準化 |
| レビュー体制 | `CODEOWNERS` による自動レビュアーアサイン |

---

## 手順

### ステップ 1: CI/CD の確認

`.github/workflows/` を探索し、以下を確認する。

- [ ] ワークフローファイル（`.yml`）が存在する
- [ ] `push` または `pull_request` トリガーが設定されている
- [ ] テストを実行するジョブがある（`run: npm test` / `pytest` / `go test` など）
- [ ] ビルドが成功しないとマージできない設定になっているか（後述のブランチ保護と連携）
- [ ] デプロイジョブがある場合、`main` ブランチへのマージ後にのみ実行される構成か

**問題があれば**: `.github/workflows/ci.yml` の雛形を提案する。

---

### ステップ 2: pre-commit / pre-push フックの確認

以下のいずれかの設定ファイルを探す。

| ツール | 設定ファイル |
|--------|------------|
| Husky | `.husky/pre-commit`, `.husky/pre-push` |
| pre-commit | `.pre-commit-config.yaml` |
| Lefthook | `lefthook.yml` |
| simple-git-hooks | `package.json > simple-git-hooks` |

- [ ] pre-commit フックが存在する
- [ ] pre-commit でLint / Formatter が実行される
- [ ] pre-commit でセキュリティチェックが実行される（例: `detect-secrets`, `gitleaks`, `trivy`）
- [ ] pre-push フックが存在する
- [ ] pre-push でテストが実行される（テスト失敗時に push を阻止）

**問題があれば**: 使用言語・スタックに合わせて推奨ツールと設定を提案する。

---

### ステップ 3: セキュリティチェックの確認

- [ ] シークレット（APIキー・パスワード）スキャンが CI またはフックで実行される
  - 例: `gitleaks`, `detect-secrets`, GitHub Secret Scanning（リポジトリ設定）
- [ ] 依存パッケージの脆弱性スキャンが存在する
  - 例: `npm audit` / `pip-audit` / `trivy` / `snyk` / Dependabot
- [ ] `.gitignore` に秘匿情報が含まれるファイルが列挙されている（`.env`, `*.pem` など）
- [ ] `.env.example` など、ダミー値を持つサンプルファイルが用意されている

---

### ステップ 4: ブランチ保護の確認

GitHubリポジトリの場合、以下を確認する。

- [ ] `main`（または `master`）への直接プッシュが禁止されている
  - GitHub の Branch Protection Rules または Rulesets で設定
- [ ] PR にレビュアーが必要（Required reviewers ≥ 1）
- [ ] CI がパスしないとマージできない（Required status checks）
- [ ] PR が最新でないとマージできない（Require branches to be up to date）

**確認方法**: GitHub の Settings → Branches を参照するよう案内する。  
**ローカル確認**: `git remote -v` でリモートを確認後、GitHub API または設定ページへ誘導する。

---

### ステップ 5: Linter / Formatter の確認

使用言語ごとに設定ファイルを探す。

| 言語 | Linter | Formatter |
|------|--------|-----------|
| JavaScript / TypeScript | ESLint (`.eslintrc.*`, `eslint.config.*`) | Prettier (`.prettierrc`) |
| Python | Ruff / Flake8 (`pyproject.toml`, `.flake8`) | Black / Ruff (`pyproject.toml`) |
| Go | staticcheck / golangci-lint (`.golangci.yml`) | gofmt（標準） |
| Rust | Clippy | rustfmt (`rustfmt.toml`) |
| CSS / SCSS | Stylelint (`.stylelintrc.*`) | Prettier |

- [ ] Linter の設定ファイルが存在する
- [ ] Formatter の設定ファイルが存在する（またはLinterがフォーマットを兼ねる）
- [ ] `package.json` や `Makefile` に lint / format スクリプトが定義されている
- [ ] CI でLintが実行されている
- [ ] エディターに依存せずコマンド一発でLintが実行できる

---

### ステップ 6: .editorconfig の確認

ルートの `.editorconfig` を探し、以下を確認する。

- [ ] `.editorconfig` が存在する
- [ ] `root = true` が先頭に設定されている
- [ ] インデントスタイル（`indent_style`）とサイズ（`indent_size`）が言語ごとに定義されている
- [ ] 改行コード（`end_of_line`）が統一されている（通常 `lf`）
- [ ] 文字コード（`charset`）が `utf-8` に設定されている
- [ ] ファイル末尾の改行（`insert_final_newline = true`）が設定されている
- [ ] 末尾の空白（`trim_trailing_whitespace = true`）が設定されている

**問題があれば**: プロジェクト構成に合わせた `.editorconfig` の雛形を提案する。

---

### ステップ 7: VSCode 拡張機能の確認

`.vscode/extensions.json` を探し、以下を確認する。

- [ ] `.vscode/extensions.json` が存在する
- [ ] `recommendations` にプロジェクトで必要な拡張機能が列挙されている
  - 最低限: 使用言語の Language Server、Linter/Formatter 拡張機能
  - 推奨: Git Lens、GitHub Copilot、Docker など
- [ ] `unwantedRecommendations` でプロジェクトと相性の悪い拡張機能が排除されている
- [ ] `.vscode/settings.json` にエディター設定が定義されている（フォーマット設定など）

**問題があれば**: 検出した設定ファイルに基づいて `extensions.json` の内容を提案する。

---

### ステップ 8: CODEOWNERS の確認

`.github/CODEOWNERS`（または `CODEOWNERS`, `docs/CODEOWNERS`）を探し、以下を確認する。

- [ ] `CODEOWNERS` ファイルが存在する
- [ ] リポジトリ全体のデフォルトオーナーが設定されている（`* @org/team` など）
- [ ] 重要なディレクトリ・ファイルに個別のオーナーが設定されている
  - 例: `/.github/ @org/platform-team`、`/src/api/ @org/backend-team`
- [ ] 設定されたオーナーが実在するユーザー／チームである
- [ ] ブランチ保護の「Require review from Code Owners」が有効か（後述のブランチ保護と連携）

**問題があれば**: ディレクトリ構成を分析して `CODEOWNERS` の雛形を提案する。

---

## 結果のレポート形式

チェック完了後、以下の形式でサマリーを出力する。

```
## 開発環境チェック結果

| カテゴリ | 状態 | 備考 |
|----------|------|------|
| CI/CD | ✅ 設定済み | `.github/workflows/ci.yml` |
| pre-commit | ⚠️ 部分的 | セキュリティスキャンが未設定 |
| pre-push | ❌ 未設定 | テスト実行フックがない |
| ブランチ保護 | ✅ 設定済み | main への直プッシュ禁止 |
| Linter | ✅ 設定済み | ESLint + Prettier |
| .editorconfig | ⚠️ 部分的 | insert_final_newline が未設定 |
| extensions.json | ❌ 未設定 | `.vscode/extensions.json` が存在しない |
| CODEOWNERS | ✅ 設定済み | `.github/CODEOWNERS` |

### 優先度の高い改善項目
1. ...
2. ...
```

---

## チェック対象外（スコープ外）

- インフラ・クラウド環境の設定（Terraform、AWS Config など）
- 本番環境の監視・アラート設定
- ドキュメント整備状況
