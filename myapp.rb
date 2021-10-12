require 'roda'
require 'sequel'
require 'bcrypt'
require 'rack/protection'
require 'pry'

database = $global == :test ? "myapp_test" : "myapp_development"
user = "postgres"
password = "point"
DB = Sequel.connect(adapter: "postgres", database: database, host: "127.0.0.1",
										user: user, password: password)


class Myapp < Roda
	Sequel::Model.plugin :validation_helpers
  Sequel::Model.plugin :timestamps, update_on_create: true

	use Rack::Session::Cookie, secret: "ome_nice_long_random_string_DSKJH4378EYR7EGKUFH", key: "_myapp_session"
	use Rack::Protection
# plugin :csrf

  
	require './models/user.rb'
  require './models/post.rb'

	plugin :static, ["/images", "/css", "/js"]
	plugin :render
	plugin :head
# plugin :json
  plugin :json_parser

	route do |r|
		r.root do
      @posts = Post.reverse_order(:created_at)
      @posts.map do |post|
        {title: post.title, content: post.content}
      end.to_json
		end

    r.post "logout" do
      binding.pry
      session.clear
      binding.pry
    end

# --- Routes to arrange ---
    r.post "login" do
      if user = User.authenticate(r.params['email'], r.params['password'])
        session[:user_id] = user.id
        response.status = 200           # - not nessesery string, can be deleted
        user.to_hash.to_json            # - response user to browser
        binding.pry
      else
        response.status = 401
      end
    end

    r.get /posts\/([0-9]+)/ do |id|
      @post = Post[id]
      @user_name = @post.user.name
    end

    r.on "users" do
# Show all users
      r.is do
        r.get do
          @users = User.order(:id)
          @users.map { |user| [user.name, user.email] }.to_h.to_json
        end

# Create new user
        r.post do
          @user = User.new(r.params["user"])
          if @user.valid? && @user.save
            @user.to_hash.to_json
          else
            response.status = 400
            @user.errors.to_json
          end
        end
      end

      r.on Integer do |id|
        r.is do
          r.get do
            @user = User[id]
            @user.to_hash.to_json
          end
        end
      end
    end

    unless session[:user_id]
    end

    r.on "posts" do
      r.post do
        @post = Post.new(r.params["post"])
        @post.user = User[session[:user_id]]
        if @post.valid? && @post.save
          @post.to_hash.to_json
        else
        end
      end

      r.on Integer do |id|
        @post = Post[id]

        r.post do
          if @post.update(r["post"])
          else
          end
        end
      end
    end
	end
end