module Api::V1::SessionsHelper
include Google
	def google_login(auth_token)
		@token = auth_token
		@employee_profile = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{auth_token}")))
		if !@employee_profile["error"].present?	  		
			if @employee_profile["hd"] == "complitech.net"
				@employee = Employee.find_or_create_by(email: @employee_profile["email"])
				if @employee.active
					setup_employee					
					@employee.save!
					@employee.access_keys.create!
					@ratings = @employee.ratings.includes({:rating_details => :factor}).where("rating_date >= ?", (Date.today - 30)).order("rating_date")
				    render :file => "/api/v1/employee/show.json.jbuilder"	
				else
					render_json({:errors => "Your account has been Disabled", :status => 404})
				end
			else
				render_json({:errors => "Guest Not allowed", :status => 404})
			end
		else
			render_json({:errors => "Token has expired Please update the Token", :status => 404})
		end
	end

	def setup_employee
		@employee.name = @employee_profile["name"] if !@employee.name.present?
		@employee.provider = "google"
		@employee.pic_url = @employee_profile["picture"]
		@employee.uid = @employee_profile["id"]
		@employee.auth_token = @token
		@employee.role_id = Role::ROLES.index("Employee") if !@employee.role_id.present?
		@employee.devise_token = params[:device_token] if params[:device_token].present?
		@employee.devise_type = params[:device_type] if params[:device_type].present?
		@employee.badge = 0
	end
end