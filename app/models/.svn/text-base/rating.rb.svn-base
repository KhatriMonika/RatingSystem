# == Schema Information
#
# Table name: ratings
#
#  id                 :integer          not null, primary key
#  rating_date        :date
#  employee_id        :integer
#  remarks            :text
#  created_at         :datetime
#  updated_at         :datetime
#  total_rating       :float            default(0.0)
#  project_manager_id :integer
#

class Rating < ActiveRecord::Base
include SessionsHelper,RatingModule
  ## Associations ##
	belongs_to :employee
	has_many :rating_details
	has_many :factors, :through => :rating_details

  ## Nested Attributes ##
	accepts_nested_attributes_for :rating_details, :allow_destroy => true, :update_only => true

	## Validations ##
	validates :rating_date, presence: true
	validates :employee_id, presence: true
	validates_uniqueness_of :rating_date, :scope => :employee_id

	## Scopes ##
 	scope :rating_date, lambda { |startdate,enddate| where('rating_date  BETWEEN ? AND ? ',Date.parse(startdate),Date.parse(enddate))}
 	scope :with_rating_date, ->(rating_date){where("rating_date = ?",rating_date)}
 	scope :with_rating_details, lambda{ |startdate,enddate,emp_id,f_id| rating_date(startdate,enddate).joins(:rating_details).where("employee_id = ? AND factor_id = ? ",emp_id,f_id) }
 	scope :factor_active_on_date,-> (rating_date){find_by(rating_date: rating_date).factors}
 	scope :list_update_ratings_for_members, -> (members,rating_date){where(employee_id: members, rating_date: rating_date) }	
	scope :employee_with_total_rating,-> (start_date,end_date){ where("(rating_date >= ? and rating_date <= ?) or rating_date is null", start_date, end_date).joins("right outer join employees on employees.id = ratings.employee_id").select("ratings.rating_date as rating_date, total_rating, employees.name as emp_name")}
	scope :employee_with_factor_value,-> (start_date,end_date){ where("(rating_date >= ? and rating_date <= ?) or rating_date is null", start_date, end_date).joins("right outer join rating_details on rating_details.rating_id = ratings.id right outer join employees on employees.id = ratings.employee_id ").select("ratings.rating_date as rating_date, rating_details.rating_value as total_rating, employees.name as emp_name")}
	
	scope :all_employee_current_month_rating,-> { where("extract(month from rating_date) = ?",Date.current.month).pluck(:total_rating) }
  
 	## Instance Methods ##
	def cal_avg_rating(rating)
		total_rating = rating.rating_details.sum(:rating_value)		
	end

	def self.imported_ratings_create(values, user, errors)
		Rating.delay.create!(values) if values.present?
		puts "------done-------"
		SystemMailer.import_ratings_email(user,errors).deliver
	end
	
	def self.csv_import(file,user)
		@errors = []
		@values = []
		ename = file.original_filename.split('.').first
		header = Array.new
		employee = Employee.find_by(name: ename)
		## The employee should be valid | if the user is project manager then employee must be his team member ##
		if (employee.present? && ((user.project_manager? && employee.team_id == user.team_id) || user.admin? ))
			## Finding header from CSV ##
			factors = Hash.new
			CSV.foreach(file.path, headers: true, return_headers: true) do |row|
				header = row.to_hash.keys
				break
			end
			if header.include?("Date") && header.include?("Remarks")
				## Matching Factors with factors present in headers ##
				valid_factors = Factor.where(name: header)
				## Valid_factors count must be same with header's count without Date and Remarks ##
				if valid_factors.count == header.count - 2	
					## creating hash for valid factors fro fast access ##
			    factors = Hash[valid_factors.pluck(:name,:id)]
	    		## creating hash of rating_attributes ##
					CSV.foreach(file.path, headers: true, return_headers: true) do |row|					
						rating_details_attributes = []
						puts "---------------------#{row}"
				    row = row.to_hash
				    puts "---------------------#{row}"
				    ## entry would be skipped if rating is already present || factor has rating value nil or string such as "on leave" ##
			   		next if  (row[factors.keys.first].nil? || (Integer(row[factors.keys.first]) rescue nil).nil? || Rating.find_by(rating_date: row["Date"], employee_id: employee.id).present?)
				    keys = row.keys			    
						valid_factors.each do |k|
				    	rating_details_attributes << {factor_id: factors[k.name], rating_value: row[k.name]}
				    end
				    ## feeding the hash into the @values ##	
				    @values << {rating_date: row["Date"], employee_id: employee.id, project_manager_id: user.id , remarks: row["Remarks"], rating_details_attributes: rating_details_attributes}
					end
				else
						@errors << "Rejected #{file.original_filename}: has Valid Factors #{valid_factors.pluck(:name).join(',')} But #{((header - valid_factors.pluck(:name)) - ["Date", "Remarks"]).join(',')} Did not match. Please check.."
				end
			else
				@errors << "Rejected #{file.original_filename}: Does not have either Date or Remarks or Both in header"
			end
		else
			@errors << "Rejected : Employee named : #{ename} not found/#{ename} Does not belong to your team hence sheet skipped"
		end
		puts @errors
		puts @values
		Rating.delay.imported_ratings_create(@values, user, @errors)
	end

	def self.import(file,user)
		@errors = []
		@values = []		
		if !(file.content_type == "text/csv")		
		  spreadsheet = open_spreadsheet(file)
		  spreadsheet.sheets.each do |sheet|
			  spreadsheet.default_sheet = sheet
				employee = Employee.find_by(name: sheet)
				if (employee.present? && ((user.project_manager? && employee.team_id == user.team_id) || user.admin?))
					if (spreadsheet.row(1).include?("Date") && spreadsheet.row(1).include?("Remarks"))
				  	factors = Hash.new	
				  	header = spreadsheet.row(1)
				    valid_factors = Factor.where(name: header)
				    if valid_factors.count == header.count - 2	
					    factors = Hash[valid_factors.pluck(:name,:id)]
						  (2..spreadsheet.last_row).each do |i|
								rating_details_attributes = []
						    row = Hash[[header, spreadsheet.row(i)].transpose]
						    next if  (row[factors.keys.first].nil? || row[factors.keys.first].class == "String".class || Rating.find_by(rating_date: row["Date"], employee_id: employee.id).present?)
							    keys = row.keys			    
							    valid_factors.each do |k|
						    		rating_details_attributes << {factor_id: factors[k.name], rating_value: row[k.name]}
						    	end		
							    @values << {rating_date: row["Date"], employee_id: employee.id, project_manager_id: user.id , remarks: row["Remarks"], rating_details_attributes: rating_details_attributes}			    
						  end
				  		puts @errors
							puts @values
							Rating.delay.imported_ratings_create(@values, user, @errors)
				    else
						 	valid_factors = Factor.where(name: header).pluck(:name)
						 	@errors << "Rejected Sheet: named: #{sheet} has Valid Factors #{valid_factors.join(',')} But #{(header - valid_factors - ["Date", "Remarks"]).join(',')} Did not match. Please check.."
						end
					else
						@errors << "Rejected Sheet: #{sheet} Does not have either Date or Remarks or Both in header"
					end
			  else
			  	@errors << "Rejected Sheet: Employee named : #{sheet} not found/#{sheet} Does not belong to your team hence sheet skipped"
			  end
			end
		else
			Rating.csv_import(file,user)
		end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
		  when ".csv" then Roo::CSV.new(file.path, {})
		  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
		  when ".xlsx" then  Roo::Excelx.new(file.path, nil, :ignore)
		  else raise "Unknown file type: #{file.original_filename}"
		end
	end

	def self.sent_mail_for_rating_notifications
		## defined in RatingModule
		notification_for_rating
		## send mail to Admin
		if @to_be_notified_to_admin.present?
			details = @rating_details.select { |key, value| @to_be_notified_to_admin.include?(key) }
			#SystemMailer.notification_of_rating_to_admin(details).deliver
			puts "sent mail to shreya@complitech.net "
		end
		## send mail and iPhone Notification to Project Manager
		if @to_be_warned.present?
			@to_be_warned.each do |details|
				puts "needs to warned  #{details.first.name} with #{details.second} --- #{@to_be_warned}"
				#SystemMailer.reminder_to_rate_team_members(details.first,details.second).deliver
				details.first.update_attributes(badge: details.first.badge + 1)
        #APNS.send_notification(details.first.devise_token, :alert => "Reminder for Rating you Last Rated on #{details.second}" , :badge => details.first.badge, :sound => 'default') if details.first.devise_token.present?
			end
		end
	end
end