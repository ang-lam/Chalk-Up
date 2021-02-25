class UsersController < ApplicationController
    
    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
    end

    get '/signup' do
        if !logged_in?
            erb :'users/new'
        else
            redirect to '/feed'
        end
    end

    get '/feed' do
        #TESTING FOR LOGOUT WILL DELETE
        erb :'users/list'
    end

    post '/signup' do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect to '/signup'
        elsif User.find_by(:email => params[:email]) || User.find_by(:username => params[:username])
            #USER/EMAIL EXISTS
            redirect to '/signup'
        else
            @user = User.new(params)
            @user.save
            session[:user_id] = @user.id
            slug = @user.username.downcase.gsub(" ","-")
            redirect to "/users/#{slug}"
        end
    end

    get '/login' do
        if !logged_in?
            erb :'users/login'
        else
            slug = current_user.username.downcase.gsub(" ", "-")
            redirect to "/users/#{slug}"
        end
    end

    post '/login' do
        user = User.find_by(:email => params[:email])
        if user && user.authenticate(params[:password])
            #successful login
            session[:user_id] = user.id
            redirect '/feed'
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
            redirect to '/'
        end
    end

    private

    # def find_username
    #     @user = User.find_by_slug(params[:slug])
    # end

end