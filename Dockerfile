FROM ruby:3.1.0

#RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /myapp
COPY Gemfile* ./
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8080

CMD ["rails", "server", "-b", "0.0.0.0"]
