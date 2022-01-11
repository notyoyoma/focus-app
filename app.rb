require 'sinatra'
require "sinatra/reloader" if development?
require 'dotenv'
require 'json'
require 'net/http'

Dotenv.load

def search(q)
  opts = {
    q: q || "stop",
    rating: "r",
    api_key: ENV['GIPHY_API_KEY'],
    limit: 1,
    lang: "en"
  }

  uri = URI "https://api.giphy.com/v1/gifs/search?" + URI.encode_www_form(opts)

  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  response_obj['data'][0]['images']['original']['url']
end

get '/' do
  send_file 'index.html'
end

get '/favicon.ico' do
  send_file 'favicon.ico'
end

get '/get_gifs' do
  qs = params.fetch :qs, "no,stop,focus"
  gif_urls = qs.split(',').map {|q| search(q)}
  { urls: gif_urls }.to_json
end
