class AddBadgeToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :badge, :integer
  end
end
