---
layout: post
title: "WSL の Windows 側のパスが変わってた"
description: "Windows 側から見た WSL の rootfs のパスが Fall Creators Update で変わってた。"
tags: wsl
redirect_to: "https://moyapro.com/2018/04/08/wsl-path-changed/"
---

Windows 側からみた WSL の rootfs のパスがいつの間にか変わってたっていう話です。

以前は

```
%LOCALAPPDATA%\lxss\rootfs
```

だったんですが

```
%LOCALAPPDATA%\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs
```

に変わってました。(Ubuntu の場合)

Fall Creators Update で Miscrosoft Store 経由でのインストールに変わりましたが、そのタイミングでパスも変わったようです。

### 参考

おっかしいなー rootfs が見当たらない・・・と思ってググったら以下の StackOverflow を見つけたのでした。

[Where has C:\Users\%USERNAME%\AppData\Local\lxss gone under Windows Fall Creators Update [closed]](https://stackoverflow.com/questions/46820268/where-has-c-users-username-appdata-local-lxss-gone-under-windows-fall-creator)
