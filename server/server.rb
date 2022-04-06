require "sinatra"
require "sinatra/json"
require "json"
require_relative "movies"
require_relative "auth"
require_relative "party"
require_relative "user"

before do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
end
