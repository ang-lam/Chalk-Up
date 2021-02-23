class UsersController < ApplicationController

    configure do
        enable :sessions
        set :session_secret, "secret"
    end
    
    get '/signup' do
        erb :'users/new'
    end

    post '/signup' do
        binding.pry
    end



end