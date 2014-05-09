namespace :db do
  desc "fill in Database"
  task :populate => :environment do
    ##  Technology ##

    ##  Factors ##
    
    ## Employee ##
    Employee.create!(name: "Nikhil", email: "admin@complitech.net", role_id: 0) if !(Employee.find_by(email: "admin@complitech.net").present?)
    Employee.create!(name: "Monika", email: "monika@complitech.net", role_id: 2) if !(Employee.find_by(email: "monika@complitech.net").present?)
    Employee.create!(name: "Renuka", email: "renuka@complitech.net") if !(Employee.find_by(email: "renuka@complitech.net").present?)
    Employee.create!(name: "Mahesh", email: "mahesh@complitech.net") if !(Employee.find_by(email: "mahesh@complitech.net").present?)
    Employee.create!(name: "Ashwin", email: "ashwin@complitech.net" ) if !(Employee.find_by(email: "ashwin@complitech.net").present?)
    Employee.create!(name: "Kirti",  email: "kirti@complitech.net", role_id: 1) if !(Employee.find_by(email: "kirti@complitech.net").present?)
    Employee.create!(name: "Vishal", email: "vishal@complitech.net", role_id: 2) if !(Employee.find_by(email: "vishal@complitech.net").present?)
    Employee.create!(name: "Shreya", email: "shreya@complitech.net", role_id: 0) if !(Employee.find_by(email: "shreya@complitech.net").present?)
    Employee.create!(name: "Ankita", email: "ankita@complitech.net", role_id: 0) if !(Employee.find_by(email: "ankita@complitech.net").present?)
    Employee.create!(name: "Pinak",  email: "pinak@complitech.net", role_id: 2) if !(Employee.find_by(email: "pinak@complitech.net").present?)
    Employee.create!(name: "Dipak",  email: "dipak@complitech.net", role_id: 2) if !(Employee.find_by(email: "dipak@complitech.net").present?)
    Employee.create!(name: "Komal",  email: "komal@complitech.net", role_id: 2) if !(Employee.find_by(email: "komal@complitech.net").present?)
    Employee.create!(name: "Manan",  email: "manan@complitech.net", role_id: 2) if !(Employee.find_by(email: "manan@complitech.net").present?)
    Employee.create!(name: "Priya",  email: "priya@complitech.net", role_id: 2) if !(Employee.find_by(email: "priya@complitech.net").present?)
    Employee.create!(name: "Ronak",  email: "ronak@complitech.net", role_id: 2) if !(Employee.find_by(email: "ronak@complitech.net").present?)
    Employee.create!(name: "Jayesh", email: "jayesh@complitech.net", role_id: 2) if !(Employee.find_by(email: "jayesh@complitech.net").present?)
    Employee.create!(name: "Megha",  email: "megha@complitech.net", role_id: 2) if !(Employee.find_by(email: "megha@complitech.net").present?)
    Employee.create!(name: "Keval",  email: "keval@complitech.net", role_id: 2) if !(Employee.find_by(email: "keval@complitech.net").present?)
    Employee.create!(name: "Deep",   email: "deep@complitech.net", role_id: 2) if !(Employee.find_by(email: "deep@complitech.net").present?)
    Employee.create!(name: "Dipak Baraiya", email: "dipak.baraiya@complitech.net", role_id: 2) if !(Employee.find_by(email: "dipak.baraiya@complitech.net").present?)
    Employee.create!(name: "Chhaya", email: "chhaya@complitech.net", role_id: 2) if !(Employee.find_by(email: "chhaya@complitech.net").present?)
    Employee.create!(name: "Bhavin", email: "bhavin@complitech.net", role_id: 2 ) if !(Employee.find_by(email: "bhavin@complitech.net").present?)
    Employee.create!(name: "Manan Mistry", email: "manan.mistry@complitech.net", role_id: 2 ) if !(Employee.find_by(email: "manan.mistry@complitech.net").present?)

  end

end