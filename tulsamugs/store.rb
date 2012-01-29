require_relative 'couch.rb'
require_relative 'person.rb'

SERVER = "localhost"
PORT = "5984"

def couch_store(key, json)
  server = Couch::Server.new(SERVER, PORT)
  server.put("/tulsamugs/#{key}", json)
end
