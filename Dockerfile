FROM ruby:2.4

WORKDIR /code
RUN gem install bundler --version 2.3.27
COPY Gemfile Gemfile.lock .
RUN bundle install

COPY . .