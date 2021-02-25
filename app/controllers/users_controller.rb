class UsersController < ApplicationController

    configure do
        #set :public_folder, "public"
        #set :views, "app/views"
        enable :sessions
        set :session_secret, ENV["SESSION_SECRET"]
    end

    get '/signup' do
        erb :'users/new'
    end

    post '/signup' do
        binding.pry
        user = User.new(params)
        if !!user.username && !!user.email && !!user.password && !User.find_by(email: params["email"]) && User.find_by(username: params["username"])
            #SUCCESS
            user.save 
            session["user_id"] = user.id 
            redirect '/profile/#{user.username}'
        else
            #FAILURE
            redirect '/signup'
        end
    end


    get '/profile/:username' do
        @user = User.find_by(params[:username])
        erb :'users/profile'
    end

    patch '/profile' do
        #patch weight, age, name

    end


    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        user = User.find_by(email: params["email"])
        if user.authenticate(params["password"])
            #successful login
            session["user_id"] = user.id 
            rediret '/home'
        else
            #failed login
            redirect '/login'
        end
    end

    delete '/logout' do
        #add logout form on all relevant pages
    end

    post '/logout' do
        session.clear
        redirect '/login'
    end

end