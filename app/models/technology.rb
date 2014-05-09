# == Schema Information
#
# Table name: technologies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Technology < ActiveRecord::Base
  ## Associations ##

  ## Scopes ##
	has_many :teams, :through => :employees
  has_many :employees, dependent: :nullify

  ## Validations ##
	validates :name, presence: true
  validates_uniqueness_of :name, :message => "Already present"
  validates :name, :format => { :with => /\A[a-zA-Z\s]+\z/,
    :message => "Only letters allowed" }
end
