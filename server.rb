require 'sinatra'
require 'json'
require_relative 'movies'

$users = {"annika" => "password", "lucas" => "secret"}

def getUser()
    token = params[:token]
    if !$tokens.key?(token)
        error 401
    end
    return $tokens[token]
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

post "/register" do
    response["Access-Control-Allow-Origin"] = "*"
    username = params[:user]
    password = params[:password]
    if $users.key?(username)
        error 422
    else 
        $users[username] = password
    end
    return "Success"
end

post "/login" do
    response["Access-Control-Allow-Origin"] = "*"
    if $users[params[:user]] == params[:password]
        return generate_token(params[:user])
    else
        error 401
    end
end

get "/movie" do
    token = params[:token]
    if !$tokens.key?(token)
        error 401
    end
    return $movies[rand(1..$movies.length)]
end

get "/movie/:id" do
    return $movies[params[:id].to_i].to_h.to_json
end

get "/movie/:id/rating" do
    return $movies[params[:id].to_i].rating
end

get "/me" do
    return getUser()
end

get "/party/create" do
    code = generate_rand_string(5)
    users = [getUser()]
    movies = [1,2,3]
    liked = []

    new_party = Party.new(users, movies, liked)
    $partys[code] = new_party
    return code
end
$partys = {}
Party = Struct.new(:users, :movies, :liked)

put "/party/:code/join" do
    user = getUser()
    i = 0
    users = $partys[params[:code]].users
    while i <users.length
        if users[i] == user
            error 422
        end
        i += 1
    end
    
    users.append(user)
    p $partys
    return "success"
end

get "/party/:code/movies" do
    return $partys[params[:code]].movies.join(",")
end

put "/party/:code/like/:id" do
    code = params[:code]
    party = $partys[code]
    id = params[:id].to_i
    party.liked.push(id)
    count = tally(party.liked)

    count.each do |key, value|
        if value >= 2
            return "It's a match: #{key}"
        end
    end
    return "No match"
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