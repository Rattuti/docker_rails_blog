# テキストのバージョンであるRuby3.0.1に揃える
FROM ruby:3.0.3
 
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
 
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /docker_rails_blog
WORKDIR /docker_rails_blog
COPY Gemfile /docker_rails_blog/Gemfile
COPY Gemfile.lock /docker_rails_blog/Gemfile.lock
RUN bundle install
COPY . /docker_rails_blog
 
# コンテナ起動時に毎回実行する
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
 
# rails s　実行.
CMD ["rails", "server", "-b", "0.0.0.0"]