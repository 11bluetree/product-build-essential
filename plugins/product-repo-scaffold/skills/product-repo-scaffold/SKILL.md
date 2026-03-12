---
name: product-repo-scaffold
description: 'Product Build Essential 構成で新規リポジトリを生成します。checklists、core 原則、playbooks、quality、ADR、research を含むプロセス先行の土台作成時に使用します。'
argument-hint: 'target path, project name, starters の有無, overwrite mode'
user-invocable: true
---

# Product Repo Scaffold

このプロジェクトの構成に沿った新規リポジトリ骨格を作成し、チームが再現可能な開発フローで開始できる状態にします。

## 使うタイミング
- このディレクトリ構成をベースに新しいリポジトリを作りたいとき。
- プロダクト開発向けドキュメントの「プラグイン」または再利用可能なブートストラップを求められたとき。
- `core`、`playbooks`、`quality`、`checklists`、`decisions`、`research` を標準化して作りたいとき。

## 入力
- `target path`: 新規リポジトリのルートを作成する絶対パスまたは相対パス。
- `project name`: 生成される `README.md` のタイトルに使う名前。
- `include starters`: `yes` で各ファイルのスターター Markdown を作成、`no` でフォルダのみ作成。
- `overwrite mode`: `safe` は既存ファイルを保持、`force` は生成対象ファイルを上書き。

## 手順
1. 出力先とオプションをユーザーと確認する。
2. 指定した引数で [scaffold script](./scripts/scaffold.sh) を実行する。
3. 期待するディレクトリとファイルが揃っているか検証する。
4. 作成・スキップ・上書きの結果を報告する。
5. 必要なら業種別（EC、SaaS、社内ツールなど）への文面最適化が必要か確認する。

## コマンド例
```bash
bash ./skills/product-repo-scaffold/scripts/scaffold.sh \
  <target-path> \
  --name "<project-name>" \
  --with-starters \
  --mode safe
```

## 分岐ルール
- 出力先が既に存在し、モードが `safe` の場合: 不足ファイルのみ作成する。
- モードが `force` の場合: 生成対象ファイルを上書きする。
- `--dirs-only` を指定した場合: スターター Markdown の作成を省略する。

## 完了条件
- ルートに `README.md` がある。
- 必須フォルダ `checklists`、`core`、`decisions`、`playbooks`、`quality`、`research` が存在する。
- オプションに応じてスターターファイルが作成されている、または意図的にスキップされている。
- 最終出力に「作成されたファイル」と「スキップされたファイル」が明示されている。

## References
- [期待される構成](./references/expected-structure.md)
