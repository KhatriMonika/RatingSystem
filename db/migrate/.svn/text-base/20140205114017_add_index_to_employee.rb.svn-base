class AddIndexToEmployee < ActiveRecord::Migration
  def change
  	add_index :employees, [:role_id, :team_id]
  	add_index :employees, :team_id
  end
end
