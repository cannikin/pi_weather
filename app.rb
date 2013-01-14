require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require 'json'
require 'pi_sensor'

configure do
 set :sensor, PiSensor::SHT15.new(:clock => 0, :data => 1)
end

get '/' do
  slim :index
end

get '/read' do
  temperature = (settings.sensor.temperature(:f) * 10).round / 10.0
  humidity = (settings.sensor.humidity * 10).round / 10.0

  content_type :json
  { :temperature => temperature, :humidity => humidity }.to_json
end

__END__

@@ index

html
  head
    title Raspberry Pi Weather Station
    link(href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200" rel="stylesheet" type="text/css")
    script(type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js")
    meta(name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;")
    sass:
      body
        margin: 0
        padding: 0
        font-family: 'Source Sans Pro', Helvetica Neue, sans-serif
        font-weight: 200
        background-color: #BEF2FF
        color: #6ABFCA
      section
        text-align: center
        font-size: 500%
        width: 400px
        margin: 100px auto
        padding: 50px 0
        background-color: rgba(255,255,255,0.5)
        line-height: 2
      @media (max-width:480px)
        body
          margin: 40px
        section
          width: 100%
          margin: 0

  body
    section
      #temperature(style="display:none")
        span.value
        span.symbol °F
      #humidity(style="display:none")
        span.value
        span.symbol %

    javascript:
      $(function() {
        (function read() {
          $.get('/read').success(function(data) {
            $('#temperature').find('.value').text(data.temperature).end().show();
            $('#humidity').find('.value').text(data.humidity).end().show();
          }).complete(function() {
            setTimeout(read, 5000);
          })
        })();
      });
