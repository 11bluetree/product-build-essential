# Design Document Template

機能の詳細設計をまとめるテンプレート。実装前にこのテンプレートを埋めてレビューを受ける。

## 使い方

1. `docs/design-doc/[feature-name]/` ディレクトリを作成
2. 以下のファイルを作成して記入：
   - `design-doc.md` - 機能全体の設計
   - `api-spec.md` - API 仕様（バックエンド機能の場合）
   - `db-schema.md` - DB スキーマ（データベースアクセスがある場合）
   - `ui-flow.md` - UI フロー（フロントエンド機能の場合）

---

## design-doc.md テンプレート

```markdown
# [機能名] 設計書

**ステータス**: ドラフト / レビュー中 / 承認済み
**作成日**: YYYY-MM-DD
**担当**: @username
**関連 ADR**: adr-001-xxx.md, adr-002-yyy.md

## 概要

### 機能の目的
[この機能で解いたい課題を 1-2 段落で説明]

### 対象ユーザーと利用シーン
- ユーザーセグメント
- 使用シーンの例

### 成功指標
- [測定可能な指標 1]
- [測定可能な指標 2]

## 前提条件と制約

### 技術的前提
- 採用する技術スタック（ADR への参照形式で記載）
  - 認証方式: adr-001-oauth2.md を参照
  - キャッシュ戦略: adr-002-redis-caching.md を参照

### 非機能要件
- パフォーマンス: レスポンスタイム ≤ 500ms
- スケーラビリティ: 同時ユーザー数 10,000
- セキュリティ: OWASP Top 10 対応 (docs/quality/security-baseline.md 参照)

### 実装上の制約
- [制約事項 1]
- [制約事項 2]

## アーキテクチャ設計

### データフロー
[図を含めて、リクエスト から レスポンスまでのデータフローを説明]

### レイヤー責務
#### プレゼンテーション層
- 入力値の検証
- レスポンス形式の変換
- HTTP ステータスコードの決定

#### アプリケーション層（ユースケース）
- ビジネスロジックのオーケストレーション
- トランザクション管理
- エラーハンドリング

#### ドメイン層
- 業務ルールの実装
- 不変条件の保証
- ドメイン例外の定義

#### インフラ層
- DB アクセス
- 外部 API 呼び出し
- キャッシュ処理

### ドメインモデル

#### エンティティ（変更される）
```

[エンティティ名]

- id: UUID
- 属性 1: 型
- 属性 2: 型
- 不変条件: [説明]
- ライフサイクル: [状態遷移]

```

#### 値オブジェクト（変更されない）
```

[値オブジェクト名]

- 属性 1: 型
- 検証ルール: [説明]

```

#### 集約
```

[集約名]

- ルート: [エンティティ名]
- 含まれる要素: [リスト]
- 不変条件: [説明]

```

## エラーハンドリング

### 発生しうる例外と処理

| エラーケース | 例外クラス | HTTP ステータス | ユーザーへのメッセージ |
|------------|-----------|---------------|------------------|
| ユーザーが見つからない | NotFoundError | 404 | 「ユーザーが見つかりません」|
| 認可エラー | ForbiddenError | 403 | 「この操作は実行できません」|
| バリデーション失敗 | ValidationError | 400 | [具体的なフィールドエラー] |

## 実装での検討事項

- [ ] 実装時に判断が必要な技術的選択肢
- [ ] 依存ライブラリの選択候補
- [ ] テスト戦略の詳細（docs/quality/testing-strategy.md と連携）
- [ ] デプロイ時の手順（マイグレーション、ロールバック戦略など）

## 段階的実装計画

### Phase 1
- [タスク 1]
- [タスク 2]

### Phase 2
- [タスク 1]
- [タスク 2]

## レビュー観点チェックリスト

- [ ] ドメイン知識と技術的都合が分離されているか
- [ ] 責務分離が docs/core/architecture-principles.md に準拠しているか
- [ ] API 契約が明確に定義されているか
- [ ] エラーハンドリングが完全か
- [ ] セキュリティ要件が実装設計に反映されているか
- [ ] テスト戦略が定義されているか
- [ ] 外部依存（DB、API など）の契約が曖昧でないか
```

---

## api-spec.md テンプレート

```markdown
# API 仕様書

## エンドポイント一覧

| メソッド | パス | 説明 | 認可 |
|---------|------|------|-----|
| POST | /api/users/authenticate | ユーザー認証 | なし |
| GET | /api/users/{id} | ユーザー情報取得 | ユーザー本人 or 管理者 |
| PUT | /api/users/{id} | ユーザー情報更新 | ユーザー本人 | 

## エンドポイント詳細

### POST /api/users/authenticate

**説明**: ユーザーにログインさせ、セッショントークンを返す

**リクエスト**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**レスポンス (200 OK)**

```json
{
  "sessionToken": "eyJhbGc...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "user"
  }
}
```

**エラーレスポンス**

- 401 Unauthorized: ユーザーが見つからない、パスワードが違う
- 400 Bad Request: 入力値が不正

**認可**: 認可なし（誰でも呼び出し可）

**詳細な動作**

- ユーザー情報が正しいことを検証する
- セッショントークンを生成する
- トークンを返す

```

---

## db-schema.md テンプレート

```markdown
# データベーススキーマ設計

## テーブル一覧

| テーブル名 | 目的 | 主キー |
|-----------|------|-------|
| users | ユーザー情報 | id |
| sessions | セッション情報 | id |

## テーブル詳細

### users

**目的**: ユーザー情報の永続化

**スキーマ**
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

**インデックス**

- `email`: ログイン時に email で高速検索するため

**物理制約**

- `id`: NOT NULL, 一意性
- `email`: NOT NULL, 一意性（同じメールアドレスで複数ユーザー作成を防ぐ）
- `password_hash`: NOT NULL

**ドメイン知識の反映**

- `password_hash`: パスワードは平文で保存しない

### sessions

**目的**: セッション情報の管理

**スキーマ**

```sql
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  token_hash VARCHAR(255) NOT NULL UNIQUE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

**インデックス**

- `user_id`: セッション検索用
- `token_hash`: トークンによる高速検索

**ドメイン知識の反映**

- `token_hash`: トークンは平文で保存しない
- `expires_at`: セッションの有効期限管理

```

---

## ui-flow.md テンプレート

```markdown
# UI フロー設計

## 画面一覧

- ログイン画面
- ユーザープロファイル画面
- 設定画面

## 画面フロー図

[画面遷移図を描画またはテキストで記載]

## 各画面の詳細設計

### ログイン画面

**コンポーネント構成**
- フォーム：email、password 入力フィールド
- ボタン：送信ボタン
- エラーメッセージ：認証失敗時に表示

**状態管理**
- `isLoading`: ローディング中フラグ
- `error`: エラーメッセージ

**バリデーション**
- マイクロレベル: email 形式チェック（バリデーション層で実施）
- マクロレベル: サーバー側 API で再度検証

**エラーハンドリング**
- API エラー → エラーメッセージ表示
```

---

## 記入例

実装を始める前に、このテンプレートを目安として設計書を作成し、設計レビューを受ける。
