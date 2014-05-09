namespace :initial do
  desc "Run all Rake Task"
  task :setup => :environment do
    puts "-----------Drop Database............"
    `RAILS_ENV=production rake db:drop`
    puts "-----------Completed----------------"
    puts "-----------Create Database.........."
    `RAILS_ENV=production rake db:create`
    puts "-----------Completed----------------"        
    puts "-----------Migrating Database......."
    `RAILS_ENV=production rake db:migrate`
    puts "-----------Completed----------------"
    puts "........Populating Database........."
    `RAILS_ENV=production rake db:populate`
    `RAILS_ENV=production rake db:seed`
    puts "-----------Completed----------------"     
    puts "........Precompiling Assets........."
    `RAILS_ENV=production rake assets:precompile`
    puts "-----------Completed----------------"    
  end
end