require "sinatra/base"
require "jwt"
require "json"
require_relative "user"
require_relative "responses"

$hmac_secret = "secret"

$users = { 0 => User.new(0, "lucas", "secret"), 1 => User.new(1, "annika", "password") }

before "/*" do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  response["Access-Control-Allow-Headers"] = "Authorization"
end

options "*" do
  return 200
end

def addUser(name, pass)
  $users[$users.size] = User.new($users.size, name, pass)
end

def findUserByName(name)
  p $users.values
  $users.values.select { |u| u.username == name }.first
end

def getToken(userId)
  payload = { data: userId }
  JWT.encode payload, $hmac_secret, "HS256"
end

def authorize!
  puts "Time to authorize"

  token = env["HTTP_AUTHORIZATION"]

  unauthorized if token == nil

  puts "token #{token}"

  begin
    decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: "HS256" }
  rescue JWT::DecodeError
    unauthorized_response()
  end

  p decoded_token

  maybeUser = $users[decoded_token[0]["data"]]
  if maybeUser == nil
    unauthorized_response()
  end

  return maybeUser
end
