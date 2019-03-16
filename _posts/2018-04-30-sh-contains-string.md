---
layout: post
title: "[/bin/sh でも使える] 改行や空白を含む文字列の中に特定の文字列が含まれるかどうか調べる"
description: "改行や空白を含む文字列の中に特定の文字列が含まれるかどうか調べる方法です。bash だけでなく sh でも使えるようにします。"
tags: sh bash
redirect_to: "https://moyapro.com/2018/04/30/sh-contains-string/"
---

シェルスクリプトにおいて、文字列 (`str`) に文字列 (`searchStr`) が含まれるかどうか調べる方法です。echo して grep すればいいかなと思ったんですが、 `str` に改行や空白が含まれる場合にハマったのでメモしておきます。

例に使用する `str` は以下のようにします。

```
$ STR='HOGE HOGE\nFUGA FUGA\nPIYO PIYO'

$ echo -e $STR
HOGE HOGE
FUGA FUGA
PIYO PIYO
```

## /bin/sh の場合
### ハマったパターン

```
#!/bin/sh
$ if [ `echo $STR | grep HOGE` ]; then echo FOUND!!!; fi
/bin/sh: 19: [: HOGE: unexpected operator
```

unexpected operator ... ?

### 正しい書き方

grep の出力に空白が入っているため `test` でエラーになってしまっていました。ダブルクオートでくくればOKです。

```
#!/bin/sh
$ if [ "`echo $STR | grep HOGE`" ]; then echo 'FOUND!!!'; fi
FOUND!!!
```

以下のようにしてもOKですが、`$STR` の内容が出力されてしまっています。

```
#!/bin/sh
$ if echo $STR | grep HOGE; then echo 'FOUND!!!'; fi
HOGE HOGE\nFUGA FUGA\nPIYO PIYO
FOUND!!!
```

## /bin/bash の場合

bash ならもっと簡単に書けます。

```
#!/bin/bash
$ if [[ $STR == *HOGE* ]]; then echo 'FOUND!!!'; fi
FOUND!!!
```
