FROM ruby:2.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /poj
WORKDIR /poj
ADD Gemfile /poj/Gemfile
ADD Gemfile.lock /poj/Gemfile.lock
RUN bundle install
ADD . /poj
