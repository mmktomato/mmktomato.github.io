---
layout: post
title: "Dagger2 コンストラクタインジェクションの例"
tags: android Dagger2 DI
---

Dagger2 で DI するにはクラスのフィールドかコンストラクタに `@Inject` アノテーションをつけます。

```kotlin
// フィールドにインジェクション
class Foo {
    @Inject
    lateinit var bar: String
}

// コンストラクタでインジェクション
class Foo @Inject constructor(private val bar: String) {
}
```

コンストラクタでインジェクションすると `private val` で宣言できるメリットがありますね。ただ、フィールドにインジェクションする例はググればたくさん出てくるのですがコンストラクタでインジェクションする例が少ない気がしたのでメモしておきます。

## Dependency

以下のクラスを例とします。プライマリコンストラクタで `name` を受け取ります。

```kotlin
class Person @Inject constructor(private val name: String){
    fun say() {
        println("My name is $name")
    }
}
```

## Module

## Component

## Injection

inject してもいいし create してもいい。

## 参考

公式ドキュメント [https://google.github.io/dagger/users-guide.html](https://google.github.io/dagger/users-guide.html)

