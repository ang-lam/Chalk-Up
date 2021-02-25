#first we want to wipe out database - will duplicate database
Character.destroy_all #(wipe db) 
#=> check with Character.all to check it is empty

#now we create
num_chars = 30
num_users = 10

begin
num_chars.times do
    params = {
        name: Faker::Name.name,
        weapon: Faker::Games::ElderScrolls.dragon
        user_id: rand(1..num_users),
    }
    Character.create(params)
end

#console message
puts "SEEDED"
rescue => exception
    puts "not seeded"
end
#run rake db:seed

#go to rake console and check db

#class.all.sample picks one at random