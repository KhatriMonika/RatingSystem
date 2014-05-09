class AddPicUrlToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :pic_url, :string
    add_column :employees, :provider, :string
    add_column :employees, :uid, :string
    add_column :employees, :refresh_token, :string
    add_column :employees, :token_expires_at, :datetime
  end
end
