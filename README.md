# GitHub Pages

[https://mmktomato.github.io/](https://mmktomato.github.io/)

# Local Build

In WSL(Ubuntu),

```bash
sudo apt install ruby-dev zlib1g-dev libcurl3
```

```bash
$ git clone https://github.com/mmktomato/mmktomato.github.io.git
$ bundle install --path vendor/bundle
```

Exec with `_drafts`,

```bash
$ bundle exec jekyll serve --drafts
```

