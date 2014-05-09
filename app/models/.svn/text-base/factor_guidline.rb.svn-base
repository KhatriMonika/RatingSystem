# == Schema Information
#
# Table name: factor_guidlines
#
#  id          :integer          not null, primary key
#  description :string(255)
#  value       :integer
#  factor_id   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean          default(TRUE)
#

class FactorGuidline < ActiveRecord::Base
  belongs_to :factor
  validates :description,:value, presence: true
  validates_uniqueness_of :factor_id, :scope => [:description, :value]

  # Maxmimum Total Rating on particular Day
  scope :maxofday, -> { where("active = true").group(:factor_id).maximum(:value).values.sum }
  
  def state_toggle
    self.active == true ? self.active = false : self.active = true
    self.save!
  end
end
