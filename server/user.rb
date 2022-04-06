require "sinatra/base"

User = Struct.new(:id, :username, :password)

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

#Return access token on success
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

get "/me" do
  response["Access-Control-Allow-Origin"] = "http://localhost:5500"
  user = authorize!()
  return user.username
end
