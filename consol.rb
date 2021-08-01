require "sequel"

database = "myapp_development"
user = "postgres"
password = "point"
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1",
										user: user, password: password)

require './models/user.rb'

# Почитать про sequel
