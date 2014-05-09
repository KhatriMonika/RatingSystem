class AddAttachmentPhotoToTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :teams, :photo
  end
end
