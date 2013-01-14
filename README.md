# Raspberry Pi Weather Station

Here's a real simple web app that displays the current temperature
and humdity as reported by an [SHT15](https://www.sparkfun.com/products/8257).

![screenshot](http://cannikin.github.com/pi_weather/screen.png)

It also provides a RESTful endpoint for simplying returning the temperature
and humidity in JSON.

## Usage

This won't include a guide for installing and running a Sinatra app,
but here are the basics:

1. Clone this repo
2. Run bundler to install required gems: `bundle install`
3. Start the app. You need to run it as root since the Pi requires root
   access to access the GPIO ports: `sudo ruby app.rb`

Now just point your browser to http://localhost:4567 and you should see the
temp and humdity. The page will hit the RESTful endpoint every 5 seconds to
keep the page up-to-date. That endpoint lives at http://localhost:4567/read
