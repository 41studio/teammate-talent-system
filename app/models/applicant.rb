# == Schema Information
#
# Table name: applicants
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  gender     :string(255)      default(""), not null
#  date_birth :date             not null
#  email      :string(255)      default(""), not null
#  headline   :string(255)      default(""), not null
#  phone      :string(255)      default(""), not null
#  address    :string(255)      default(""), not null
#  photo      :string(255)      default(""), not null
#  resume     :string(255)      default(""), not null
#  status     :string(255)      default("Applied"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :integer
#

class Applicant < ActiveRecord::Base
	alias_attribute :applicant_status, :status
	acts_as_commentable
	belongs_to :job
	has_and_belongs_to_many :educations
	has_and_belongs_to_many :experiences
	has_many :schedules, dependent: :destroy
	has_many :comments

	accepts_nested_attributes_for :educations, :experiences

	before_destroy {|applicant| applicant.experiences.clear}
	before_destroy {|applicant| applicant.educations.clear}

	mount_uploader :photo, PhotoUploader
	mount_uploader :resume, ResumeUploader

	validates :name, :gender, :date_birth, :email, :phone, :address, :photo, :resume,  presence: true
	validates :name, length: {in: 2..70}
	# validates :gender, inclusion: { in: %w(Male Female), message: "%{value} is not a gender"}
	validates :phone, numericality: true
	validate :applicant_statuses
	validates_processing_of :photo
	validate :image_size_validation

	validates_processing_of :resume
	validate :resume_size_validation

	# def self.applicant_stage
	# 	@stages = [["Applied","applied"],["Phone Screen","phonescreen"],["Interview","interview"],["Offer","offer"],["Hired","hired"]]
	# end
	
	STATUSES = {"applied": 1,"phone_screen": 2,"interview": 3,"offer": 4,"hired": 5}

	def disable_level
		STATUSES.select{|key, value| STATUSES[self.status.to_sym] >= value}.keys
	end

	private
		def applicant_statuses
			unless STATUSES.has_key? self.status.to_sym
				errors[:status] << "not available" 
				return false
			else
				return true
			end
		end

	  def image_size_validation
	    errors[:photo] << "should be less than 500KB" if photo.size > 0.5.megabytes
	  end

	  def resume_size_validation
	  	errors[:resume] << "should be less than 2MB" if resume.size > 2.megabytes
	  end
end
