class AddProjectManagerIdToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :project_manager_id, :integer
  end
end
