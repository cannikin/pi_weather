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
    script(type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js")
    meta(name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;")
    sass:
      body
        margin: 0
        padding: 0
        font-family: 'Helvetica Neue', sans-serif
        font-weight: 100
        background-color: #BEF2FF
        color: #6ABFCA
      section
        text-align: center
        width: 400px
        margin: 100px auto
        padding: 50px 0
        background-color: rgba(255,255,255,0.5)
        line-height: 1
        & div:first-child
          margin: 0 0 4em
      .value, .symbol
        font-size: 500%
      .label
        display: block

      @media (max-width:568px)
        .container
          width: 100%
          height: 100%
        section
          width: auto
          margin: 40px
          overflow: hidden
          .value, .symbol
            font-size: 400%

      @media (max-width: 568px) and (min-width: 321px)
        section
          div
            float: left
            width: 50%
            margin-bottom: 0
          & div:first-child
            margin: 0

      @media (max-width: 320px)
        section
          .value, .symbol
            font-size: 400%

  body
    .container
      section
        #temperature(style="display:none")
          span.value
          span.symbol °F
          span.label Temperature
        #humidity(style="display:none")
          span.value
          span.symbol %
          span.label Relative Humidity

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
