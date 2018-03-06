---
layout: post
title: "SSH プロトコルで Git を使う"
description: "SSH プロトコルを使って Git にアクセスする方法です。~/.ssh/config の設定も少し。"
tags: git ssh
---

Git を使う会社に転職しまして。さっそく `git clone hoge@hogehoge.git` したら怒られました。

```
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

SSH プロトコルでアクセスするのに鍵の登録・設定をしていない事が原因でした。今まで https でしか Git を使ったことがなかったんですね。なので今回は Git を SSH で使う設定のメモです。

キーペアのファイル名をデフォルト以外にした場合に必要な設定もメモしておきます。

## キーペアの生成

`ssh-keygen` コマンドを使って公開鍵と秘密鍵のペアを生成します。

```bash
$ ssh-keygen -t rsa -b 4096
```

`-b` オプションを使って bit 長を 4096 としていますが、まあ短すぎなければいいんじゃないですかね。[^1]

[^1]: RSA 鍵 && ビット長を省略した場合は 2048 bit になるようです。(Ubuntu 16.04 (WSL) の man で確認)

次に鍵を保存するファイル名を入力します。

```
Enter file in which to save the key (/Users/foobar/.ssh/id_rsa):
```

デフォルト値 (例の場合は `/Users/foobar/.ssh/id_rsa`) から変更する場合はここで任意のパスを入力します。その場合は別途設定が必要です。(後述)

あとはパスフレーズが必要なら入力します。

```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

これで公開鍵と秘密鍵のペアが生成されます。

```bash
$ ls ~/.ssh
id_rsa   id_rsa.pub
```

## 公開鍵の登録


ここからここから

