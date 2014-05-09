class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.date :date_of_application
      t.date :date_of_approval
      t.integer :employee_id
      t.string :reporting_to
      t.date :leave_required_from
      t.date :leave_required_to
      t.string :leave_options
      t.boolean :informed_to_client
      t.boolean :informed_to_team_members
      t.string :reason_of_leave
      t.string :note

      t.timestamps
    end
  end
end
