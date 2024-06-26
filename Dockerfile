FROM ruby:3.3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

ARG LICENSE_KEY

RUN apt update && apt install -y awscli curl

RUN update-ca-certificates
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /maxminddb

COPY Gemfile Gemfile.lock ./

RUN bundle install

ADD https://raw.git.corp.tc/infra/universal-build-script/master/secrets.sh .
RUN chmod +x ./secrets.sh

COPY server.rb scripts/GeoIP.sh ./
COPY config ./config

RUN chmod +x ./GeoIP.sh
RUN ./GeoIP.sh

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
