class RemoveTitleFromWorkouts < ActiveRecord::Migration[5.2]
  def change
    remove_column :workouts, :title
  end
end
