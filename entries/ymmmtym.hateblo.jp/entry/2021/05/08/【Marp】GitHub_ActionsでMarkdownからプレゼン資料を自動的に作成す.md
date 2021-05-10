---
Title: 【Marp】GitHub ActionsでMarkdownからプレゼン資料を自動的に作成する
Date: 2021-05-08T23:51:57+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/05/08/%E3%80%90Marp%E3%80%91GitHub_Actions%E3%81%A7Markdown%E3%81%8B%E3%82%89%E3%83%97%E3%83%AC%E3%82%BC%E3%83%B3%E8%B3%87%E6%96%99%E3%82%92%E8%87%AA%E5%8B%95%E7%9A%84%E3%81%AB%E4%BD%9C%E6%88%90%E3%81%99
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613726147106
---

Marpとは、markdownからpdfやpptx,htmlファイルを作成することができるツールです。
以下の記事で詳しく記載されています。

[https://zenn.dev/gakin/articles/set_up_marp_on_github_actions:embed:cite]

## 「なぜこの記事を書いているのか？」

上記の記事~~をパクって~~に習ってMarpの設定を試したのですが、同じエラーにハマってしまったため別の方法で設定してみました。

具体的には、DockerでMarpを動かした時に、以下のエラーが発生してしましました。

[https://github.com/marp-team/marp-cli/issues/79:embed:cite]

ファイルパーミッションに問題がありそうなので、以下の権限に変更して試してみましたが解消されませんでした。

```bash
chmod -R 0777 doc/
```

なので、GitHub ActionsにNode.jsをセットアップして`npx`でmarpを実行する方法で代用しました。

## 設定方法

サンプルとして、以下のリポジトリに設定しています。

[https://github.com/ymmmtym/webserver:embed:cite]

設定したことは大きく分けて3つです。

1. プレゼン用のmarkdownファイルの用意
2. GitHub Actionsのworkflowファイル作成
3. GitHub ActionsのConfigファイル作成

### プレゼン用のmarkdownファイルの用意

任意のディレクトリにプレゼンに使用するmarkdownファイルを配置します。
サンプルだと`doc/index.md`を配置しています。

### GitHub Actionsのworkflowファイル作成

使用するworkflowのファイルは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/webserver/blob/main/.github/workflows/marp.yml?slice=1:5"></script>

- PDFが文字化けしないように必要なパッケージをインストール
- Node.jsでmarpをインストール&実行

### GitHub ActionsのConfigファイル作成

使用するconfigファイルは以下になります。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/webserver/blob/main/config.json?slice=1:5"></script>

このconfigはactionsで使用するものとなっており、以下パラメータとなる部分を変数化したものです。

- markdownが置かれているディレクトリの指定
- 変換形式(pdf,pptx,html)
- 言語設定(基本は日本語)

## プレゼン用ファイルの自動生成

上記の設定が完了したら、リポジトリに`git push`された時にGitHub Actionsが実行されます。  
リポジトリの「Actions」タブに移動して、該当のworkflowに移動するとArtifactsにプレゼン用のファイルが作成されています。

## Reference

[https://zenn.dev/gakin/articles/set_up_marp_on_github_actions:embed:cite]
[https://sicklylife.jp/ubuntu/1804/settings.html#font_in:embed:cite]
