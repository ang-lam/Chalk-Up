#first we want to wipe out database - will duplicate database
# User.destroy_all
# Workout.destroy_all
Exercise.destroy_all #(wipe db) 
#=> check with Character.all to check it is empty

Exercise.create(name: "bench press", weight: )

#now we create
# num_chars = 30
# num_users = 10
# num_exer = 5

# begin
#     num_users.times do
#         params = {
#             username: Faker::Internet.username,
#             email: Faker::Internet.email,
#             password: Faker::Internet.password,
#             # user_id: rand(1..num_users),
#         }
#         User.create(params)
#     end

#     num_exer.times do 
#         params = {
#             date: 
#         }

#     #console message
#     puts "SEEDED"
# rescue => exception
#     puts "NOT SEEDED"
# end
#run rake db:seed

#go to rake console and check db

#class.all.sample picks one at random