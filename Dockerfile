FROM drecom/ubuntu-ruby:2.4.4

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    libpq-dev \
    net-tools \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document \
    maxminddb \
    puma \
    rack \
    sinatra \
  && echo 'Gem finish'

RUN mkdir -p /maxminddb
WORKDIR /maxminddb

RUN add-apt-repository ppa:maxmind/ppa && apt-get update && apt-get install -y \
    geoipupdate \
  && rm -rf /var/lib/apt/lists/*
COPY GeoIP.conf /usr/local/etc/
RUN /usr/bin/geoipupdate -f /usr/local/etc/GeoIP.conf -d /maxminddb

EXPOSE 8080

COPY ./server.rb /maxminddb/server.rb
RUN mkdir -p /maxminddb/config
COPY ./config/puma.rb /maxminddb/config/puma.rb

RUN wget https://raw.git.corp.tc/infra/universal-build-script/master/secrets.sh && chmod +x ./secrets.sh

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
