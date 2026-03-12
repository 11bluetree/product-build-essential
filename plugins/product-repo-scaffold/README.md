# Product Repo Scaffold プラグイン

Product Build Essential の構成とスタータードキュメントを使って、新規リポジトリを一括生成します。

## Installation

```bash
# マーケットプレイス経由のインストール例
copilot plugin install product-repo-scaffold@your-marketplace
```

## 含まれる内容

### Skills

| Skill | Description |
|-------|-------------|
| `product-repo-scaffold` | `checklists`、`core`、`decisions`、`playbooks`、`quality`、`research` を含むリポジトリ骨格を生成します。スターター Markdown 作成有無と safe/force 上書きモードを選択できます。 |

## ローカル実行

このプラグイン配下のスクリプトを直接実行できます。

```bash
bash plugins/product-repo-scaffold/skills/product-repo-scaffold/scripts/scaffold.sh \
  /path/to/new-repo \
  --name "My Product" \
  --with-starters \
  --mode safe
```

## Source

このプラグインは `11bluetree/product-build-essential` で管理しています。

## License

MIT
