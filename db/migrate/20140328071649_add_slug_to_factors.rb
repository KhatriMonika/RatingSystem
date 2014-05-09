class AddSlugToFactors < ActiveRecord::Migration
  def change
    add_column :factors, :slug, :string
  end
end
