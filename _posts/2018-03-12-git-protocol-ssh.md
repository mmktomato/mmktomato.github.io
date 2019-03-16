---
layout: post
title: "SSH プロトコルで Git を使う"
description: "SSH プロトコルを使って Git にアクセスする方法です。~/.ssh/config の設定も少し。"
tags: git ssh
redirect_to: "https://moyapro.com/2018/03/12/git-protocol-ssh/"
---

Git を使う会社に転職しまして。さっそく `git clone hoge@example.com:/hoge/hoge.git` したら怒られました。

```
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

SSH プロトコルでアクセスするのに鍵の登録・設定をしていない事が原因でした。(今まで https でしか Git を使ったことがなかった)

なので今回は Git を SSH で使う設定のメモです。キーペアをデフォルト以外のパスに作った場合に必要な設定もメモしておきます。

## キーペアの生成

`ssh-keygen` コマンドを使って公開鍵と秘密鍵のペアを生成します。

```bash
$ ssh-keygen -t rsa -b 4096
```

`-b` オプションを使って bit 長を 4096 としていますが、まあ短すぎなければいいんじゃないですかね。[^1]

[^1]: RSA 鍵 && ビット長を省略した場合は 2048 bit になるようです。(Ubuntu 16.04 (WSL) の man で確認)

次に鍵を保存するファイルパスを入力します。

```
Enter file in which to save the key (/Users/foobar/.ssh/id_rsa):
```

デフォルト値 (例の場合は `/Users/foobar/.ssh/id_rsa`) から変更する場合はここで任意のパスを入力します。その場合は別途設定が必要です。(後述)

最後にパスフレーズを入力します。不要なら入力せずに進みます。

```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

これで公開鍵と秘密鍵のペアが生成されます。

```bash
$ ls ~/.ssh
id_rsa   id_rsa.pub
```

`id_rsa` が秘密鍵、 `id_rsa.pub` が公開鍵です。

## 公開鍵の登録

`id_rsa.pub` の内容をコピーしてサーバーに登録します。登録の方法はサービスによって違うと思いますが、 GitHub なら以下のようにします。

[Generating a new SSH key and adding it to the ssh-agent](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

## 疎通確認とクローン

以下のコマンドで Permission denied 言われなければOKです。`git clone` もできるはず。

```bash
$ ssh -T git@github.com
```

しかし、キーペアをデフォルト以外のパスに作った場合はまだ Permission denied と言われてしまうと思います。

## キーペアをデフォルト以外のパスに作った場合

デフォルトの `~/.ssh/id_rsa` 以外のパスにした場合[^2]、以下のどちらかの設定が必要です。

[^2]: RSA 鍵の場合のデフォルトパスです。他の暗号方式の場合は変わってくると思います。知らんけど。

- `ssh-agent` にどのキーを使うか教えてあげる
- `~/.ssh/config` に設定を書く

### ssh-agent にどのキーを使うか教えてあげる

以下のコマンドを実行します。

```bash
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_rsa_hoge  # 秘密鍵のパス
```

ただしターミナルセッション毎の設定なので、必要なら `.bash_profile` 等に書きましょう。私はあんまり好きじゃない設定です。

### ~/.ssh/config に設定を書く

もしくは `~/.ssh/config` に以下の設定を書きます。

```
Host example.com
  HostName example.com
  IdentityFile ~/.ssh/id_rsa_hoge  # 秘密鍵のパス
  User hoge
```

こっちの方が `.bash_profile` 等よりも役割が明確なファイルなので好ましいと思います。

これで SSH プロトコルで Git を 使えるようになりました。
