# == Schema Information
#
# Table name: leave_reason_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  colour     :string(255)      default("#ff0000")
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean          default(TRUE)
#

class LeaveReasonCategory < ActiveRecord::Base
  validates :name, presence: true
  validates_uniqueness_of :name, :message => "Already present"
  validates :name, :format => { :with => /\A[a-zA-Z\s]+\z/,
    :message => "Only letters allowed" }

  def status
    self.active? ? "Active" : "Deactive"
  end
end
