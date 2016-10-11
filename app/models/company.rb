# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  company_name    :string(255)
#  company_website :string(255)
#  company_email   :string(255)
#  company_phone   :string(255)
#  industry        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  photo_company   :string(255)
#

class Company < ActiveRecord::Base
	has_many :jobs, dependent: :destroy
	has_many :users
	
	mount_uploader :photo_company, PhotoCompanyUploader
	
	validates :company_name, :company_website, :company_email, :company_phone, :industry, :photo_company, presence: true
	validates :company_name, length: { minimum: 2 }
	validates :company_phone, numericality: true
  	validates_processing_of :photo_company
	validate :image_size_validation
 
	def self.industry
		@industry = {_1: "Select industry", _2: "Accounting", _3: "Advertising / Marketing / PR", _4: "Airlines/Aviation", _5: "Agricultural / Poultry/ Plantation / Fishery", _6: "Alternative Dispute Resolution", _7: "Alternative Medicine", _8: "Animation", _9: "Apparel &amp; Fashion", _10: "Architecture &amp; Planning", _11: "Architectural Services / Design Service", _12: "Arts and Crafts", _13: "Automotive", _14: "Aviation &amp; Aerospace", _15: "Banking", _16: "Biotechnology", _17: "Broadcast Media", _18: "Building Materials", _19: "Business Supplies and Equipment", _20: "Capital Markets", _21: "Call Centre / IT Enabled Services", _22: "Chemicals", _23: "Civic &amp; Social Organization", _24: "Civil Engineering", _25: "Commercial Real Estate", _26: "Computer &amp; Network Security", _27: "Computer Games", _28: "Computer Hardware", _29: "Computer Networking", _30: "Computer Software", _31: "Construction", _32: "Consumer Electronics", _33: "Consulting (Business &amp; Management)", _34: "Consulting (IT, Science, Engineering and Technical)", _35: "Consumer Goods", _36: "Consumer Services", _37: "Cosmetics", _38: "Dairy", _39: "Defense &amp; Space", _40: "Design", _41: "Education Management", _42: "E-Learning", _43: "Electrical/Electronic Manufacturing", _44: "Entertainment", _45: "Environmental Services", _46: "Events Services", _47: "Executive Office", _48: "Exhibitions / Event Management", _49: "Facilities Services", _50: "Farming", _51: "Financial Services", _52: "Fine Art", _53: "Fishery", _54: "Food &amp; Beverages", _55: "Food Production", _56: "Fund-Raising", _57: "Furniture", _58: "FMCG", _59: "Gambling &amp; Casinos", _60: "Gems / Jewellery", _61: "Glass, Ceramics &amp; Concrete", _62: "Government Administration", _63: "Government Relations", _64: "Graphic Design", _65: "Grooming / Beauty / Fitness / Lifestyle", _66: "Health, Wellness and Fitness", _67: "Heavy Industrial / Machinery", _68: "Higher Education", _69: "Hospital &amp; Health Care", _70: "Hospitality", _71: "Human Resources", _72: "HR Management - Consulting", _73: "Import and Export", _74: "Individual &amp; Family Services", _75: "Industrial Automation", _76: "Information Services", _77: "Information Technology and Services", _78: "Insurance", _79: "International Affairs", _80: "International Trade and Development", _81: "Internet", _82: "Investment Banking", _83: "Investment Management", _84: "Judiciary", _85: "Journalism", _86: "Law Enforcement", _87: "Law Practice", _88: "Legal Services", _89: "Legislative Office", _90: "Leisure, Travel &amp; Tourism", _91: "Libraries", _92: "Logistics and Supply Chain", _93: "Luxury Goods &amp; Jewelry", _94: "Machinery", _95: "Management Consulting", _96: "Manufacture / Production", _97: "Maritime", _98: "Marketing and Advertising", _99: "Market Research", _100: "Mechanical or Industrial Engineering", _101: "Media Production", _102: "Medical Devices", _103: "Medical Practice", _104: "Mental Health Care", _105: "Military", _106: "Mining &amp; Metals", _107: "Motion Pictures and Film", _108: "Museums and Institutions", _109: "Music", _110: "Nanotechnology", _111: "NGO", _112: "Newspapers", _113: "Nonprofit Organization Management", _114: "Oil &amp; Energy", _115: "Online Media", _116: "Outsourcing/Offshoring", _117: "Package/Freight Delivery", _118: "Packaging and Containers", _119: "Paper &amp; Forest Products", _120: "Performing Arts", _121: "Pharmaceuticals", _122: "Philanthropy", _123: "Photography", _124: "Plastics", _125: "Political Organization", _126: "Primary/Secondary Education", _127: "Printing", _128: "Professional Training &amp; Coaching", _129: "Program Development", _130: "Public Policy", _131: "Public Relations and Communications", _132: "Public Safety", _133: "Publishing", _134: "Railroad Manufacture", _135: "Ranching", _136: "Real Estate", _137: "Repair / Maintenance Service", _138: "Recreational Facilities and Services", _139: "Religious Institutions", _140: "Renewables &amp; Environment", _141: "Research", _142: "Restaurants", _143: "Retail", _144: "Science / Technology", _145: "Security and Investigations", _146: "Semiconductors", _147: "Shipbuilding", _148: "Sporting Goods", _149: "Sports", _150: "Staffing and Recruiting", _151: "Supermarkets", _152: "Stock / Securities", _153: "Telecommunications", _154: "Textiles", _155: "Think Tanks", _156: "Tobacco", _157: "Translation and Localization", _158: "Transportation/Trucking/Railroad", _159: "Utilities", _160: "Venture Capital &amp; Private Equity", _161: "Veterinary", _162: "Warehousing", _163: "Wholesale", _164: "Wine and Spirits", _165: "Wireless", _166: "Writing and Editing"}
	end

	def applicant_schedule
		applicant_schedules = {}
		jobs = {}
		applicants = {}
		schedules = {}

		self.jobs.each do |job|
			jobs["job#{job.id}".to_s] = job.job_title
			applicant_schedules[:jobs] = jobs
			job.applicants.each do |applicant|
				applicants["applicant#{applicant.id}".to_s] = applicant.name
				applicant_schedules[:applicants] = applicants
				applicant.schedules.each do |schedule|
					schedules["schedule#{schedule.id}".to_s] = "#{schedule.start_date.to_date} at #{schedule.start_date.strftime("%I:%M%p")}" 
				end
			end
			applicant_schedules[:schedules] = schedules
		end

		applicant_schedules
		# applicant_schedule = {job: job, {applicant: current_user, schedules: [current_user.company.jobs]}
	end

private
  def image_size_validation
    errors[:photo_company] << "should be less than 1.2MB" if photo_company.size > 1.2.megabytes
  end
end
