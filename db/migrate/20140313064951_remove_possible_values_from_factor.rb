class RemovePossibleValuesFromFactor < ActiveRecord::Migration
  def change
    remove_column :factors, :possible_values, :string
  end
end
