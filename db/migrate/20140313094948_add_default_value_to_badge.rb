class AddDefaultValueToBadge < ActiveRecord::Migration
  def change
    change_column :employees, :badge, :integer, :default => 0
  end
end
