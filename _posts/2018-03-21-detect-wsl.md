---
layout: post
title: "[shell] WSL かどうかを判別する"
description: "WSL かどうかを判別する方法です。"
tags: wsl shell bash
---

シェル内で WSL で動いているかどうかを判別する方法をいくつかまとめました。確認した環境は以下のとおりです。

- Ubuntu 16.04 (Windows 10 Creators Update)
- bash

## $PATH 系

### cmd.exe

```
$ which cmd.exe
/mnt/c/Windows/System32/cmd.exe
```

`which cmd` だと違う結果になるので注意しましょう。

### windows/system32

```
$ echo $PATH | grep -i 'windows/system32'
...(略)...
/mnt/c/Windows/System32
```

## ファイルシステム系

### drvfs がマウントされているか

```
$ mount | grep -i 'drvfs'
C: on /mnt/c type drvfs (rw,noatime)
```

### /proc/sys/fs/binfmt_misc/WSLInterop が存在するか

```
$ if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then \
>   echo 'WSL'; \
> fi
WSL
```

## 'Microsoft' が含まれるかどうか系

### uname -r

```
$ uname -r | grep -i 'microsoft'
4.4.0-43-Microsoft
```

### /proc/version

```
$ cat /proc/version | grep -i 'microsoft'
Linux version 4.4.0-43-Microsoft (Microsoft@Microsoft.com) (gcc version 5.4.0 (GCC) ) #1-Microsoft W
ed Dec 31 14:42:53 PST 2014
```

### /proc/version_signature

```
$ cat /proc/version_signature | grep -i 'microsoft'
Microsoft 4.4.0-43-Microsoft 4.4.35
```

### /proc/sys/kernel/osrelease

```
$ cat /proc/sys/kernel/osrelease | grep -i 'microsoft'
4.4.0-43-Microsoft
```

## まとめ

何でもいいんじゃないですかね。

スクリプトの中で使うなら `/proc/sys/fs/binfmt_misc/WSLInterop` の存在をチェックするのが良さそうです。他のコマンドを呼び出さなくてすみますし。

## 参考

以下の issue を参考にいくつか付け加えました。

[Provide a way to positively detect WSL from an app compiled on Linux.](https://github.com/Microsoft/WSL/issues/423)

