# ./Rakefile

#!/usr/bin/env rake
task :app do
  # $global = :test
  require "./myapp"
end
Dir[File.dirname(__FILE__) + "/lib/tasks/*.rb"].sort.each do |path|
  require path
end
