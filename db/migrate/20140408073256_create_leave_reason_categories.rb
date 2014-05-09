class CreateLeaveReasonCategories < ActiveRecord::Migration
  def change
    create_table :leave_reason_categories do |t|
      t.string :name
      t.string :colour

      t.timestamps
    end
  end
end
