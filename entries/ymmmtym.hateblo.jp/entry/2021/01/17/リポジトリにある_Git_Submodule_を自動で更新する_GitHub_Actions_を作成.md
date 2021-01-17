---
Title: リポジトリにある Git Submodule を自動で更新する GitHub Actions を作成してみた
Date: 2021-01-17T12:02:37+09:00
URL: https://ymmmtym.hateblo.jp/entry/2021/01/17/%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%AB%E3%81%82%E3%82%8B_Git_Submodule_%E3%82%92%E8%87%AA%E5%8B%95%E3%81%A7%E6%9B%B4%E6%96%B0%E3%81%99%E3%82%8B_GitHub_Actions_%E3%82%92%E4%BD%9C%E6%88%90
EditURL: https://blog.hatena.ne.jp/ymmmtym/ymmmtym.hateblo.jp/atom/entry/26006613679384459
Draft: true
---

以前、リポジトリにある Git Submodule を自動で更新するように、  
GitHub Actionsで実装したことがありました。

Submoduleを含むリポジトリに対して、毎回実装するのは手間なので、  
全部を1つのActionsとして作ってみようと思いました。

GitHub Actions自体を作ることが初めてですが、  
他のActionsのGitHubを参考にしながら作ることが出来ました。

この記事を見て、「GitHub Actionsって意外と簡単に作れる」と感じてもらい、  
Marketplaceで便利なActionsが増えればいいなと思っています。

## GitHub Actionsを作ってみる

まずはMarketplaceで似たようなActionsがあるか確認しました。

[GitHub Marketplace · Tools to improve your workflow](https://github.com/marketplace?query=submodule)
