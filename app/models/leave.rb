# == Schema Information
#
# Table name: leaves
#
#  id                       :integer          not null, primary key
#  date_of_application      :date
#  date_of_approval         :date
#  employee_id              :integer
#  leave_required_from      :date
#  leave_required_to        :date
#  leave_options            :string(255)
#  informed_to_client       :boolean
#  reason_of_leave          :string(255)
#  note                     :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  status                   :integer          default(4)
#  leave_reason_category_id :integer
#  google_leave_id          :string(255)
#

class Leave < ActiveRecord::Base

  ## Associations ##
  belongs_to :employee
  belongs_to :leave_reason_category

  ## Validations ##
  validates :reason_of_leave,:employee_id, :leave_required_from,:leave_required_to,:leave_options,:leave_reason_category_id,:status, :presence => true
  validate :date_validation
  ## Scopes ##
  scope :upcoming_leaves, -> { where("leave_required_from >= ?", Date.today) }
  scope :leaves_on_date, lambda { |date| where("(?) BETWEEN leave_required_from AND leave_required_to AND status = 0",date)}
  scope :leave_date, lambda { |startdate,enddate| where('date_of_application  BETWEEN ? AND ? ',startdate,enddate)}
  scope :leave_status_not, lambda { |status| where('status != ?',Leave::STATUS.index(status))}
  scope :leave_status, lambda { |status| where(status: status)}
  scope :leaves_of_reason_category, lambda { |category| where(leave_reason_category_id: category)}
  scope :selected_employee_leaves, lambda { |employees| where(employee_id: employees)}
  scope :new_leaves_count, -> { where(date_of_approval: nil).count}
  scope :leaves_on_dates, lambda { |startdate,enddate| where('leave_required_from  BETWEEN ? AND ? OR leave_required_to BETWEEN ? AND ? ',startdate,enddate,startdate,enddate) }

  STATUS = ["Sanctioned", "Not Sanctioned", "Cancled", "Reviewed", "Not Reviewed","Draft"]

  OPTIONS = ["Full Day", "1st half","2nd half"]


  ## Instance Methods ##
  def status_name
    Leave::STATUS[self.status]
  end

  def option
    if self.leave_options.present?
      options = Hash.new
      options_array = self.leave_options.split(",")
      startDate = self.leave_required_from
      endDate = self.leave_required_to
      i = 0
      while endDate >= startDate do
        if !(startDate.sunday?)
          options[startDate.to_s] = options_array[i]
          i = i + 1
        end
        startDate = startDate + 1
      end
      return options
    end
  end

  def sanctioned?
    self.status == Leave::STATUS.index("Sanctioned")
  end

  def not_sanctioned?
    self.status == Leave::STATUS.index("Not Sanctioned")
  end

  def canceled?
    self.status == Leave::STATUS.index("Cancled")
  end

  def reviewed?
    self.status == Leave::STATUS.index("Reviewed")
  end

  def not_reviewed?
    self.status == Leave::STATUS.index("Not Reviewed")
  end

  def draft?
    self.status == Leave::STATUS.index("Draft")
  end

  def past_leave?
    self.leave_required_to < Date.today && self.leave_required_from < Date.today && self.status != Leave::STATUS.index("Draft")
  end

  def number_of_days(from,to)
    ((to - from) + 1).to_i
  end

  def date_validation
    list = Leave.leaves_on_dates(self.leave_required_from,self.leave_required_to).where(employee_id: self.employee_id)
    if list.present?
      if !(list.length == 1 && list.first.id == self.id)
        errors.add(:leave_required_from, 'You have already apply for leave for any of these date')
      end
    end
  end
end
