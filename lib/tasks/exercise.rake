namespace :db do
	desc "Load seed fixtures (from db/fixtures) into the current environment's database."
	task :load_data => :environment do
    require 'active_record/fixtures'
    Dir.glob(Rails.root.to_s + '/db/fixtures/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
	end

	desc "TODO"
	task :generate_delta_index => :environment do
	end
end

#rake test_hello['how are you recently?']
#rake test_hello
desc "Testing args"
task :test_hello,[:message] do |t, args|
  args.with_defaults(:message => "Thanks for logging in")
  puts "Hello victoria. #{args.message}"
end

#rake add NUM1=111 NUM2=222
task :add=> :environment do
  puts ENV['NUM1'].to_i + ENV['NUM2'].to_i
end

#rake my_example:product 5 8
namespace :my_example do
	desc "Something"
	task :product => :environment do
	  ARGV.each { |a| task a.to_sym do ; end }
    puts ARGV[1].to_i * ARGV[2].to_i
	end
end

#rails rake environment arguments

namespace :nginx do
	desc "Setup nginx configuration for development env"
	task :setup => :environment do
		system "sudo cp #{Rails.root.to_s}/config/nginx_develop.cnf /etc/nginx/sites-enabled/exercise"
	end
end



