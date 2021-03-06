class WorkoutsController < ApplicationController

    get '/log' do
        current_user
        if logged_in?
            all_workouts = Workout.all.find_all {|workout| workout.user_id == session[:user_id]}
            @workouts = all_workouts.sort_by { |workout| workout.date.split(?/).rotate(-1).map { |e| -e.to_i}}
            erb :'workouts/logs'
        else
            redirect to "/login"
        end
        
    end

    get '/log/new' do
        #CREATE NEW WORKOUT
        current_user
        if logged_in?
            erb :'workouts/new'
        else
            redirect to "/login"
        end
    end
    
    get '/log/:id' do
        #READ A WORKOUT
        #if log does not exist redirect to profile page
        #if not current user cannot view
        current_user
        find_log
        if @workout && @workout.user == current_user
            erb :'workouts/show'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    get '/log/:id/edit' do
        #EDIT A WORKOUT
        current_user
        if logged_in?
            find_log
            @exercises = @workout.exercises
            # @exercises = Exercise.all.select {|exercise| exercise.workout_id == @workout.id}
            erb :'workouts/edit'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    post '/log' do 
        #make sure date is acceptable entry?
        #empty sheet cannot be submitted
        @workout = Workout.create(:date => params[:workout][:date], :user_id => session["user_id"])
        @exercises = exercise_names.zip(exercise_weights).reject{ |exercise| exercise.include?("")}
        if !@exercises.empty? && !@workout.date.empty?
            @exercises.each do |exercise|
                @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])      
            end
            redirect to "/log/#{@workout.id}"
        else
            flash[:message] = "Date cannot be empty. You need at least one exercise entered to log the workout."
            redirect to "/log/new"
        end
    end

    patch '/log/:id' do
        if logged_in?
            find_log
            #TEST DELETING EXISTING 1, 2 or 3
            if @workout && @workout.user == current_user
                unless params[:workout][:date].empty?
                    @workout.update(:date => params[:workout][:date])
                end
                #maybe add error message if one box is empty but the other isnt
                names = params[:workout][:exercise][:exists][:name]
                weights = params[:workout][:exercise][:exists][:weight]
                exercises = @workout.exercises.zip(names, weights)
                exercises.each do |exercise|
                    if exercise.include?("")
                        exercise[0].delete
                    #might not need elsif
                    elsif exercise[0].name == nil || exercise[0].weight == nil
                        exercise[0].delete
                    else
                        exercise[0].update(:name => exercise[1], :weight => exercise[2])
                    end
                end

                unless exercise_names.empty? || exercise_weights.empty?
                    @exercises = exercise_names.zip(exercise_weights).reject{ |exercise| exercise.include?("")}
                    @exercises.each do |exercise|
                        @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])
                    end
                end

                redirect to "/log/#{@workout.id}"
            else
                redirect to "/users/#{current_user.slug}"
            end
        else
            redirect to '/login'
        end
    end

    delete '/log/:id' do

        if logged_in?
            find_log
            if @workout && @workout.user == current_user
              @workout.delete
            end
            #redirect to where all user's logs are displayed
            redirect to '/log'
        else
            redirect to '/login'
        end
    end

    private

    def find_log
        @workout = Workout.find_by(:id => params[:id])
    end

    def exercise_names
        # params[:workout][:exercise][:name].reject{ |name| name.empty?}
        params[:workout][:exercise][:name]
    end

    def exercise_weights
        # params[:workout][:exercise][:weight].reject{ |weight| weight.empty?}
        params[:workout][:exercise][:weight]
    end
end