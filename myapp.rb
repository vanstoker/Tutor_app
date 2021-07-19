require "roda"
require "sequel"

database = "myapp_development"
user = ENV["PGUSER"]
password = ENV["PGPASSWORD"]
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1",
										user: user, password: password)

class Myapp < Roda
	plugin :static, ["/images", "/css", "/js"]
	plugin :render
	plugin :head

	route do |r|
		r.root do
			view("homepage")
		end

		r.get "about" do
			view("about")
		end

		r.get "contact" do
			view("contact")
		end
	end
end