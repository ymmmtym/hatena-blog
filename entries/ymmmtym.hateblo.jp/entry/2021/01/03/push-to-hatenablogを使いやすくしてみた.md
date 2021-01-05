---
Title: push-to-hatenablogを使いやすくしてみた
Date: 2021-01-03T23:52:20+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/03/push-to-hatenablog%E3%82%92%E4%BD%BF%E3%81%84%E3%82%84%E3%81%99%E3%81%8F%E3%81%97%E3%81%A6%E3%81%BF%E3%81%9F
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613673835711
Draft: true
---

markdownで書くことが多いので、**push-to-hatenablog**を導入してみました。

以前までは、記事を投稿する時は既存のmarkdownからコピペして整形していましたが、  
導入後は、markdownがそのまま記事として投稿できるので、とても満足しています。

さらに GitHub Actions で投稿する際の手間を出来る限り省くことで、  
「メモを取る」ことから「記事を書く」までの心理的ハードルを下げることが出来ました。

普段はQiitaばかりで、はてなブログには記事を全く投稿していませんが、  
push-to-hatenablogが結構使いやすかったので、これを機に投稿を増やしていきたいと思います。

## push-to-hatenablogとは

「はてなブログ記事の作成/取得/更新が、CLIで出来るようになります。」

導入方法は、以下のGitHubリポジトリの`README.md`に記載されています。  
そこまで難しくなく、30分もあればGitHubとはてなブログの同期が出来ると思います。

[mm0202/push-to-hatenablog: GitHubとはてなブログの連携用環境。GitHubに記事の編集内容をプッシュするとはてなブログの記事も更新されます。](https://github.com/mm0202/push-to-hatenablog)

以下のブログにも詳しい説明が書いてあるので、詳細はこちらを確認してください。

[push-to-hatenablogを使い，はてなブログへの投稿記事をGitHubで管理したら最高だった！ - tanabebe blog](https://tanabebe.hatenablog.com/entry/2020/07/06/080000)

`README.md`の**セットアップ**まで完了したら、push-to-hatenablogを使いやすくするためにリポジトリのソースコードを修正していきます。

## どのように使いやすくするのか

- main(master)ブランチはバックアップ専用
- entries/*ブランチは修正用
- 記事の新規投稿はCLIで行う

## push.ymlの修正

## pull.ymlの追加

Pullする前に`entries`ディレクトリを削除する必要がありました。

## 管理方法まとめ

## 最後に

[gimonfu で、はてなブログの記事を GitHub と同期する - Qiita](https://qiita.com/basd4g/items/1a38857f6bafb20f065d)
