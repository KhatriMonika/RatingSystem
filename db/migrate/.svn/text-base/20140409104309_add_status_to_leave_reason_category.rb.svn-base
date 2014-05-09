class AddStatusToLeaveReasonCategory < ActiveRecord::Migration
  def change
    add_column :leave_reason_categories, :active, :boolean, :default => true
    change_column :leave_reason_categories, :colour, :string, :default => "#ff0000"
  end
end
