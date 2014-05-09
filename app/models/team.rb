# == Schema Information
#
# Table name: teams
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  project_manager_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  slug               :string(255)
#

class Team < ActiveRecord::Base
  include ActiveModel::Validations
   extend FriendlyId
  friendly_id :name, use: :slugged
  ## Associations ##

	belongs_to :project_manager, class_name: 'Employee'
  has_many :employees, dependent: :nullify

  ## Scopes ##
	has_many :technologies, :through => :team_members
	has_many :team_members,  -> {  where("employees.role_id = ?", 2)}, class_name: 'Employee', foreign_key: 'team_id'
  has_many :team_members_with_project_manager, class_name: 'Employee', foreign_key: 'team_id'

  ## Validations ##

	has_attached_file :photo,
                  :url  => "#{DOMAIN_CONFIG}/assets/team/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/team/:id/:style/:basename.:extension"               
                  
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  validates :name,:project_manager_id, presence: true
  validates_uniqueness_of :name, :message => "Already taken"
  validates :name, :format => { :with => /\A[a-zA-Z\s]+\z/,
    :message => "Only letters allowed" }

  ## Instance methods ##

  def photo_image
    if self.photo.present?
       self.photo
    else
       "#{DOMAIN_CONFIG}/assets/default_team.jpg"
    end
  end
  	
	def photo_url
	 photo.url(:original)
	end

  def should_generate_new_friendly_id?
    name_changed?
  end
end
