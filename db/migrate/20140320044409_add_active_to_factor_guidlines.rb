class AddActiveToFactorGuidlines < ActiveRecord::Migration
  def change
    add_column :factor_guidlines, :active, :boolean, :default => true
  end
end
