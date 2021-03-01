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
        find_log
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
        find_log
        @exercises = @workout.exercises
        # @exercises = Exercise.all.select {|exercise| exercise.workout_id == @workout.id}
        erb :'workouts/edit'
    end

    patch '/log/:id' do
        if logged_in?
            find_log
            if @workout && @workout.user == current_user
                unless params[:workout][:date].empty?
                    @workout.update(:date => params[:workout][:date])
                end

                @workout.exercises.clear
                @exercises = exercise_names.zip(exercise_weights)
                @exercises.each do |exercise|
                    @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])
                end
            
                # unless params[:exercise][:name].empty? && params[:exercise][:name].empty?
                #     names = params[:workout][:exercise][:name].reject {|exercise| exercise.empty?}
                #     weights = params[:workout][:exercise][:weight].reject {|weight| weight.empty?}
                #     @exercises = names.zip(weights)
                #     @exercises.each do |exercise|
                #         @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])
                #     end
                # end
                redirect to "/log/#{@workout.id}"
            else
                redirect to '/'
            end
        else
            redirect to '/login'
        end

    end

    delete '/log/:id' do
        #DELETE WORKOUT
        #find character
        #@workout.destroy
        #@workout.clear
    end

    private

    def find_log
        @workout = Workout.find_by(:id => params[:id])
    end

    def exercise_names
        params[:workout][:exercise][:name].reject{ |name| name.empty?}
    end

    def exercise_weights
        params[:workout][:exercise][:weight].reject{ |weight| weight.empty?}
    end
end