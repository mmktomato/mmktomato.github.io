---
layout: post
title: "CSS Variables はじめの一歩"
description: "CSS Variables についての超基礎的な記事です。"
tags: css
redirect_to: "https://moyapro.com/2018/02/26/css-variables-basics/"
---

CSS Variables についてのこんな記事を読みまして。

[Learn CSS Variables in 5 minutes](https://medium.freecodecamp.org/learn-css-variables-in-5-minutes-80cf63b4025d)

なるほどこれは良い、と思ったので理解したことをまとめました。**超基礎的な内容です。**

## CSS Variables

その名の通り、CSS に変数の概念を持ち込んだものです。LESS や SASS でいいじゃんという声もあると思いますが、**JS で値を書き換えられる**のが大きな利点です。

## 基本的な使い方

prefix として `--` を付けた名前が変数と見なされます。変数へのアクセスは `var()` 関数を利用します。

```css
:root {
    --container-width: 800px;
}

.container {
    width: var(--container-width);
}
```

`var()` 関数は `calc()` 関数の中でも使えます。

```css
.item {
    width: calc(var(--container-width) / 4);
}
```

## 変数のスコープ

変数にはスコープがあります。ここからは以下のような DOM 構造を例に取って説明します。

```html
<div class="container">
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
</div>
<span>ABC</span>
```

### グローバルスコープ

`:root` 擬似クラスで定義した変数はグローバルスコープとなり、どの要素からでも参照出来ます。

```css
:root {
    /* --container-width はグローバルスコープ。 */
    --container-width: 800px;
}

.container {
    /* --container-width を参照できる。 */
    width: var(--container-width);
}

.item {
    /* --container-width を参照できる。 */
    width: calc(var(--container-width) / 4);
}

span {
    display: block;

    /* --container-width を参照できる。 */
    width: var(--container-width);
}
```

### ローカルスコープ

各要素の中で定義した変数はローカルスコープとなり、定義した要素とその子要素から参照できます。

```css
.container {
    /* --margin はローカルスコープ。 */
    --margin: 1em;

    margin: calc(var(--margin) * 2);
}

.item {
    /* .item は .container の子要素なので --margin を参照できる。 */
    margin: var(--margin);
}

span {
    /* span は .container の子要素ではないので --margin を参照できない。 */
    margin: var(--margin);  /* NG */
}
```

## JS で値を読み書き

`CSSStyleDeclaration` の `getPropertyValue()` メソッドを利用して変数の値にアクセス出来ます。

```javascript
let container = document.querySelector(".container");
let containerStyle = getComputedStyle(container);
let containerWidth = containerStyle.getPropertyValue("--container-width");

console.log(containerWidth);  // 800px
```

上記では `.container` な要素のローカル変数にアクセスしていますが、`document.querySelector(":root")` とすれば `:root` 擬似クラスで定義したグローバル変数にアクセス出来ます。

### 値の書き換えは style 経由で

値の書き換えには `setProperty()` を利用しますが、上記のように `getComputedStyle()` で取得した `CSSStyleDeclaration` に対して呼び出すと例外が投げられます。

```javascript
let container = document.querySelector(".container");
let containerStyle = getComputedStyle(container);
let containerWidth = containerStyle.setProperty("--container-width", "600px");

// 例外が投げられる。Chrome の場合は以下のようなメッセージ。
// Uncaught DOMException: Failed to execute 'setProperty' on 'CSSStyleDeclaration': These styles are computed, and therefore the '--container-width' property is read-only.
```

普通に `style` 経由で `setProperty()` を呼び出してあげると書き換えられます。

```javascript
let container = document.querySelector(".container");
let containerWidth = container.style.setProperty("--container-width", "600px");
```

これで `--container-width` を利用しているスタイルは全て再評価されます。

冒頭で紹介したサイトでは「ユーザーがサイトのテーマカラーを変えるのにピッタリ」というように書いてあります。正にその通りですね。

> This main color can change the entire look of you app, so it’s perfect for allowing users to set the theme of your site.


