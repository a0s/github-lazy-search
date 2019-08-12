FROM ruby:2.6.3-buster

ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 9000

WORKDIR /app
RUN apt-get update && apt-get install -y supervisor redis nodejs
RUN mkdir -p /var/log/supervisor
#COPY docker/supervisord.conf /etc/supervisor/conf.d

COPY . /app
RUN bundle install

CMD ["/usr/bin/supervisord", "-c", "/app/docker/supervisord.conf"]
