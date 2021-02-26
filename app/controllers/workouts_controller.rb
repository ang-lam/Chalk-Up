class WorkoutsController < ApplicationController

    get '/log' do
        erb :'workouts/show'
    end
    get '/log/new' do
        #CREATE NEW WORKOUT
        @workouts = Workout.all
        erb :'workouts/new'
    end
    
    get '/log/:id' do
        #READ A WORKOUT
        @workout = Workout.find_by(:id => params[:id])
        erb :'workouts/show'
    end

    post '/log' do 
        @workout = Workout.create(:date => params[:workout][:date], :user_id => session["user_id"])
        names = params[:workout][:exercise][:name]
        weights = params[:workout][:exercise][:weight]
        @exercises = names.zip(weights)
        @exercises.each do |exercise|
            @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])
        end
        redirect to "/log/#{@workout.id}"
    end

    get '/log/:id/edit' do
        #EDIT A WORKOUT
        @workout = Workout.find_by(:id => params[:id])
        @exercises = Exercise.all.select {|exercise| exercise.workout_id == @workout.id}
        erb :'workouts/edit'
    end

    patch '/log/:id' do
    end

    delete '/log/:id' do
        #DELETE WORKOUT
        #find character
        #@workout.destroy
    end

end