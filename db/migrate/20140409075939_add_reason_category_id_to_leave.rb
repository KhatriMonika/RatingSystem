class AddReasonCategoryIdToLeave < ActiveRecord::Migration
  def change
    add_column :leaves, :leave_reason_category_id, :integer
  end
end
