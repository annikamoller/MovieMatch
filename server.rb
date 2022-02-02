require 'sinatra'

$users = {"annika" => "password", "lucas" => "secret"}

def getUser()
    token = params[:token]
    if !$tokens.key?(token)
        error 401
    end
    return $tokens[token]
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

movies = {1 => "Harry Potter och fången från Azkaban", 2 => "Spiderman no way home", 3 => "Shrek 3"}

get "/movie" do
    token = params[:token]
    if !$tokens.key?(token)
        error 401
    end
    return movies[rand(1..movies.length)]
end

get "/movie/:id" do
    return movies[params[:id].to_i]
end

rating = {1 => "4.5/5", 2 => "4/5", 3 => "5/5"}

get "/movie/:id/rating" do
    return rating[params[:id].to_i]
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

put "/party/join/:code" do
    user = getUser()
    $partys[params[:code]].users.append(user)
    p $partys
    return "success"
end

get "/party/:code/movies" do
    return $partys[params[:code]].movies.join()
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