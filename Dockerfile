FROM drecom/ubuntu-ruby:2.5.1

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV RACK_ENV=production

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    curl \
    libpq-dev \
    net-tools \
    python \
    python-pip \
    software-properties-common \
  && pip --no-cache-dir install --upgrade pip \
  && pip --no-cache-dir install awscli \
  && update-ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN gem install --no-document \
    ddtrace \
    maxminddb \
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

COPY GeoIP.conf /usr/local/etc/
# This is a cache-buster
ADD https://www.random.org/integers/?num=1&min=1&max=1000&col=1&base=10&format=plain&rnd=new .
RUN /usr/bin/geoipupdate -f /usr/local/etc/GeoIP.conf -d /maxminddb

EXPOSE 8080

CMD ["ruby", "/maxminddb/server.rb", "-p", "8080"]
