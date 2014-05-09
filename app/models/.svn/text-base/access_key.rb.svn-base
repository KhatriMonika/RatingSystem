# == Schema Information
#
# Table name: access_keys
#
#  id           :integer          not null, primary key
#  access_token :string(255)
#  employee_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class AccessKey < ActiveRecord::Base
  
  ## Associations ## 
	belongs_to :employee

  ## Before Filters ##
	before_create :generate_access_token

  ## Private Methods ##
	private
  
  ## Generates Access Token after login ##
	def generate_access_token
		begin
			self.access_token = SecureRandom.hex
		end while self.class.exists?(access_token: access_token)
	end
end
