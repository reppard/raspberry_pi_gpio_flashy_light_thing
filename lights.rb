require 'sinatra'
require 'pi_piper'
include PiPiper

set :port, 80
set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/flash' do
  @params = params[:post]
  times = @params["times"].to_i
  color = @params["color"]
  light = Light.new(color)
  light.flash(times)
  redirect '/'
end

get '/green_off' do
  green = PiPiper::Pin.new(:pin => 4, :direction => :out)
  green.off
end

get '/disco' do
  lights = [Light.new("green"),Light.new("red"),Light.new("yellow")]
  lights.each{|light| light.flash(100)}
  redirect '/'
end

class Light
  PINS = {
    "green" => 4,
    "red" => 17,
    "yellow" => 27
  }

  def initialize(color)
    @color = color
    @pin = PiPiper::Pin.new(:pin => PINS[color], :direction => :out)
  end

  def on
    @pin.on
  end

  def off
    @pin.off
  end

  def flash(times)
    Process.detach(fork{
    times.times do |i|
      puts "DEBUG: #{i}"
      on
      sleep 0.05
      off
      sleep 0.05
    end
    })
  end
end
