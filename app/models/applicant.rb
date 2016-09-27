class Applicant < ActiveRecord::Base
	belongs_to :job
	has_and_belongs_to_many :educations
	has_and_belongs_to_many :experiences
	has_many :schedules

	accepts_nested_attributes_for :educations, :experiences

	before_destroy {|applicant| applicant.experiences.clear}
	before_destroy {|applicant| applicant.educations.clear}

	mount_uploader :photo, PhotoUploader
	mount_uploader :resume, ResumeUploader

	validates :name, :gender, :date_birth, :email, :phone, :address, :photo, :resume,  presence: true
	validates :name, length: {in: 2..70}
	validates :gender, inclusion: { in: %w(Male Female), message: "%{value} is not a gender"}
	validates_processing_of :photo
	validate :image_size_validation

	validates_processing_of :resume
	validate :resume_size_validation

	# def self.applicant_stage
	# 	@stages = [["Applied","applied"],["Phone Screen","phonescreen"],["Interview","interview"],["Offer","offer"],["Hired","hired"]]
	# end
	
	def disable_level(id)
		applicant = Applicant.find(id)
		arr = []
		@hashh.each do |key, value|
			if @hashh[applicant.status.to_sym] >= value
				arr << key.to_s
			end
		end
		return arr
	end

	def applicant_recruitment_level
		@hashh = {"applied": 1,"phone_screen": 2,"interview": 3,"offer": 4,"hired": 5}
	end

	private
	  def image_size_validation
	    errors[:photo] << "should be less than 500KB" if photo.size > 0.5.megabytes
	  end

	  def resume_size_validation
	  	errors[:resume] << "should be less than 2MB" if resume.size > 2.megabytes
	  end
end
