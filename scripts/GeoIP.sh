#!/usr/bin/env bash

set -e

# To hide the actual secret.
curl -Ls "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&license_key=${LICENSE_KEY}&suffix=tar.gz" | tar xvfz - --strip=1 --wildcards GeoIP2-City_*/GeoIP2-City.mmdb
