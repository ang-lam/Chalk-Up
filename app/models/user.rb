class User < ActiveRecord::Base
    has_many :workouts
    
    validates_presence_of :name, :email, :password
    has_secure_password
end