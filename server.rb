require 'ddtrace'
require 'json'
require 'maxmind/db'
require 'puma'
require 'sinatra'

set :bind, '0.0.0.0'
set :server, :puma
set :logging, nil

Datadog.configure do |c|
  c.agent.host = '172.17.0.1'
  c.tracing.instrument :sinatra, { service_name: 'tc-geoip.sinatra' }
  c.tracing.instrument :rack,
                       { quantize: { query: { show: ['ip'] } }, service_name: 'tc-geoip.rack', request_queuing: true,
                         web_service_name: 'aws/alb' }
end

configure do
  set :db, MaxMind::DB.new('/maxminddb/GeoIP2-City.mmdb', mode: MaxMind::DB::MODE_MEMORY)
end

before do
  content_type 'application/json'
end

get %r{/api/?} do
  record = settings.db.get(params[:ip])
  record.nil? ? '{}' : record.to_hash.to_json
end

get %r{/internal/(health|test)/?} do
  content_type 'text/plain'
  "#{settings.db.get('8.8.8.8').to_hash.to_json}\nIMOK\n"
end
