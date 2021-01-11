---
Title: push-to-hatenablogを使いやすくしてみた
Date: 2021-01-13T23:52:20+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/13/push-to-hatenablog%E3%82%92%E4%BD%BF%E3%81%84%E3%82%84%E3%81%99%E3%81%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613673835711
Draft: true
---

ブログの下書きはmarkdownで書きたいと思い、**push-to-hatenablog**を導入してみました。

[https://github.com/mm0202/push-to-hatenablog:embed:cite]

以前までは、記事を投稿する時は既存のmarkdownからコピペして整形していましたが、  
導入後は、markdownがそのまま記事として投稿できるので、とても満足しています。

さらに GitHub Actions で投稿する際の手間を出来る限り省くことで、  
「メモを取る」ことから「記事を書く」までの心理的ハードルを下げることが出来ました。

普段はQiitaばかりで、はてなブログには記事を全く投稿していませんが、  
push-to-hatenablogが結構使いやすかったので、これを機に投稿を増やしていきたいと思います。

[:contents]

## push-to-hatenablogとは

「はてなブログ記事の作成/取得/更新が、CLIで出来るようになります。」

導入方法は、以下のGitHubリポジトリの`README.md`に記載されています。  
そこまで難しくなく、30分もあればGitHubとはてなブログの同期が出来ると思います。

以下のブログにも詳しい説明が書いてあるので、詳細はこちらを確認してください。

[https://tanabebe.hatenablog.com/entry/2020/07/06/080000:embed:cite]

`README.md`の**セットアップ**まで完了したら、push-to-hatenablogを使いやすくするためにリポジトリのソースコードを修正していきます。

## どのように使いやすくするのか

私のはてなブログのソースコードは、以下のGitHubリポジトリで管理しています。

[https://github.com/ymmmtym/hatena-blog:embed:cite]

デフォルトの状態から少しだけ修正して、以下のようなルールで記事を管理しています。

- はてなブログ上に保存されている記事が神様
- main(master)ブランチは、記事のバックアップ専用
- entries/*ブランチは、はてなブログ上の記事修正用
- 記事の新規投稿はローカルのCLIで行う

## デフォルトからの修正点

自分のリポジトリに**push-to-hatenablog**のリポジトリをコピーしたら、以下の修正を行っていきます。

### デフォルトbranchをmainに変更

個人的に、自分のリポジトリはデフォルトbranchを**main**に設定しているので、push-to-hatenablogにも同様の設定します。

GitHub上で新しくmainブランチを作成して、リポジトリの「settings」から変更することができます。

以下に詳しい方法が書いてあるので、詳細は割愛します。

[https://qiita.com/fk_chang/items/a4839a595fef9a2c3724:embed:cite]

以降の内容、ソースコードはデフォルトbranchがmainである前提で記載しています。

### `push.yml`の修正

デフォルトで用意されている`push.yml`を修正しました。  
こちらは大きな変更点はなく、以下の2つになります。

- masterとなっているbranchをmainに変更
- Timezoneを**Asia/Tokyo**に設定

前節でデフォルトbranchを変更しましたので、それを適用します。  
また、Timezomeも**Asia/Tokyo**に設定しました。現状はこれを活用していないですが、今後自動で時刻を取得したい時に日本時間を取得しやすくしました。

完成したソースコードは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/hatena-blog/blob/main/.github/workflows/push.yml?slice=1:5"></script>

### `pull.yml`の追加

このGitHub Actionsを追加することにより、  
はてなブログ上で管理されている記事を定期的に取得することができます。

Pullする前に`entries`ディレクトリを削除する必要がありました。

完成したソースコードは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/hatena-blog/blob/main/.github/workflows/pull.yml?slice=1:5"></script>

## 管理方法まとめ

### はてなブログ記事のバックアップを更新する時(自動)

<figure class="figure-image figure-image-fotolife" title="GitHub Actions Action User">[f:id:ymmmtym:20210111214346p:plain:alt=GitHub Actions Action User]<figcaption>GitHub Actions Action User</figcaption></figure>

### はてなブログ記事を修正する時

<figure class="figure-image figure-image-fotolife" title="GitHub Repository entries branch">[f:id:ymmmtym:20210111214611p:plain:alt=GitHub Repository entries branch]<figcaption>GitHub Repository entries branch</figcaption></figure>

#### 下書き記事を公開する方法

下書き記事を公開する時は、Markdownのメタデータである`draft: true`を削除します。

## さいごに

[https://qiita.com/basd4g/items/1a38857f6bafb20f065d:embed:cite]
