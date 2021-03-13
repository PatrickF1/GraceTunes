FROM ruby:2.7.2-alpine

EXPOSE 3000

WORKDIR /app

RUN apk add --no-cache bash build-base nodejs postgresql-dev tzdata

COPY ./Gemfile* ./
RUN gem install bundler
RUN bundle install
