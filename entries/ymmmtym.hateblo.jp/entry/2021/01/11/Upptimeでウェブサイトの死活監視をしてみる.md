---
Title: Upptimeでウェブサイトの死活監視をしてみる
Category:
- IT
- Monitoring
Date: 2021-01-11T20:25:26+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/11/Upptime%E3%81%A7%E3%82%A6%E3%82%A7%E3%83%96%E3%82%B5%E3%82%A4%E3%83%88%E3%81%AE%E6%AD%BB%E6%B4%BB%E7%9B%A3%E8%A6%96%E3%82%92%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613674493873
Draft: true
---

Upptimeとは、OSSの死活監視ソフトウェアです。

[https://upptime.js.org/:embed:cite]

GitHubのサービス(GitHub Actions,GitHub Pages,GitHub Issues)のみを使って、サービスごとに以下のような死活監視を行うことができます。

| 使用するGitHubのサービス | 機能                 |
| --------------- | ------------------ |
| GitHub Actions  | 5分毎に特定のWebサイト監視    |
| GitHub Pages    | 監視ステータスを表示するWebサイト |
| GitHub Issues   | サイトがDownした時の報告     |

その他にも、監視するHTTPステータスコード、Slackやメール、SMS通知などを設定することができます。

私は、サイト監視に「UptimeRobot」と言うSaaSの無料プランを使っていますが、

- 「自身が運営しているサイトの監視をソースコード管理したい」
- 「OSSで完全無料で使える監視サイトを自分で構築したい」

と言う人には「Upptime」が向いているかなと思います。

(ちなみに、UptimeRobotはこちら)

[https://uptimerobot.com/:embed:cite]

それでは自身のリポジトリを作成して、Upptimeを構築してみます。

## Upptimeを構築する

[公式サイト](https://upptime.js.org/)の**Getting started**に沿って進めていきます。  
簡単に構築することが出来て、10分あればデフォルトの状態を作成することができます。

### リポジトリ作成

[https://github.com/upptime/upptime:embed:cite]

上記のリポジトリに移動して、「Use this template」をクリックします。
  
<figure class="figure-image figure-image-fotolife" title="Upptime formal repotitory">[f:id:ymmmtym:20210117215121p:plain:alt=Upptime formal repotitory]<figcaption>Upptime formal repotitory</figcaption></figure>

画面が遷移したら、以下の設定をします。

- Repository name: 任意でOK
- Include all branches: チェック

<figure class="figure-image figure-image-fotolife" title="Create Upptime repository own from template">[f:id:ymmmtym:20210117215151p:plain:alt=Create Upptime repository own from template]<figcaption>Create Upptime repository own from template</figcaption></figure>

この状態で「Create repository from template」をクリックすると、  
「Repository name」で入力した名前で、自身のリポジトリが作成されます。

作成したリポジトリに移動したら、必要な設定をしていきます。  
まずはGitHubのWeb上で行う設定をしていきます。

### GitHub Pages設定

UpptimeのWebサイトは、デフォルトで**gh-pages**ブランチに作成されます。  
このブランチをGitHub Pagesで公開する設定をします。

リポジトリの「Settings」にあるGitHub Pagesの設定に移動します。  
「Source: gh-pages /(root)」で「Save」をクリックします。

<figure class="figure-image figure-image-fotolife" title="Setting branch of GitHub Pages">[f:id:ymmmtym:20210117215142p:plain:alt=Setting branch of GitHub Pages]<figcaption>Setting branch of GitHub Pages</figcaption></figure>

### Secrets設定

Upptimeで使用されるGitHub Actionsでは、  
監視やWebサイトの作成だけでなく、リポジトリ更新も行います。

つまり、GitHub Actionsの処理中にリポジトリを編集する権限が必要になるので、  
Actionsで使用するPAT(Personal Access Token)を作成する必要があります。

#### Personal Access Token の作成

GitHubのサイトから、右上のアイコンをクリックして「Settings」を開きます。

<figure class="figure-image figure-image-fotolife" title="GitHub Personal Settings">[f:id:ymmmtym:20210117215210p:plain:alt=GitHub Personal Settings]<figcaption>GitHub Personal Settings</figcaption></figure>

次に、「Developer settings」 > 「Personal access tokens」に移動して、  
「Generate new token」をクリックします。

[f:id:ymmmtym:20210117215215p:plain]

GitHubのパスワードが求めらるので、入力すると以下の画面になります。

(画像)

「Note」には、何のtokenであるか分かるような名前を入力します。  
(私は「upptime」とだけ入れました)

「repo」と「workflow」にチェックを入れたら、  
画面下までスクロールして、「Generate token」をクリックするとtokenが作成されます。

(画像)

このtokenはリポジトリの設定に必要となるので、メモっておきましょう。

また、このtokenがあればリポジトリにアクセスできてしまうので、  
取り扱いには注意してください。

#### Repository Secrets

作成したPATをRepository Secretsに登録します。

リポジトリに戻って、「Settings」 > 「Secrets」の順に開きます。

(画像)

「New repository secret」をクリックして、

- Name: GH_PAT
- Value: 先ほど作成したPAT

を入力し、「Add secret」をクリックします。

(画像)

以上で、リポジトリに関する設定は完了です。

### 設定ファイルの修正

Upptimeの設定は、リポジトリ配下にある`.upptimerc.yml`の1つのファイルで定義されています。  
masterブランチでこのファイルを修正することで、全体の設定をすることが出来ます。

私の`.upptimerc.yml`は以下のようになっています。

<script src="https://gist-it.appspot.com/https://github.com/ymmmtym/upptime/blob/master/.upptimerc.yml?slice=1:5"></script>

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

私の場合は、`ymmtym.github.io`のドメインに`ymmmtym.com`と言うカスタムドメインを使っていたのですが、  
Upptimeには使用していないので、cnameはコメントアウトしてbaseUrlをコメントインしています。

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

(画像)

サイト監視については、Upptimeのwebサイトが更新されるだけでなく`README.md`も更新されるので、  
かっこいいREADMEが勝手に作成されるところも、少し気に入っています。

### さいごに

以上でUpptimeを構築することが出来ました。  
デフォルトの状態ではありますが、監視の詳細設定や通知方法なども解説できればと思います。

## Reference

[https://gigazine.net/news/20210104-upptime/:embed:cite]
