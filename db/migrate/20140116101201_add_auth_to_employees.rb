class AddAuthToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :auth_token, :text
  end
end
