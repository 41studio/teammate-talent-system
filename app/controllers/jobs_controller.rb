class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def experience
  #   @experience = {select_level: "Select level", not_applicable: "Not applicable", internship: "Internship", new_graduate: "New graduate", entry_level: "Entry level", associate: "Associate", experienced: "Experienced", executive: "Executive", mid_senior_level: "Mid-Senior level", director_c_level: "Director C-level"}
  # end

  # def function
  #   @function = {_1: "Select function", _2: "Accounting/Auditing", _3: "Administrative", _4: "Advertising", _5: "Business Analyst", _6: "Financial Analyst", _7: "Data Analyst", _8: "Art/Creative", _9: "Business Development", _10: "Consulting", _11: "Customer Service", _12: "Distribution", _13: "Design", _14: "Education", _15: "Engineering", _16: "Finance", _17: "General Business", _18: "Health Care Provider", _19: "Human Resources", _20: "Information Technology", _21: "Legal", _22: "Management", _23: "Manufacturing", _24: "Marketing", _25: "Other", _26: "Public Relations", _27: "Purchasing", _28: "Product Management", _29: "Project Management", _30: "Production", _31: "Quality Assurance", _32: "Research", _33: "Sales", _34: "Science", _35: "Strategy/Planning", _36: "Supply Chain", _37: "Training", _38: "Writing/Editing"}
  # end

  # def industry
  #   @industry = {_1: "Select industry", _2: "Accounting", _3: "Advertising / Marketing / PR", _4: "Airlines/Aviation", _5: "Agricultural / Poultry/ Plantation / Fishery", _6: "Alternative Dispute Resolution", _7: "Alternative Medicine", _8: "Animation", _9: "Apparel &amp; Fashion", _10: "Architecture &amp; Planning", _11: "Architectural Services / Design Service", _12: "Arts and Crafts", _13: "Automotive", _14: "Aviation &amp; Aerospace", _15: "Banking", _16: "Biotechnology", _17: "Broadcast Media", _18: "Building Materials", _19: "Business Supplies and Equipment", _20: "Capital Markets", _21: "Call Centre / IT Enabled Services", _22: "Chemicals", _23: "Civic &amp; Social Organization", _24: "Civil Engineering", _25: "Commercial Real Estate", _26: "Computer &amp; Network Security", _27: "Computer Games", _28: "Computer Hardware", _29: "Computer Networking", _30: "Computer Software", _31: "Construction", _32: "Consumer Electronics", _33: "Consulting (Business &amp; Management)", _34: "Consulting (IT, Science, Engineering and Technical)", _35: "Consumer Goods", _36: "Consumer Services", _37: "Cosmetics", _38: "Dairy", _39: "Defense &amp; Space", _40: "Design", _41: "Education Management", _42: "E-Learning", _43: "Electrical/Electronic Manufacturing", _44: "Entertainment", _45: "Environmental Services", _46: "Events Services", _47: "Executive Office", _48: "Exhibitions / Event Management", _49: "Facilities Services", _50: "Farming", _51: "Financial Services", _52: "Fine Art", _53: "Fishery", _54: "Food &amp; Beverages", _55: "Food Production", _56: "Fund-Raising", _57: "Furniture", _58: "FMCG", _59: "Gambling &amp; Casinos", _60: "Gems / Jewellery", _61: "Glass, Ceramics &amp; Concrete", _62: "Government Administration", _63: "Government Relations", _64: "Graphic Design", _65: "Grooming / Beauty / Fitness / Lifestyle", _66: "Health, Wellness and Fitness", _67: "Heavy Industrial / Machinery", _68: "Higher Education", _69: "Hospital &amp; Health Care", _70: "Hospitality", _71: "Human Resources", _72: "HR Management - Consulting", _73: "Import and Export", _74: "Individual &amp; Family Services", _75: "Industrial Automation", _76: "Information Services", _77: "Information Technology and Services", _78: "Insurance", _79: "International Affairs", _80: "International Trade and Development", _81: "Internet", _82: "Investment Banking", _83: "Investment Management", _84: "Judiciary", _85: "Journalism", _86: "Law Enforcement", _87: "Law Practice", _88: "Legal Services", _89: "Legislative Office", _90: "Leisure, Travel &amp; Tourism", _91: "Libraries", _92: "Logistics and Supply Chain", _93: "Luxury Goods &amp; Jewelry", _94: "Machinery", _95: "Management Consulting", _96: "Manufacture / Production", _97: "Maritime", _98: "Marketing and Advertising", _99: "Market Research", _100: "Mechanical or Industrial Engineering", _101: "Media Production", _102: "Medical Devices", _103: "Medical Practice", _104: "Mental Health Care", _105: "Military", _106: "Mining &amp; Metals", _107: "Motion Pictures and Film", _108: "Museums and Institutions", _109: "Music", _110: "Nanotechnology", _111: "NGO", _112: "Newspapers", _113: "Nonprofit Organization Management", _114: "Oil &amp; Energy", _115: "Online Media", _116: "Outsourcing/Offshoring", _117: "Package/Freight Delivery", _118: "Packaging and Containers", _119: "Paper &amp; Forest Products", _120: "Performing Arts", _121: "Pharmaceuticals", _122: "Philanthropy", _123: "Photography", _124: "Plastics", _125: "Political Organization", _126: "Primary/Secondary Education", _127: "Printing", _128: "Professional Training &amp; Coaching", _129: "Program Development", _130: "Public Policy", _131: "Public Relations and Communications", _132: "Public Safety", _133: "Publishing", _134: "Railroad Manufacture", _135: "Ranching", _136: "Real Estate", _137: "Repair / Maintenance Service", _138: "Recreational Facilities and Services", _139: "Religious Institutions", _140: "Renewables &amp; Environment", _141: "Research", _142: "Restaurants", _143: "Retail", _144: "Science / Technology", _145: "Security and Investigations", _146: "Semiconductors", _147: "Shipbuilding", _148: "Sporting Goods", _149: "Sports", _150: "Staffing and Recruiting", _151: "Supermarkets", _152: "Stock / Securities", _153: "Telecommunications", _154: "Textiles", _155: "Think Tanks", _156: "Tobacco", _157: "Translation and Localization", _158: "Transportation/Trucking/Railroad", _159: "Utilities", _160: "Venture Capital &amp; Private Equity", _161: "Veterinary", _162: "Warehousing", _163: "Wholesale", _164: "Wine and Spirits", _165: "Wireless", _166: "Writing and Editing"}
  # end

  # def employment_type
  #   @employment_type = {_1: "Select type", _2: "Full-time", _3: "Part-time", _4: "Contract", _5: "Temporary", _6: "Other"}
  # end

  # def education
  #   @education = {_1: "Select level", _2: "Unspecified", _3: "High School or equivalent", _4: "Certification", _5: "Vocational", _6: "Associate Degree", _7: "Bachelor's Degree", _8: "Master's Degree", _9: "Doctorate", _10: "Professional", _11: "Some College Coursework Completed", _12: "Vocational - HS Diploma", _13: "Vocational - Degree", _14: "Some High School Coursework"}
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:job_title, :departement, :job_code, :country, :state, :city, :zip_code, :min_salary, :max_salary, :curency, :job_description, :job_requirement, :benefits, :aplicant_experience, :aplicant_function, :aplicant_employment_type, :aplicant_industry, :aplicant_education, :job_search_keyword)
    end
end
