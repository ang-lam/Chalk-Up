class WorkoutsController < ApplicationController

    get '/log' do
        current_user
        if logged_in?
            all_workouts = Workout.all.find_all {|workout| workout.user_id == session[:user_id]}
            @workouts = all_workouts.sort_by { |workout| workout.date}.reverse
            # @workouts = all_workouts.sort_by { |workout| workout.date.split(?/).rotate(-1).map { |e| -e.to_i}}
            erb :'workouts/logs'
        else
            redirect to "/login"
        end  
    end

    get '/log/new' do
        current_user
        if logged_in?
            erb :'workouts/new'
        else
            redirect to "/login"
        end
    end
    
    get '/log/:id' do
        current_user
        find_log
        if @workout && @workout.user == current_user
            erb :'workouts/show'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    get '/log/:id/edit' do
        current_user
        if logged_in?
            find_log
            @exercises = @workout.exercises
            erb :'workouts/edit'
        else
            redirect to "/users/#{current_user.slug}"
        end
    end

    post '/log' do 
        if logged_in?
            if all_integer?
                binding.pry
                @workout = Workout.create(:date => params[:workout][:date], :user_id => session["user_id"])
                workouts_exercises
                if !@exercises.empty? && !@workout.date.empty?
                    create_exercise
                    redirect to "/log/#{@workout.id}"
                else
                    flash[:message] = "Date cannot be empty and at least one exercise must be filled out."
                    redirect to "/log/new"
                end
            else
                flash[:message] = "Weight field only accepts numbers." 
                redirect to "/log/new"
            end
        else
            redirect to "/login"
        end
    end

    patch '/log/:id' do
        if logged_in?
            find_log
            if all_integer?
                if @workout && @workout.user == current_user
                    unless params[:workout][:date].empty?
                        @workout.update(:date => params[:workout][:date])
                    end
                    names = params[:workout][:exercise][:exists][:name]
                    weights = params[:workout][:exercise][:exists][:weight]
                    exercises = @workout.exercises.zip(names, weights)
                    exercises.each do |exercise|
                        if exercise.include?("")
                            exercise[0].destroy
                        else
                            exercise[0].update(:name => exercise[1], :weight => exercise[2])
                        end
                    end

                    unless exercise_names.empty? || exercise_weights.empty?
                        workouts_exercises
                        create_exercise
                    end

                    redirect to "/log/#{@workout.id}"
                else
                    redirect to "/users/#{current_user.slug}"
                end
            else
                flash[:message] = "Weight field only accepts numbers."
                redirect to "/log/#{@workout.id}/edit"
            end
        else
            redirect to '/login'
        end
    end

    delete '/log/:id' do
        if logged_in?
            find_log
            if @workout && @workout.user == current_user
              @workout.destroy
            end
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
        params[:workout][:exercise][:name]
    end

    def exercise_weights
        params[:workout][:exercise][:weight]
    end

    def all_integer?
        weights = exercise_weights.reject{|weight| weight == ""}
        weights.all? {|w| !!(w=~/\A[-+]?[0-9]+\z/) == true}   
    end

    def workouts_exercises
        @exercises = exercise_names.zip(exercise_weights).reject{ |exercise| exercise.include?("")}
    end

    def create_exercise
        @exercises.each do |exercise|
            @workout.exercises << Exercise.create(:workout_id => @workout.id, :name => exercise[0], :weight => exercise[1])      
        end
    end
end