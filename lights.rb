require 'sinatra'
require_relative 'lib/light.rb'

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

get '/disco' do
  lights = [ Light.new("green"),
             Light.new("red"),
             Light.new("yellow")]

  lights.each{|light| light.flash(100)}
  redirect '/'
end
