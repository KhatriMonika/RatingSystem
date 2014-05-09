# == Schema Information
#
# Table name: rating_details
#
#  id           :integer          not null, primary key
#  rating_id    :integer
#  rating_value :integer
#  factor_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class RatingDetail < ActiveRecord::Base

  ## Associations ##

	belongs_to :rating
	belongs_to :factor

  ## Validations ##
	validates :factor_id, :rating_value, presence: true
	validates_uniqueness_of :rating_id, :scope => :factor_id

  ## Scopes ##
	scope :with_factor, ->(factor_id){where("factor_id = ?",factor_id)}
  after_create :update_total_rating
  after_update :update_total_rating
  
  def update_total_rating
    rating = Rating.find(self.rating_id)
    rating.update_attributes(total_rating: rating.rating_details.sum(:rating_value))
  end
end
