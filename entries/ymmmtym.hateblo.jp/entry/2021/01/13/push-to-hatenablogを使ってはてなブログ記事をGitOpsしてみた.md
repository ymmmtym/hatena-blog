---
Title: push-to-hatenablogを使ってはてなブログ記事をGit管理してみた
Date: 2021-01-13T23:52:20+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/13/push-to-hatenablog%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%AF%E3%81%A6%E3%81%AA%E3%83%96%E3%83%AD%E3%82%B0%E8%A8%98%E4%BA%8B%E3%82%92GitOps%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613673835711
---

ブログをmarkdownで書きたいと思い、**push-to-hatenablog**を導入してみました。

[https://github.com/mm0202/push-to-hatenablog:embed:cite]

以前までは、記事を投稿する時は下書き用のmarkdownからコピペして整形していましたが、  
導入後はmarkdownがそのまま記事として投稿できるので、とても満足しています。

さらに GitHub Actions で投稿する際の手間を出来る限り省くことで、  
「メモを取る」ことから「記事を書く」までの心理的ハードルを下げることが出来ました。

普段は少しだけQiitaで情報発信する程度で、はてなブログには記事を全く投稿していませんが、  
push-to-hatenablogが結構使いやすかったので、これを機に投稿を増やしていきたいと思います。

## 目次

[:contents]

## push-to-hatenablogとは

「はてなブログ記事の作成/取得/更新が、CLIで出来るようになります。」

導入方法は、以下のGitHubリポジトリの`README.md`に記載されています。  
30分もあればpush-to-hatenablogの使い方が理解出来ると思いますので、詳細は割愛します。

以下のブログにも詳しい説明が書いてあるので、詳細はこちらを確認してください。

[https://tanabebe.hatenablog.com/entry/2020/07/06/080000:embed:cite]

`README.md`の**セットアップ**まで完了したら、push-to-hatenablogを使いやすくするためにリポジトリのソースコードを修正していきます。

## どのように使いやすくするのか

私のはてなブログのソースコードは、以下のGitHubリポジトリで管理しています。

[https://github.com/ymmmtym/hatena-blog:embed:cite]

リポジトリのデフォルト状態を修正して、以下のようなルールで記事を管理しています。

- はてなブログ上に保存されている記事を神様にする
  - 記事のURLのフォーマットは「タイトル」にする
- デフォルトbranchは、記事のバックアップ専用にする
- デフォルト以外のbranchは、はてなブログで管理されている記事の修正用にする
- 記事の新規投稿はリポジトリにある`draft.md`を修正する
- はてなブログ編集画面でも編集可能にする

### Before / After

以下のような流れで記事の「新規投稿」と「更新」をしています。

## デフォルトからの修正点

自分のリポジトリに**push-to-hatenablog**のリポジトリをコピーして、以下の修正を行いました。

### デフォルトbranchをmainに変更

個人的に、自分のリポジトリはデフォルトbranchを**main**に設定しているので、push-to-hatenablogにも同様の設定します。

GitHub上で新しくmainブランチを作成して、リポジトリの「settings」から変更することができます。

以下に詳しい方法が書いてあるので、詳細は割愛します。

[https://qiita.com/fk_chang/items/a4839a595fef9a2c3724:embed:cite]

以降の内容・ソースコードはデフォルトbranchがmainである前提で記載しています。

### `push.yml`の修正

まず`push.yml`について説明すると、**デフォルト以外**のbranchがGitHubに作成された時に、GitHub Actionsで以下のようなworkflowが実行されます。

- `entry`ディレクトリの記事に差分があった場合、はてなブログで管理されている記事も更新する
- `draft.md'が更新された場合、新規投稿する

つまり、記事の「新規投稿」と「更新」する時に使用されます。  
こちらのファイルは以下を修正しました。

- masterとなっているbranchをmainに変更
- push前に`git config --global core.quotepath false`コマンドを実行
- Timezoneを**Asia/Tokyo**に設定
- postタスクを追加し、`draft.md`に更新があった場合に新規投稿

ソースコードは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/hatena-blog/blob/main/.github/workflows/push.yml?slice=1:5"></script>

前節でデフォルトbranchをmainに変更しましたので、それを適用します。

次にPushする前に`git config --global core.quotepath false`コマンドを追加しました。  
これは、記事のURLのフォーマットを「タイトル」にしたかったので追加したコマンドになります。

はてなブログの設定で記事のURLのフォーマットを「タイトル」にした場合、Markdownのファイル名も「タイトル」そのものになります。  (厳密に言うと、空白( )はアンダースコア(_)に置き換わります)  
この時に、ファイル名（タイトル）に日本語が含まれる場合、デフォルトのworkflowだとうまく動作しませんでした。

（具体的には、workflow中の`git diff`コマンドで表示されるファイル名の表記が日本語にならず、差分があるファイルを特定できません）

前述のコマンドを使用することで、正しいファイル名が表示されるようになり、workflowが正常に動作します。

最後に、`Timezome: Asia/Tokyo`に設定しました。  
これは記事を新規投稿する時に、自動的にworkflow「投稿日時」が設定されるようになっているため、日本時間になるようにしました。

CLIで新規投稿する方法もありますが、リポジトリに変更を加えただけで

### `pull.yml`の追加

`pull.yml`は新しく追加したファイルで、`push.yml`と同じディレクトリに配置します。  
ソースコードは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/hatena-blog/blob/main/.github/workflows/pull.yml?slice=1:5"></script>

このGitHub Actionsを追加することにより、以下のworkflowを追加しました。

- **定期的に**、はてなブログで管理している記事を**デフォルト**branchにpullする
- **push.yml実行後に**、はてなブログで管理している記事を**デフォルト**branchにpullする

このworkflowを追加した理由は、「デフォルトbranchで記事のバックアップをする」という目的があったからです。

定期的にデフォルトbranchにバックアップを実行することで、はてなブログ管理の記事をまるっとGitHubにも同期します。

#### workflow作成する時に注意したこと

リポジトリ更新時にデグレが発生しないように以下の注意しました。

- cronの設定で5分ごとに実行する
- `push.yml`の後に必ず実行する
- pullする前に、entryにある記事を削除する
  - リポジトリにゴミが残らないようにするため

定期的に実行のタイミングについて、GitHub Actionsで設定可能な最短時間である5分ごとにしています。  
さらに、はてなブログ管理の記事を更新した時、即時にGitHubにも反映されるように`push.yml`実行後には必ず実行します。

最後に、pullする前にentryにある記事を削除するですが、`blogsync pull`を実行した時に既に`entries`ディレクトリが存在すると、はてなブログ上には存在しないがGitHubには存在するといった**ゴミ**が残ってしまいます。

（例えば、タイトルを変えた場合は変更前のタイトルのファイルがそのままGitHubに残ってしまいます。）

これを回避するために、こちらではPullする前に`entries`ディレクトリを削除するようにしています。

## 管理方法まとめ

まとめると、以下のようにはてなブログを管理しています。

### はてなブログ記事のバックアップを更新する時(自動)

5分ごとに GitHub Actions が実行され、自動で取得されます。

<figure class="figure-image figure-image-fotolife" title="GitHub Actions Action User">[f:id:ymmmtym:20210111214346p:plain:alt=GitHub Actions Action User]<figcaption>GitHub Actions Action User</figcaption></figure>

上記のようにaction-userが記事の更新をしてくれます。  
`pull.yml`でcommiterやemailなどの変更もできます。

### はてなブログ記事を「新規投稿」「更新」する時

まずはmainブランチに移動して、`git pull`をしてローカルリポジトリを更新します。

その後、ブランチを作成して記事を修正し、GitHubにpushします。  
(以下ではentries/hogeブランチで記事を新規投稿 or 更新しています)

```bash
git chekckout main
git pull
git checkout -b entries/hoge

: 記事を更新する時はentryディレクトリのファイルを更新する:
: 記事を新規投稿する時はdraft.mdを修正する:

git push origin entries/hoge
```

<figure class="figure-image figure-image-fotolife" title="GitHub Repository entries branch">[f:id:ymmmtym:20210111214611p:plain:alt=GitHub Repository entries branch]<figcaption>GitHub Repository entries branch</figcaption></figure>

pushが完了するとpullが始まって、mainブランチにも変更が適用されるので、このブランチは最後に破棄します。

画像などの詳細オプションは、ローカルのmarkdownを編集すると逆に面倒なので、ある程度記事を書いたらはてなブログ上でも編集します。

#### 下書き記事を公開する方法

下書き記事を公開する時は、Markdownのメタデータである`Draft: true`を削除します。

## さいごに

他にもGitHubではてなブログ記事を管理するツールがあるみたいです。

[https://qiita.com/basd4g/items/1a38857f6bafb20f065d:embed:cite]
