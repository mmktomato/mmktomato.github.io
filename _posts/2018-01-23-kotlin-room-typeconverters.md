---
layout: post
title: "Room の TypeConverters アノテーションはプライマリコンストラクタの引数に付けられない"
tags: android room kotlin
---

Room という Android の ORM ライブラリがあります。

[Room](https://developer.android.com/topic/libraries/architecture/room.html)

## Room における独自型 と TypeConverter

エンティティのカラムに独自の型を使いたい場合、Room でサポートされている型と相互に変換する TypeConverter を用意し、`@TypeConverters` アノテーションを使って利用する TypeConverter を明示します。(詳しくはこの辺：[【Android Architecture Components】Room Persistence Library 和訳](https://qiita.com/oya-t/items/10e4dd4333df87cd06d4))

で、この `@TypeConverters` アノテーションですが、公式ドキュメントによるとエンティティのフィールドに付けられるらしいのです。

[TypeConverters](https://developer.android.com/reference/android/arch/persistence/room/TypeConverters.html)

> If you put it on an Entity field, only that field will be able to use it.

## Kotlin の場合

しかし Kotlin を使ってエンティティクラスを書く場合、`@TypeConverters` はプライマリコンストラクタの引数で定義するフィールドには付けられないようです。以下サンプル。

```kotlin
// 独自型
enum class Color(val value: Int) {
    RED(1),
    BLUE(2),
    GREEN(3)
}

// 独自型をカラムに持つエンティティ
// favoriteColor は Color 型
@Entity
class User(
        // ...(略)...

        // コンパイルエラー！
        @ColumnInfo(name = "favorite_color")
        @TypeConverters(Converters::class)
        var favoriteColor: Color = Color.RED) {
}

// TypeConverter
class Converters {
    @TypeConverter
    fun toColor(num: Int): Color = Color.values().first { it.value == num }

    @TypeConverter
    fun toInt(color: Color): Int = color.value
}
```

コンパイルエラーになります。

> Cannot figure out how to save this field into database. You can consider adding a type converter for it.

`favoriteColor` の型がわからないので TypeConverter 使え、と怒られます。ちゃんと使ってるつもりなんですけど。

## 解決策

解決策は2通りあって、

* プライマリコンストラクタで定義せずに普通のフィールドにする
* `@TypeConverters` をフィールド以外の場所に付ける

上記のどちらでも良いです。

まずは前者の解決策です。`favoriteColor` をプライマリコンストラクタで定義せず、普通のフィールドとして定義しています。

```kotlin
// 解決策1

// 独自型をカラムに持つエンティティ
// favoriteColor は Color 型
@Entity
class User {
    // ...(略)...

    @ColumnInfo(name = "favorite_color")
    @TypeConverters(Converters::class)
    var favoriteColor: Color = Color.RED
}
```

次に後者の解決策です。`favoriteColor` はプライマリコンストラクタで定義したままで、`@TypeConverters` をフィールド以外の場所に付けます。以下ではエンティティクラスに付けています。

```kotlin
// 解決策2

// 独自型をカラムに持つエンティティ
// favoriteColor は Color 型
@Entity
@TypeConverters(Converters::class)  // @TypeConverters をフィールド以外の場所に付ける
class User(
        // ...(略)...

        @ColumnInfo(name = "favorite_color")
        var favoriteColor: Color = Color.RED) {
}
```

これでコンパイル出来るようになります。
