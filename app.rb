require 'sinatra'
require 'dotenv'
require 'json'
require 'net/http'

Dotenv.load

get '/' do
  send_file 'index.html'
end

get '/get_gifs' do
  uri = URI "https://api.giphy.com/v1/gifs/search?" +
    URI.encode_www_form({
      q: "no stop",
      rating: "r",
      api_key: ENV['GIPHY_API_KEY']
    })

  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  original_gif_urls = response_obj['data'].collect {|x| x['images']['original']['url']}

  { urls: original_gif_urls }.to_json
end
