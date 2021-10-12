$global = :test
require 'rack/test'
require 'database_cleaner/sequel'
require File.expand_path("../../myapp", __FILE__)
require 'factory_bot'
require File.expand_path("../../spec/factories/user", __FILE__)
require File.expand_path("../../spec/factories/post", __FILE__)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w[spatial_ref_sys])
  end
end

def app
  builder = Rack::Builder.new
  builder.run Myapp.app
end