---
Title: Upptimeでウェブサイトの死活監視をしてみる
Date: 2021-01-11T20:25:26+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/05/Upptime%E3%81%A7%E3%82%A6%E3%82%A7%E3%83%96%E3%82%B5%E3%82%A4%E3%83%88%E3%81%AE%E6%AD%BB%E6%B4%BB%E7%9B%A3%E8%A6%96%E3%82%92%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613674493873
Draft: true
---

Upptimeとは、OSSの死活監視ソフトウェアです。

[https://upptime.js.org/:embed:cite]

GitHubのサービス(GitHub Actions,GitHub Pages,GitHub Issues)のみを使って、  
サービスごとに以下のような死活監視を行うことができます。

| 使用するGitHubのサービス | 機能                 |
| --------------- | ------------------ |
| GitHub Actions  | 5分毎に特定のWebサイト監視    |
| GitHub Pages    | 監視ステータスを表示するWebサイト |
| GitHub Issues   | サイトがDownした時の報告     |

その他にも、監視するHTTPステータスコード、Slackやメール、SMS通知などを設定することができます。

自身のリポジトリを作成して、Upptimeを構築してみます。

## Upptimeを構築する

[公式サイト](https://upptime.js.org/)の**Getting started**に沿って進めていきます。  
簡単に構築することが出来て、10分あればデフォルトの状態を作成することができます。

### リポジトリ作成

[https://github.com/upptime/upptime:embed:cite]

上記のリポジトリに移動して、「Use this template」をクリックします。  
画面が遷移したら、以下の設定をします。

- Repository name: 任意でOK
- Include all branches: チェック

この状態で「Create repository from template」をクリックすると、  
自身のリポジトリが作成されます。

### GitHub Pages設定

UpptimeのWebサイトは、デフォルトで**gh-pages**ブランチに作成されます。  
このブランチをGitHub Pagesで公開する設定をします。

リポジトリの「Settings」にあるGitHub Pagesの設定に移動します。  
「Source: gh-pages /(root)」で「Save」をクリックします。

### Secrets設定

Upptimeで使用されるGitHub Actionsでは、  
監視やWebサイトの作成だけでなく、リポジトリ更新も行います。

したがって、Actionsで使用するPAT(Personal Access Token)を作成する必要があります。

#### Personal Access Token

#### Repository Secrets

作成したPATをRepository Secretsに登録します。

### 設定ファイルの修正

Upptimeの設定は`.upptimerc.yml`の1つのファイルで定義されています。  
masterブランチでこのファイルを修正することで、全体の設定をすることが出来ます。

ここでは、Upptimeを構築する上で必須となる項目を設定していきます。  
変更する箇所を抜粋したものは以下になります。

```yaml:.upptimerc.yml
owner: ymmmtym # GitHub username
repo: upptime # GitHub repository名
sites: # 監視するサイトの名前とURLをリスト形式で書く
  - name: Google
    url: https://www.google.com
status-website:
  cname: <カスタムドメイン名> # カスタムドメインを使用しない場合はコメントアウトする
  baseUrl: /<リポジトリ名> # カスタムドメインを使用する場合はコメントアウトする
  name: Upptime # 監視サイトの名前
```

修正する内容をまとめると以下のようになります。

| 項目               | 説明                             |
| ---------------- | ------------------------------ |
| owner            | GitHubのユーザ名                    |
| repo             | リポジトリ名                         |
| sites            | 監視するサイトのリストを name:, url: 形式で追加 |
| (status-website) | ここから監視サイトの設定                 |
| cname            | カスタムドメイン名                      |
| baseUrl          | /リポジトリ名                        |
| name             | 監視サイト名                         |

上記の修正をしてcommitすると、"Setup CI"というworkflowが実行され、完了するとUpptimeが構築されています。

`http://<GitHubユーザ名>.github.io/<リポジトリ名>`にアクセスすると、Upptimeにアクセスできます。

### さいごに

以上でUpptimeを構築することが出来ました。  
デフォルトの状態ではありますが、監視の詳細設定や通知方法なども解説できればと思います。

## Reference

[https://gigazine.net/news/20210104-upptime/:embed:cite]
