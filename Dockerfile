FROM ruby:3.1.1-alpine3.14

RUN apk update && apk add --no-cache --update \
    build-base \
    sqlite-libs \
    sqlite-dev \
    postgresql-dev

WORKDIR /myapp
COPY Gemfile* ./
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]
EXPOSE 8080

CMD ["rails", "server", "-b", "0.0.0.0"]
