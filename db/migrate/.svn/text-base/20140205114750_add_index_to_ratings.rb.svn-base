class AddIndexToRatings < ActiveRecord::Migration
  def change
  	add_index :ratings, [:rating_date, :employee_id] 
  	add_index :ratings, :employee_id
  end
end
