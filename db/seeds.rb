applicant_educations_list = [
	"Unspecified",
	"High School or equivalent",
	"Certification",
	"Vocational",
	"Associate Degree",
	"Bachelor's Degree",
	"Master's Degree",
	"Doctorate",
	"Professional",
	"Some College Coursework Completed",
	"Vocational - HS Diploma",
	"Vocational - Degree",
	"Some High School Coursework"
]

applicant_employment_types_list = [
	"Full-time",
	"Part-time",
	"Contract",
	"Temporary",
	"Other"
]

applicant_experiences_list = [
	"Not applicable",
	"Internship",
	"New graduate",
	"Entry level",
	"Associate",
	"Experienced",
	"Executive",
	"Mid-Senior level",
	"Director C-level"
]

applicant_functions_list = [
	"Accounting/Auditing" ,
	"Administrative" ,
	"Advertising" ,
	"Business Analyst" ,
	"Financial Analyst" ,
	"Data Analyst" ,
	"Art/Creative" ,
	"Business Development" ,
	"Consulting" ,
	"Customer Service" ,
	"Distribution" ,
	"Design" ,
	"Education" ,
	"Engineering" ,
	"Finance" ,
	"General Business" ,
	"Health Care Provider" ,
	"Human Resources" ,
	"Information Technology" ,
	"Legal" ,
	"Management" ,
	"Manufacturing" ,
	"Marketing" ,
	"Other" ,
	"Public Relations" ,
	"Purchasing" ,
	"Product Management" ,
	"Project Management" ,
	"Production" ,
	"Quality Assurance" ,
	"Research" ,
	"Sales" ,
	"Science" ,
	"Strategy/Planning" ,
	"Supply Chain" ,
	"Training" ,
	"Writing/Editing"
]

applicant_industries_list = [
	"Accounting" ,
	"Advertising / Marketing / PR" ,
	"Airlines/Aviation" ,
	"Agricultural / Poultry/ Plantation / Fishery" ,
	"Alternative Dispute Resolution" ,
	"Alternative Medicine" ,
	"Animation" ,
	"Apparel & Fashion" ,
	"Architecture & Planning" ,
	"Architectural Services / Design Service" ,
	"Arts and Crafts" ,
	"Automotive" ,
	"Aviation & Aerospace" ,
	"Banking" ,
	"Biotechnology" ,
	"Broadcast Media" ,
	"Building Materials" ,
	"Business Supplies and Equipment" ,
	"Capital Markets" ,
	"Call Centre / IT Enabled Services" ,
	"Chemicals" ,
	"Civic & Social Organization" ,
	"Civil Engineering" ,
	"Commercial Real Estate" ,
	"Computer & Network Security" ,
	"Computer Games" ,
	"Computer Hardware" ,
	"Computer Networking" ,
	"Computer Software" ,
	"Construction" ,
	"Consumer Electronics" ,
	"Consulting (Business & Management)" ,
	"Consulting (IT ,Science ,Engineering and Technical)" ,
	"Consumer Goods" ,
	"Consumer Services" ,
	"Cosmetics" ,
	"Dairy" ,
	"Defense & Space" ,
	"Design" ,
	"Education Management" ,
	"E-Learning" ,
	"Electrical/Electronic Manufacturing" ,
	"Entertainment" ,
	"Environmental Services" ,
	"Events Services" ,
	"Executive Office" ,
	"Exhibitions / Event Management" ,
	"Facilities Services" ,
	"Farming" ,
	"Financial Services" ,
	"Fine Art" ,
	"Fishery" ,
	"Food & Beverages" ,
	"Food Production" ,
	"Fund-Raising" ,
	"Furniture" ,
	"FMCG" ,
	"Gambling & Casinos" ,
	"Gems / Jewellery" ,
	"Glass , Ceramics & Concrete" ,
	"Government Administration" ,
	"Government Relations" ,
	"Graphic Design" ,
	"Grooming / Beauty / Fitness / Lifestyle" ,
	"Health , Wellness and Fitness" ,
	"Heavy Industrial / Machinery" ,
	"Higher Education" ,
	"Hospital & Health Care" ,
	"Hospitality" ,
	"Human Resources" ,
	"HR Management - Consulting" ,
	"Import and Export" ,
	"Individual & Family Services" ,
	"Industrial Automation" ,
	"Information Services" ,
	"Information Technology and Services" ,
	"Insurance" ,
	"International Affairs" ,
	"International Trade and Development" ,
	"Internet" ,
	"Investment Banking" ,
	"Investment Management" ,
	"Judiciary" ,
	"Journalism" ,
	"Law Enforcement" ,
	"Law Practice" ,
	"Legal Services" ,
	"Legislative Office" ,
	"Leisure ,Travel & Tourism" ,
	"Libraries" ,
	"Logistics and Supply Chain" ,
	"Luxury Goods & Jewelry" ,
	"Machinery" ,
	"Management Consulting" ,
	"Manufacture / Production" ,
	"Maritime" ,
	"Marketing and Advertising" ,
	"Market Research" ,
	"Mechanical or Industrial Engineering" ,
	"Media Production" ,
	"Medical Devices" ,
	"Medical Practice" ,
	"Mental Health Care" ,
	"Military" ,
	"Mining & Metals" ,
	"Motion Pictures and Film" ,
	"Museums and Institutions" ,
	"Music" ,
	"Nanotechnology" ,
	"NGO" ,
	"Newspapers" ,
	"Nonprofit Organization Management" ,
	"Oil & Energy" ,
	"Online Media" ,
	"Outsourcing/Offshoring" ,
	"Package/Freight Delivery" ,
	"Packaging and Containers" ,
	"Paper & Forest Products" ,
	"Performing Arts" ,
	"Pharmaceuticals" ,
	"Philanthropy" ,
	"Photography" ,
	"Plastics" ,
	"Political Organization" ,
	"Primary/Secondary Education" ,
	"Printing" ,
	"Professional Training & Coaching" ,
	"Program Development" ,
	"Public Policy" ,
	"Public Relations and Communications" ,
	"Public Safety" ,
	"Publishing" ,
	"Railroad Manufacture" ,
	"Ranching" ,
	"Real Estate" ,
	"Repair / Maintenance Service" ,
	"Recreational Facilities and Services" ,
	"Religious Institutions" ,
	"Renewables & Environment" ,
	"Research" ,
	"Restaurants" ,
	"Retail" ,
	"Science / Technology" ,
	"Security and Investigations" ,
	"Semiconductors" ,
	"Shipbuilding" ,
	"Sporting Goods" ,
	"Sports" ,
	"Staffing and Recruiting" ,
	"Supermarkets" ,
	"Stock / Securities" ,
	"Telecommunications" ,
	"Textiles" ,
	"Think Tanks" ,
	"Tobacco" ,
	"Translation and Localization" ,
	"Transportation/Trucking/Railroad" ,
	"Utilities" ,
	"Venture Capital & Private Equity" ,
	"Veterinary" ,
	"Warehousing" ,
	"Wholesale" ,
	"Wine and Spirits" ,
	"Wireless" ,
	"Writing and Editing"
]

education_list_has_valid_total_options = EducationList.where(id: 1..applicant_educations_list.count).count == applicant_educations_list.count
employment_types_list_has_valid_total_options = EmploymentTypeList.where(id: 1..applicant_employment_types_list.count).count == applicant_employment_types_list.count
experiences_list_has_valid_total_options = ExperienceList.where(id: 1..applicant_experiences_list.count).count == applicant_experiences_list.count
functions_list_has_valid_total_options = FunctionList.where(id: 1..applicant_functions_list.count).count == applicant_functions_list.count
industries_list_has_valid_total_options = IndustryList.where(id: 1..applicant_industries_list.count).count == applicant_industries_list.count

unless education_list_has_valid_total_options
	applicant_educations_list.each.with_index do |list, index|
		id = index + 1
	  EducationList.find_or_create_by(id: id, education: list)
	end
end

unless employment_types_list_has_valid_total_options
	applicant_employment_types_list.each.with_index do |list, index|
		id = index + 1
	  EmploymentTypeList.find_or_create_by(id: id, employment_type: list)
	end
end

unless experiences_list_has_valid_total_options
	applicant_experiences_list.each.with_index do |list, index|
		id = index + 1
	  ExperienceList.find_or_create_by(id: id, experience: list)
	end
end

unless functions_list_has_valid_total_options
	applicant_functions_list.each.with_index do |list, index|
		id = index + 1
	  FunctionList.find_or_create_by(id: id, function: list)
	end
end

unless industries_list_has_valid_total_options
	applicant_industries_list.each.with_index do |list, index|
		id = index + 1
	  IndustryList.find_or_create_by(id: id, industry: list)
	end
end
