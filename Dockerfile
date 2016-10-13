FROM ruby:2.3
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
