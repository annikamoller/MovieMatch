require "sinatra/base"
require_relative "auth"
require_relative "user"

def generate_rand_string(length)
  string = ""
  chars = ("a".."z").to_a
  length.times do
    string += chars[rand(0...chars.length)]
  end
  return string
end

$partys = {}
Party = Struct.new(:code, :users, :movies, :liked, :active, :matches, :genres)

def array_overlap(a, b)
  i = 0
  while i < a.length
    j = 0
    while j < b.length
      if a[i] == b[j]
        return true
      end
      j += 1
    end
    i += 1
  end
  return false
end

get "/party/create" do
  code = generate_rand_string(5)
  users = [getUser()]
  movies = [5, 103, 688]
  liked = Hash.new()
  matches = []
  genres = ["Comedy", "Horror", "Romance", "Action"]

  new_party = Party.new(code, users, movies, liked, false, matches, genres)
  $partys[code] = new_party
  return new_party.to_h.to_json
end

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

def generateMovies(genres)
  foundMovies = []
  movies = $movies.values
  i = 0
  while i < movies.length && foundMovies.length < 100
    if array_overlap(genres, movies[i].genres)
      puts "Movie found and added"
      foundMovies.append(movies[i].id)
    end
    i += 1
  end
  return foundMovies.shuffle
end

get "/party/:code/activate" do
  code = params[:code]
  party = $partys[code]
  party.active = true
  party.movies = generateMovies(party.genres)
  success_response()
end

get "/party/:code/genres/add/:genre" do
  code = params[:code]
  party = $partys[code]
  party.genres.push(params[:genre])
  puts party.genres
end
