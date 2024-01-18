FROM ruby:3.3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

ARG LICENSE_KEY

RUN apt update && apt install -y \
  awscli \
  apt-utils \
  build-essential \
  curl \
  libpq-dev \
  net-tools \
  software-properties-common

RUN update-ca-certificates
RUN rm -rf /var/lib/apt/lists/*

RUN curl -LS "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&license_key=${LICENSE_KEY}&suffix=tar.gz" | tar xvfz - --strip=1 --wildcards GeoIP2-City_*/GeoIP2-City.mmdb

WORKDIR /maxminddb

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY server.rb .
COPY config ./config

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
