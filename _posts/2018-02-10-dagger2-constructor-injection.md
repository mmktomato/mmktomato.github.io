---
layout: post
title: "Dagger2 コンストラクタインジェクションの例"
description: "Dagger2 でコンストラクタインジェクションをする場合の例。"
tags: android dagger2
---

Dagger2 で DI するにはクラスのフィールドかコンストラクタに `@Inject` アノテーションをつけます。

```kotlin
// フィールドにインジェクト
class Foo {
    @Inject
    lateinit var bar: String
}

// コンストラクタでインジェクト
class Foo @Inject constructor(
        private val bar: String) {
}
```

コンストラクタインジェクションの場合はメンバー変数を `private val` で宣言できるメリットがありますね。ただ、フィールドインジェクションの例はググればたくさん出てくるのですが、コンストラクタインジェクションの例が少ない気がしたのでメモしておきます。

## Dependency

以下のクラスを例とします。プライマリコンストラクタで `name` を受け取ります。

```kotlin
class Person @Inject constructor(
        private val name: String) {

    fun say() {
        println("My name is $name.")
    }
}
```

## Module

Module はフィールドインジェクションの場合と同じです。ここでは String 型を Provide します。

```kotlin
@Module
class PersonModule {
    @Provides
    fun provideName(): String {
        return "Bob"
    }
}
```

## Component

フィールドインジェクションの場合、Component には `inject` というメソッドを用意して `Person` のインスタンスにインジェクトするのが定番ですが、コンストラクタインジェクションの場合は `inject` メソッドはなくても構いません。

ここでは `createPerson` メソッドを用意します。

```kotlin
@Component(modules = [PersonModule::class])
interface HogeComponent {
    fun createPerson(): Person
}
```

## Injection

Component の `createPerson` メソッドを呼ぶと `name` がインジェクトされた `Person` のインスタンスを得ることが出来ます。

```kotlin
val component = DaggerHogeComponent.builder()
        .personModule(PersonModule())
        .build()

val person = component.createPerson()
person.say()  // My name is Bob.
```

## Person を利用するクラスにインジェクションするパターン

上の例では Component に `createPerson` メソッドを用意して `Person` クラスをインスタンス化しましたが、`Person` を利用するクラスのインスタンスに `Person` をインジェクトすることも出来ます。

ここでは `PersonHolder` というクラスのインスタンスに `Person` をインジェクトすることにしましょう。

まず Component に `inject` メソッドを用意します。

```kotlin
interface HogeComponent {
    fun inject(personHolder: PersonHolder)
}
```

次に `Person` クラスのインスタンスを利用する `PersonHolder` のクラスを用意します。

```kotlin
class PersonHolder() {
    @Inject
    lateinit var person: Person

    init {
        DaggerHogeComponent.builder()
                .personModule(PersonModule())
                .build()
                .inject(this)
    }
}
```

ではこの `PersonHolder` をインスタンス化してみましょう。

```kotlin
val personHolder = PersonHolder()
personHolder.person.say()  // My name is Bob.
```

`name` がインジェクトされることを確認できました。この場合は `Person#name` はコンストラクタインジェクション、`PersonHolder#person` はフィールドインジェクションされています。

## 参考

公式ドキュメント [https://google.github.io/dagger/users-guide.html](https://google.github.io/dagger/users-guide.html)

