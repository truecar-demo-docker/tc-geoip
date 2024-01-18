FROM ruby:3.3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

ARG LICENSE_KEY
ARG LICENSE_USERID

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

RUN curl -Ls https://github.com/maxmind/geoipupdate/releases/download/v6.1.0/geoipupdate_6.1.0_linux_386.tar.gz | tar xvfz - --strip=1 -C /usr/bin geoipupdate_6.1.0_linux_386/geoipupdate

WORKDIR /maxminddb

COPY Gemfile Gemfile.lock ./

RUN bundle install

ADD https://raw.git.corp.tc/infra/universal-build-script/master/secrets.sh .
RUN chmod +x ./secrets.sh

COPY server.rb .
COPY config ./config

COPY scripts/GeoIP.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/GeoIP.sh && /usr/local/bin/GeoIP.sh

# This is a cache-buster
ADD https://www.random.org/integers/?num=1&min=1&max=1000&col=1&base=10&format=plain&rnd=new .
RUN /usr/bin/geoipupdate -f /usr/local/etc/GeoIP.conf -d /maxminddb

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
