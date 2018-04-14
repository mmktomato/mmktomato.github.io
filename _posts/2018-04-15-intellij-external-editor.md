---
layout: post
title: "IntelliJ IDEA で外部エディタを使用する"
description: "IntelliJ IDEA で外部エディタを使用してソースファイルを編集します。"
tags: intellij editor vim emacs
---

IntelliJ IDEA で現在開いているファイルを外部エディタで開く方法です。

こちらのページを参考にして Vim (MacVim) でファイルを開けるように設定しました。

[Emacsを外部エディタとして使用する](https://pleiades.io/help/idea/using-emacs-as-an-external-editor.html)

## 外部エディタの設定

`Preferences > Tools > External Tools` と進んでいき、外部ツールを新しく追加します。

![External Tools]({{ site.baseurl }}/assets/img/2018/intellij-external-tools.png)

#### Vim を設定する場合

ここでコマンドライン版の Vim を設定した場合、IntelliJ のコンソールで Vim が開いてしまうことになります。GUI 版の Vim を設定しましょう。

## 現在開いているファイルを外部エディタで開く

`Tools > Editors` から設定したエディタを選択します。(スクリーンショット忘れた)

### キーボードショートカット

いちいちマウスで外部エディタを選択するのは面倒なのでキーボードショートカットを割り当てましょう。 `Preferences > Keymap` から新しいショートカットを追加します。

![Keymap]({{ site.baseurl }}/assets/img/2018/intellij-macvim-keymap.png)
