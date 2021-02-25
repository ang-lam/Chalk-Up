class WorkoutsController < ApplicationController

    get '/log' do
        erb :'workouts/show'
    end

    get '/log/new' do
        #CREATE NEW WORKOUT
        erb :'workouts/new'
    end

    post '/log' do   
    end

    get 'log/:id/' do
        #READ A WORKOUT
    end

    get 'log/:id/edit' do
        #EDIT A WORKOUT
    end

    patch 'log/:id' do
    end

    delete 'log/:id' do
        #DELETE WORKOUT
        #find character
        #@workout.destroy
    end

end