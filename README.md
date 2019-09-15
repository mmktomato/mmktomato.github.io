# GitHub Pages

[https://mmktomato.github.io/](https://mmktomato.github.io/)

# Build

```bash
sudo apt install ruby-dev zlib1g-dev libcurl3 libffi-dev
$ git clone https://github.com/mmktomato/mmktomato.github.io.git
$ bundle install --path vendor/bundle

# or

docker build -t my/blog .
```

# Run

```bash
$ bundle exec jekyll serve

# or

docker run --rm -p 4000:4000 my/blog
```

With `_drafts` if you want to build drafts.

```bash
$ bundle exec jekyll serve --drafts

# or

docker run --rm -p 4000:4000 my/blog --drafts
```

# Misc

## Show diff about customized files.

```bash
$ diff -ur -x README.md -x assets vendor/bundle/ruby/[RUBY_VER]/gems/minima-[MINIMA-VER] .
```

