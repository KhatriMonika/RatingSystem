# == Schema Information
#
# Table name: factors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean          default(TRUE)
#  slug       :string(255)
#

class Factor < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  ## Associations ## 
  has_many :rating_details
  has_many :factor_guidlines, class_name: '::FactorGuidline', foreign_key: 'factor_id'#, dependent: :destroy


  ## Nested Attributes ##
  accepts_nested_attributes_for :factor_guidlines, :allow_destroy => true
  validates :name, :presence => true
  validates_uniqueness_of :name, :message => "Already taken"
  validates :name, :format => { :with => /\A[a-zA-Z\s]+\z/,
    :message => "Only letters allowed" }
  validates_associated :factor_guidlines

  ## Scopes ##
  
  ## Returns all Factors that are active ##
  scope :available, -> { where("active = true") }
  
  ## Returns all Factors Guidlines that are active ##
  has_many :active_guidlines,  -> {  where("active = true")}, class_name: 'FactorGuidline', foreign_key: 'factor_id'

  ## Instance Methods ##
  def factor_notification(message)
    project_managers = Employee.project_managers
      project_managers.each do |project_manager|
      #SystemMailer.factors_change_email(project_manager,self).deliver
      if (project_manager.devise_token.present?)
        project_manager.update_attributes(badge: project_manager.badge + 1)
        #APNS.send_notification(project_manager.devise_token, :alert => message , :badge => project_manager.badge, :sound => 'default')
      end
    end

  end

  ## Calculates Average of its possible Values
  def average_possible_value
    sum = 0.0
    pv_arr = self.factor_guidlines.pluck(:value)
    pv_arr.each do |val|
      sum += val.to_i
    end
    sum
  end

  ## Returns the State of The Factor
  def state
    if self.active == true
      "ACTIVE"
    else
      "DEACTIVE"
    end
  end

  ## Inverts the state of factor and its guidelines  
  def toggle_state
    new_state = !self.active
    self.update_attributes(active: new_state)
    self.factor_guidlines.update_all(active: new_state)
    self.factor_notification("Factor #{self.name} and its guidlines are #{self.state}")       
  end  

  ## Returns Maximum value of all Possible Values ##
  def max_value
    self.factor_guidlines.pluck(:value).max.to_i   
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

end
