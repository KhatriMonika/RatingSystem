class CreateAccessKeys < ActiveRecord::Migration
  def change
    create_table :access_keys do |t|
      t.string :access_token
      t.integer :employee_id

      t.timestamps
    end
  end
end
