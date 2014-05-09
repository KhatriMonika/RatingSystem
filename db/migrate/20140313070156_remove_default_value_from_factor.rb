class RemoveDefaultValueFromFactor < ActiveRecord::Migration
  def change
    remove_column :factors, :default_value, :integer
  end
end
