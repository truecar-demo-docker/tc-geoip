FROM ruby:3.3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

ARG LICENSE_KEY

RUN apt update && apt install -y curl

RUN update-ca-certificates
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /maxminddb

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY server.rb .
COPY config ./config

RUN curl -Ls "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&license_key=${LICENSE_KEY}&suffix=tar.gz" | tar xvfz - --strip=1 --wildcards GeoIP2-City_*/GeoIP2-City.mmdb

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
