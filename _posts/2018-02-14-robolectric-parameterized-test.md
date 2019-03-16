---
layout: post
title: "Robolectric を使った JUnit のパラメタライズドテスト"
description: "JUnit で Robolectric を使いながらパラメタライズドテストを書く方法。"
tags: android junit robolectric kotlin
redirect_to: "https://moyapro.com/2018/02/14/robolectric-parameterized-test/"
---

通常 JUnit でパラメタライズドテストを書くには `Theories` テストランナーや `Parametarized` テストランナーを利用します。

> `Theories` はテストメソッドで、`Parametarized` はコンストラクタでパラメータを受け取ります。

ですが [Robolectric](http://robolectric.org/) を利用して Android アプリのテストを書く場合、`RobolectricTestRunner` をテストランナーとするため、上記のようなテストランナーを使うことが出来ません。

```kotlin
@RunWith(RobolectricTestRunner.class)  // Theories や Parametarized を使えない
class TestClass {
}
```

## ParameterizedRobolectricTestRunner を使う

Robolectric 側で用意している `ParameterizedRobolectricTestRunner` というテストランナーを使うと、Robolectric を使いながらパラメタライズドテストを書くことが出来ます。名前から予想できる通り、テストクラスのコンストラクタでパラメータを受け取ることが出来ます。

**以下の例では Kotlin を使います。**

### コンストラクタ

プライマリコンストラクタでパラメータを取るようにします。

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)
class MyUnitTest(
        private val num1: Int,
        private val num2: Int,
        private val expected: Int)
```

### パラメータ

パラメータは `@ParameterizedRobolectricTestRunner.Parameters` アノテーションを付けた static メソッドに記述します。Kotlin では `@JvmStatic` アノテーションが必要です。

```kotlin
companion object {
    @ParameterizedRobolectricTestRunner.Parameters(name = "{0} + {1} = {2}")
    @JvmStatic
    fun testParams(): List<Array<Any>> {
        return listOf(
                arrayOf<Any>(1, 1, 2),
                arrayOf<Any>(2, 3, 5),
                arrayOf<Any>(9, 4, 13))
    }
}
```

この例ではパラメータが全て `Int` 型のため、`Any` の代わりに `Int` を使うことも出来ます。戻り値の型を共変にするため `out` が必要なことに注意しましょう。[^1]

[^1]: 「型を共変にする」という表現が正しいのかどうかわからない・・・

```kotlin
// Any の代わりに Int を使う例
fun testParams(): List<Array<out Int>> {
    return listOf(
            arrayOf(1, 1, 2),
            arrayOf(2, 3, 5),
            arrayOf(9, 4, 13))
}
```

`arrayOf` に型パラメータを指定しなくて良いので見やすくなりますね。

### テストメソッド

コンストラクタで渡されたパラメータを使うことが出来ます。

```kotlin
@Test
fun addition() {
    assertEquals(expected, num1 + num2)
}
```

### 全体

テストクラスの全体は以下のようになります。

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)
class MyUnitTest(
        private val num1: Int,
        private val num2: Int,
        private val expected: Int) {

    companion object {
        @ParameterizedRobolectricTestRunner.Parameters(name = "{0} + {1} = {2}")
        @JvmStatic
        fun testParams(): List<Array<Any>> {  // Any の代わりに Int を使う例は上記を参照
            return listOf(
                    arrayOf<Any>(1, 1, 2),
                    arrayOf<Any>(2, 3, 5),
                    arrayOf<Any>(9, 4, 13))
        }
    }

    @Test
    fun addition() {
        assertEquals(expected, num1 + num2)
    }
}
```

## まとめ

パラメタライズドテストを書くことで網羅的なテストの見通しがよくなります。

ですが `ParameterizedRobolectricTestRunner` のようにコンストラクタにパラメータを渡す場合、パラメータに関係のないテストも実行してしまうためテストの効率が悪くなってしまう可能性があります。[^2]

[^2]: まあパラメータにはインスタンスが持つ状態を渡すことも多いと思うので「ステートレスなメソッドだと思っていたのに特定の状態のときに意図しない結果になっていた」みたいなケースを拾える利点はありますが。

これは `Theories` のようにテストメソッドにパラメータを渡せれば解決するのですが、Robolectric を使った場合のやり方がわかりませんでした・・・

## 参考

こちらの記事を参考にしました。Java で書いてあります。

[Parameterized testing with Robolectric](https://blog.jayway.com/2015/03/19/parameterized-testing-with-robolectric/)


