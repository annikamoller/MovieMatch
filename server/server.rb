require "sinatra"
require "sinatra/json"
require "json"
require_relative "movies"
require_relative "lib/auth"

def getUser()
  user = authorize!()
  return user.username
end

def tally(array)
  i = 0
  count = Hash.new(0)
  while i < array.length
    count[array[i]] += 1
    i += 1
  end
  return count
end

before do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  # request.body.rewind
  # @request_payload = JSON.parse request.body.read
end

post "/register" do
  request.body.rewind
  @request_payload = JSON.parse request.body.read

  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  username = @request_payload["user"]
  password = @request_payload["password"]
  if findUserByName(username) != nil
    error(422, "Username already exist")
  end
  return addUser(username, password).to_h.to_json
end

post "/login" do
  request.body.rewind
  @request_payload = JSON.parse request.body.read

  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  username = @request_payload["user"]
  password = @request_payload["password"]

  user = findUserByName(username)

  if user == nil || user.password != password
    return unauthorized_response()
  end

  success_response(getToken(user.id))
end

get "/movie" do
  authorize!()
  return $movies[rand(1..$movies.length)]
end

get "/movie/:id" do
  return $movies[params[:id].to_i].to_h.to_json
end

get "/movie/:id/rating" do
  return $movies[params[:id].to_i].rating
end

get "/me" do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  user = authorize!()
  return user.username
end

get "/party/create" do
  code = generate_rand_string(5)
  users = [getUser()]
  movies = [1, 2, 3]
  liked = Hash.new()
  matches = []
  genres = []

  new_party = Party.new(code, users, movies, liked, false, matches, genres)
  $partys[code] = new_party
  return new_party.to_h.to_json
end

$partys = {}
Party = Struct.new(:code, :users, :movies, :liked, :active, :matches, :genres)

options "/**" do
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "PUT"

  halt 200
end

#TODO try to make this a put requeest
get "/party/:code/join" do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  response.headers["Access-Control-Allow-Methods"] = "PUT"

  user = getUser()
  i = 0
  users = $partys[params[:code]].users
  while i < users.length
    if users[i] == user
      error 422
    end
    i += 1
  end

  users.append(user)
  p $partys
  return $partys[params[:code]].to_h.to_json
end

get "/party/:code" do
  return $partys[params[:code]].to_h.to_json
end

get "/party/:code/movies" do
  return $partys[params[:code]].movies.join(",")
end

get "/party/:code/like/:movieid" do
  puts "hmmmmm"
  userid = authorize!().id
  movieid = params[:movieid].to_i
  code = params[:code]
  party = $partys[code]

  puts "Hi i want to like #{movieid}, i am #{userid}"

  if !party.liked.key?(movieid)
    party.liked[movieid] = []
  end

  party.liked[movieid].push(userid)

  if party.liked[movieid].length == 2
    party.matches.push(movieid)
    puts "It's a match"
  end

  p party.liked[movieid]
  
  success_response()
end

get "/party/:code/activate" do
  code = params[:code]
  party = $partys[code]
  party.active = true
  success_response()
end

#TODO get this to work
get "/party/:code/genres/add/:genre" do
  code = params[:code]
  party = $partys[code]
  party.genres.push(params[:genre])
  puts party.genres
end

$tokens = {}

def generate_token(username)
  token = generate_rand_string(9)
  $tokens[token] = username
  return token
end

def generate_rand_string(length)
  string = ""
  chars = ("a".."z").to_a
  length.times do
    string += chars[rand(0...chars.length)]
  end
  return string
end
