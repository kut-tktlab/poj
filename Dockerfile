FROM ruby:2.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /poj
WORKDIR /poj
ADD Gemfile /poj/Gemfile
ADD Gemfile.lock /poj/Gemfile.lock
RUN bundle install

# install processing-java
RUN wget http://download.processing.org/processing-3.1.1-linux64.tgz
RUN tar xvfz processing-3.1.1-linux64.tgz
ENV PATH ./processing-3.1.1:$PATH

ADD . /poj
