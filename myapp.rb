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
			# view("homepage")
		end

		r.get "about" do
			# render("about")
      # view("about")
		end

		r.get "contact" do
			# view("contact")
		end

		r.get "login" do
      # view("login")
    end

    r.post "login" do
      if user = User.authenticate(r["email"], r["password"])
        session[:user_id] = user.id
        binding.pry
        response.status = 200
        'ok'
        # r.redirect "/"
      else
        # r.redirect "/login"
      end
    end

    r.post "logout" do
      session.clear
      # r.redirect "/"
    end

    r.get /posts\/([0-9]+)/ do |id|
      @post = Post[id]
      @user_name = @post.user.name
      # view("posts/show")
    end

    r.on "users" do
      r.get "new" do
        @user = User.new
        # view("users/new")
      end

# --- Show all users
      r.is do
        r.get do
          @users = User.order(:id)
          # view("users/index")
          @users.map { |user| [user.name, user.email] }.to_h.to_json
        end

# --- Create new user
        r.post do
          @user = User.new(r.params["user"])
          if @user.valid? && @user.save
            # r.redirect "/users"
            @user.to_hash.to_json
          else
            # view("users/new")
            response.status = 400
            @user.errors.to_json
          end
        end
      end

      r.on Integer do |id|
        r.is do
          r.get do
            @user = User[id]
            # view("users/show")
            @user.to_hash.to_json
          end
        end
      end
    end

    unless session[:user_id]
      # r.redirect "/login"
    end

    r.on "posts" do
      r.get "new" do
        @post = Post.new
        # view("posts/new")
      end

      r.post do
        @post = Post.new(r.params["post"])
        binding.pry
        @post.user = User[session[:user_id]]
        if @post.valid? && @post.save
          # r.redirect "/"
          @post.to_hash.to_json
        else
          # view("posts/new")
        end
      end

      r.on Integer do |id|
        @post = Post[id]
        r.get "edit" do
          # view("posts/edit")
        end
        r.post do
          if @post.update(r["post"])
            # r.redirect "/posts/#{@post.id}"
          else
            # view("posts/edit")
          end
        end
      end
    end
	end
end