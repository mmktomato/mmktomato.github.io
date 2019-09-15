FROM ruby:2.6.4-alpine

COPY . /blog
WORKDIR /blog

RUN apk add --no-cache git build-base && bundle install --path vendor/bundle

EXPOSE 4000
ENTRYPOINT ["bundle", "exec", "jekyll", "serve"]
