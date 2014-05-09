# == Schema Information
#
# Table name: employees
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  role_id               :integer
#  team_id               :integer
#  technology_id         :integer
#  created_at            :datetime
#  updated_at            :datetime
#  auth_token            :text
#  devise_type           :string(255)      default("ios")
#  devise_token          :string(255)
#  known_technology_id   :string(255)
#  badge                 :integer          default(0)
#  active                :boolean          default(TRUE)
#  joining_date          :date
#  birthdate             :date
#  slug                  :string(255)
#  pic_url               :string(255)
#  provider              :string(255)
#  uid                   :string(255)
#  refresh_token         :string(255)
#  token_expires_at      :datetime
#  event_id_birthdate    :string(255)
#  event_id_joining_date :string(255)
#

class Employee < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  ## Associations ##  
	
  belongs_to :team
	belongs_to :technology
	has_many :ratings
	has_many :access_keys, :dependent => :destroy
  has_one :managed_team, inverse_of: :project_manager, class_name: 'Team', foreign_key: :project_manager_id

  ## Validations ##

  validates :email, :uniqueness =>  true
  validates :name, :presence =>  true
  validates :name, :format => { :with => /\A[a-zA-Z\s]+\z/, :message => "Only letters allowed" }
    
  ## Scopes ##

  #returns employees with role Employee
  scope :developers, -> { where("role_id = ?", Role::ROLES.index("Employee")) }
  #returns employees with technology passed as parameter
  scope :with_technology, ->(technology_id){where("technology_id = ?",technology_id)}
  #returns employees with role Project Manager 
  scope :project_managers, -> { where("role_id = ?", Role::ROLES.index("Project Manager")) }
  #returns employees who does not belong to any team
  scope :unallocated_members, ->{where("team_id IS NULL")}
  #returns employees who cas be assigned as Project manager to new team
  scope :project_managers_and_admin, lambda {where("role_id =? OR role_id = ?",Role::ROLES.index("Project Manager"),Role::ROLES.index("Admin"))}
  #returns employees with role Project Manager and team is allocated
  scope :project_managers_with_team, -> { where("role_id = 0 or role_id = 1").joins(:team) }
  #returns employees except the given ones
  scope :except_employees, -> (employees_to_reject){where("id not in (?)", employees_to_reject)}
  #returns members whom Admin can rate
  scope :admin_members_to_rate, -> (admin_team){where("((role_id = 1 OR team_id = ?) AND role_id != 0) AND active = true",admin_team)} 
  #returns birthdays between given duration
  scope :upcomming_birthdays, -> (start_date,end_date){where("(extract(month from birthdate) BETWEEN ? AND ?) AND (extract(day from birthdate) BETWEEN ? AND ?)", start_date.month, end_date.month, start_date.day, end_date.day)}
  
  scope :active_employee, -> {where("active = true and role_id != 0")}
  scope :project_managers_current_month_rating,-> { project_managers.joins(:ratings).where("extract(month from rating_date) = ?",Date.today.month).pluck(:total_rating) }
  ## Class Methods ##
  def self.from_omniauth(auth)
    @employee = nil
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |employee|       
      employee = self.find_or_create_by(email: auth.info.email)
      employee.provider = auth.provider
      employee.uid = auth.uid
      employee.name = auth.info.name
      employee.email = auth.info.email
      employee.pic_url = process_uri(auth.info.image)
      employee.auth_token = auth.credentials.token
      employee.token_expires_at = Time.at(auth.credentials.expires_at)
      employee.refresh_token = auth.credentials.refresh_token if !employee.refresh_token.present?
      employee.role_id = Role::ROLES.index("Employee") if !employee.role_id.present? 
      employee.save
      employee
      @employee = employee      
    end
    @employee
  end

  def self.process_uri(uri)    
    user_pic_url = URI.parse(uri)
    user_pic_url.scheme = 'https'
    return user_pic_url.to_s

  end

  ## Instance Methods ##

	def role
    if self.role_id.present?
  		Role::ROLES[self.role_id]
    else
      "Unallocated" 
    end
	end

  def tech
    if self.technology.present?
      self.technology.name
    else
      "Unallocated"
    end
  end

  def known_technologies
    if self.known_technology_id.present?
      known_technology_id.split(",")
    end
  end

  #check wether employee's role is Employee or not
  def employee?
    self.role_id  == Role::ROLES.index("Employee")
  end

  #check wether employee's role is Project Manager or not
  def project_manager?
    self.role_id  == Role::ROLES.index("Project Manager")
  end
  
  #check wether employee's role is Admin or not
  def admin?
    self.role_id  == Role::ROLES.index("Admin")
  end

  #returns total employee leaves
  def employee_leaves
    Leave.where(employee_id: self.id)
  end

  #returns pic_url for employee
	def gravatar_url
  	self.pic_url.present? ? self.pic_url : "#{DOMAIN_CONFIG}/assets/default.png"
  end

  #returns team_name of employee
  def team_name
    self.team_id.present? ? self.team.name : "Not Assigned"
  end

  #renews the users' auth_token if it expires 
  def renew_google_auth_token    
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    res = Net::HTTP.post_form(uri, 'client_id' => CLIENT_ID, 'client_secret' => CLIENT_SECRET, 'refresh_token' => self.refresh_token, 'grant_type' => 'refresh_token')
    response = JSON.parse(res.body)
    self.update_attributes(auth_token: response["access_token"], token_expires_at: (Time.now + response["expires_in"]))
  end

  def team_present?
    if (! self.employee? ) && self.team.present?
      self.team.team_members.present? ? true : false
    else
      false
    end
  end

  def team_members_current_month_rating
    self.team.team_members.joins(:ratings).where("extract(month from rating_date) = ?",Date.today.month).pluck(:total_rating) if self.team_present?
  end

  def employee_current_month_rating
    self.ratings.where("extract(month from rating_date) = ?",Date.today.month).pluck(:total_rating)
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def auth_token_expired?
    (self.token_expires_at.to_time - DateTime.now) <= 0
  end

  ## makes the Employee deactive | active 
  def toggle_state
    self.active =  !self.active
    if self.project_manager? 
      self.role_id =  2
      self.team.team_members.update_all(team_id: nil) if self.team.present?
      self.team_id = nil
      self.team.destroy if self.team.present?
    end
    self.team_id = nil
    self.save
  end
end
