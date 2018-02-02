---
layout: post
title: "[Kotlin + JUnit] BeforeClass/AfterClass なメソッドには JvmStatic が必要"
tags: kotlin junit
---

Kotlin + JUnit でテストクラスを書く場合、`@BeforeClass`, `@AfterClass` を付けるメソッドには `@JvmStatic` アノテーションが必要です。

## JvmStatic がない場合

`@JvmStatic` を付け忘れると呼ばれません。

```kotlin
class ExampleUnitTest {
    companion object {
        @BeforeClass
        fun setUpClass() {
            assertTrue(false)  // ← 呼ばれない！
        }

        @AfterClass
        fun tearDownClass() {
            assertTrue(false)  // ← 呼ばれない！
        }
    }

    // 以下略
}
```

ちなみに Android Studio だとメソッドが使用されていない旨の警告になります。こんな感じで。

![JvmStatic がない場合]({{ site.baseurl }}/assets/img/2018/kotlin-beforeclass.jpg)

## JvmStatic がある場合

`@JvmStatic` を付けてあげるとちゃんと呼ばれます。

```kotlin
class ExampleUnitTest {
    companion object {
        @BeforeClass
        @JvmStatic
        fun setUpClass() {
            assertTrue(false)  // ← 呼ばれる
        }

        @AfterClass
        @JvmStatic
        fun tearDownClass() {
            assertTrue(false)  // ← 呼ばれる
        }
    }

    // 以下略
}
```

