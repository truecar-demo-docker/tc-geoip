FROM drecom/ubuntu-ruby:2.5.3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

ARG LICENSE_KEY=blah
ARG LICENSE_USERID=blah

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    curl \
    libpq-dev \
    net-tools \
    python3 \
    python3-pip \
    software-properties-common \
  && pip3 --no-cache-dir install --upgrade pip \
  && pip --no-cache-dir install awscli \
  && update-ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document \
    ddtrace \
    maxmind-db \
    puma \
    rack \
    sinatra \
  && echo 'Gem finish'

RUN add-apt-repository ppa:maxmind/ppa && apt-get update && apt-get install -y \
    geoipupdate \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /maxminddb
WORKDIR /maxminddb

ADD https://raw.git.corp.tc/infra/universal-build-script/master/secrets.sh .
RUN chmod +x ./secrets.sh

COPY ./server.rb /maxminddb/server.rb
RUN mkdir -p /maxminddb/config
COPY ./config/puma.rb /maxminddb/config/puma.rb

COPY scripts/GeoIP.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/GeoIP.sh && /usr/local/bin/GeoIP.sh

# This is a cache-buster
ADD https://www.random.org/integers/?num=1&min=1&max=1000&col=1&base=10&format=plain&rnd=new .
RUN /usr/bin/geoipupdate -f /usr/local/etc/GeoIP.conf -d /maxminddb

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
