Movie = Struct.new(:id, :title, :img, :description, :rating, :genres)

require_relative "moviedb"
require "sinatra/base"

get "/movie" do
  authorize!()
  return $movies[rand(1..$movies.length)]
end

get "/movie/:id" do
  authorize!()
  return $movies[params[:id].to_i].to_h.to_json
end

get "/movie/:id/rating" do
  authorize!()
  return $movies[params[:id].to_i].rating
end
