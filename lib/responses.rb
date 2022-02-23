require "sinatra"
require "json"

def success_response(msg = "Success")
  payload = { :err => "", :data => msg }
  halt 200, payload.to_json
end

def created_response(msg = "Created")
  payload = { :err => "", :data => msg }
  halt 201, payload.to_json
end

def unauthorized_response(msg = "http://localhost:5500/login.html")
  payload = { :err => "Unauthorized", :data => msg }
  error(403, payload.to_json)
end
