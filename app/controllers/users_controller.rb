class UsersController < ApplicationController
    
    get '/users/:slug' do
        current_user
        erb :'/users/show'
    end

    get '/signup' do
        if !logged_in?
            erb :'users/new'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    get '/login' do
        if !logged_in?
            # flash[:error] = “Please Login”
            erb :'users/login'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    post '/signup' do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect to '/signup'
        elsif User.find_by(:email => params[:email]) || User.find_by(:username => params[:username])
            redirect to '/signup'
        else
            @user = User.new(params)
            @user.save
            session[:user_id] = @user.id
            slug = @user.username.downcase.gsub(" ","-")
            redirect to "/users/#{slug}"
        end
    end

    post '/login' do
        user = User.find_by(:email => params[:email])
        if user && user.authenticate(params[:password])
            #successful login
            session[:user_id] = user.id
            redirect to "/users/#{current_user.slug}"
        else
            #failed login
            redirect '/login'
        end
    end

    delete '/logout' do
        if logged_in?
            session.destroy
            redirect '/login'
        else
            redirect to '/login'
        end
    end
end