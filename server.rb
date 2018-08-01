require 'sinatra'
require 'maxminddb'

set :bind, '0.0.0.0'

before do
  @db = MaxMindDB.new('/maxminddb/GeoIP2-City.mmdb')
  content_type 'application/json'
end

get %r>/api/?> do
  @db.lookup(params[:ip]).to_hash.to_json
end

get %r>/internal/health/?> do
  content_type 'text/plain'
  'IMOK'
end
