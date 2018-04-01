---
layout: post
title: "WSL の Vim でもインサートモードを抜けるときに日本語入力を OFF にしたい"
description: "AutoHotkey を使って Vim のインサートモードを抜けるときに日本語入力を OFF にする。"
tags: vim wsl autohotkey ime
---

インサートモードで日本語を書いてノーマルモードに戻ると日本語入力のままになっていて悲しい思いをしますね。

これには解決方法が色々あります。香り屋さんの Vim を使う(set imdisable)とか、Google IME を使う(`escape`キーで英数字入力にする)とか[^1]。

[^1]: Google IME を使った方法だと `jj` でノーマルモードに戻ったときに効かなかったりしてイマイチです。

私の場合、Mac で Vim を使う時は InsertLeave 時に [swim](https://github.com/mitsuse/swim) を叩く事で解決していました。

でも WSL では解決方法を見つけられないままでした。なぜなら WSL上 の Vim は完全に Linux バイナリなので、日本語入力をゴニョゴニョしようと思ったら Linux デスクトップの IM をゴニョゴニョするしか方法がありません。そうなると X Window を立ち上げたり、そもそも Winidows 側の日本語入力を使えなかったり・・・考えただけでもメンドクサイです。

それが、AutoHotkey を使うことで解決できました。

## AutoHotkey

Windows を使い込む人なら知らない人はいない(と思う)アレです。説明は省略。

[AutoHotkey](https://autohotkey.com/)

ダウンロードして適当なパスに保存します。**`AutoHotkeyU64.exe` にパスを通しておきます。**

## AutoHotkey で日本語入力を OFF にするスクリプト

は、こうです。日本語キーボードの「ひらがな/カタカナ」を押した後に「半角/全角」を押したことにします。

```
Send {vkF2sc070}  ; Kana
Send {vkF4sc029}  ; ZenHan
```

これを適当なパスに保存しておきます。今回は `C:\tool\ImDisable.ahk` とします。

## .vimrc

### WSL かどうかを判定する関数

を、作っておきます。前回書いた記事が役立ちました。

[[shell] WSL かどうかを判別する](https://mmktomato.github.io/2018/03/21/detect-wsl.html)

```
function! s:isWsl()
    return filereadable('/proc/sys/fs/binfmt_misc/WSLInterop')
endfunction
```

### InsertLeave で 日本語入力を OFF にする

インサートモードから抜けるときに上記の AHK スクリプトを叩きます。

```
if s:isWsl() && executable('AutoHotkeyU64.exe')
    augroup insertLeave
        autocmd!
        autocmd InsertLeave * :call system('AutoHotkeyU64.exe "C:\tool\ImDisable.ahk"')
    augroup END
endif
```

`AutoHotkeyU64` には Windows のパス形式で渡す必要があります。`wslpath` コマンドが使えるようになったら WSL 側に置いたスクリプトを Linux のパス形式で渡せるようになりますが、それはまた別のお話。[^2]

[^2]: Windows10 の次期大型アップデート(RS4)で使えるようになる予定です。

## 結果

快適そのもの。なんでもっと早く思いつかなかったんだろう。
