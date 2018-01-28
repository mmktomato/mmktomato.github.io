---
layout: post
title: "git-prompt.sh と GIT_PS1_SHOWCOLORHINTS"
---

シェルのプロンプトに git リポジトリのブランチ名(やその他の情報)を表示したいときには `git-prompt.sh` を使います。

> git-prompt.sh の導入方法・使い方についてはここでは省略します。

このときブランチ名をカラーで表示するには `GIT_PS1_SHOWCOLORHINTS` という変数を利用するのですが、この変数の使い方について日本語の情報が意外と少ないようなのでメモしておきます。

## GIT_PS1_SHOWCOLORHINTS

[git-prompt.sh の中身](https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh) を見ると、

1. `GIT_PS1_SHOWCOLORHINTS` に何かの値を入れて、
2. `__git_ps1` を `PROMPT_COMMAND` の中で使う。

と書いてあるのでこれに従います。

```.bashrc
GIT_PS1_SHOWCOLORHINTS=true
PROMPT_COMMAND="__git_ps1 '\u@\h \w' ' \\\$ '"
```

普通、 `__git_ps1` は `PS1` 環境変数の中で使いますが、 `GIT_PS1_SHOWCOLORHINTS` を使う場合は代わりに `PROMPT_COMMAND` を使う必要があるので注意しましょう。

## サンプル

ブランチ名に色がついています。

![GIT_PS1_SHOWCOLORHINTS サンプル]({{site.baseurl}}/assets/img/2018/git-ps1-showcolorhints-sample.jpg)

