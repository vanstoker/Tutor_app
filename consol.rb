require "sequel"
require "logger"

database = "myapp_development"
user = "postgres"
password = "point"
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1",
										user: user, password: password, loggers: [Logger.new($stdout)])

Sequel::Model.plugin :timestamps, update_on_create: true
require './models/user.rb'
require './models/post.rb'

# Почитать про squel