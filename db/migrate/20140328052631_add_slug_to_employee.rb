class AddSlugToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :slug, :string
    add_index :employees, :slug, unique: true
  end
end
