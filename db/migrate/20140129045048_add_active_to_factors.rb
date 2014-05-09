class AddActiveToFactors < ActiveRecord::Migration
  def change
    add_column :factors, :active, :boolean, :default => true
  end
end
