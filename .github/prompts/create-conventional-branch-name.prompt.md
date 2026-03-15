---
description: "やりたい作業内容から、コンベンショナルブランチ形式の明確なブランチ名をケバブケースで生成する"
name: "Create Conventional Branch Name"
argument-hint: "作業内容（例: ログインAPIのタイムアウト不具合を修正）"
agent: "agent"
---
以下の作業内容から、Git ブランチ名を 1 つ生成し、`main` 起点でブランチ作成まで実行してください。

命名ルール:
- 形式: `<type>/<short-description>`
- `short-description` はケバブケース（英小文字・数字・ハイフンのみ）
- 簡潔で具体的にする（3〜7語）
- 曖昧語（`update` `misc` `changes` など）は避ける

`type` の選び方:
- 新機能: `feat`
- バグ修正: `fix`
- ドキュメント: `docs`
- リファクタ: `refactor`
- テスト: `test`
- CI/CD: `ci`
- ビルド設定: `build`
- その他雑務: `chore`

入力:
{{input}}

実行手順:
1. 入力内容から要件に沿ったブランチ名を 1 つ決める
2. 次を順に実行する
   - `git switch main`
   - `git pull --ff-only origin main`
   - `git switch -c <generated-branch-name>`
3. 同名ブランチがある場合は末尾に `-2`, `-3` を付けて再試行する

出力ルール:
- 1行目: 作成した最終ブランチ名のみ
- 2行目: 実行した最終コマンド（`git switch -c ...`）
- 3行目以降は出さない
- コードブロックは使わない
