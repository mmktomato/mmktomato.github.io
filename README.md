# GitHub Pages

[https://mmktomato.github.io/](https://mmktomato.github.io/)

# Local Build

In WSL(Ubuntu),

```bash
sudo apt install ruby-dev zlib1g-dev libcurl3 libffi-dev
```

```bash
$ git clone https://github.com/mmktomato/mmktomato.github.io.git
$ bundle install --path vendor/bundle
```

Run,

```bash
$ bundle exec jekyll serve
```

With `_drafts` if you want to build drafts.

```bash
$ bundle exec jekyll serve --drafts
```

# Misc

## Show diff about customized files.

```bash
$ diff -ur -x README.md -x assets vendor/bundle/ruby/[RUBY_VER]/gems/minima-[MINIMA-VER] .
```

