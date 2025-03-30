FROM ruby:3.4

WORKDIR /srv/jekyll

RUN gem install jekyll bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

EXPOSE 4000

CMD ["jekyll"]