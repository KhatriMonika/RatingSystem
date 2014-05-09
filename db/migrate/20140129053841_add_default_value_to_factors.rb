class AddDefaultValueToFactors < ActiveRecord::Migration
  def change
    add_column :factors, :default_value, :integer
  end
end
