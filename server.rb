require 'sinatra'
require 'maxminddb'
require 'puma'

set :bind, '0.0.0.0'
set :server, :puma
set :logging, nil

configure do
  set :db, MaxMindDB.new('/maxminddb/GeoIP2-City.mmdb')
end

before do
  content_type 'application/json'
end

get %r>/api/?> do
  settings.db.lookup(params[:ip]).to_hash.to_json
end

get %r>/internal/(health|test)/?> do
  content_type 'text/plain'
  settings.db.lookup('127.0.0.1').to_hash.to_json + "\nIMOK\n"
end
