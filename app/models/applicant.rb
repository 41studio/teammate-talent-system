class Applicant < ActiveRecord::Base

has_many :experiences
has_many :educations
belongs_to :job

mount_uploader :photo, PhotoUploader
mount_uploader :resume, ResumeUploader

validates :name, :gender, :date_birth, :email, :phone, :address, :photo, :resume,  presence: true

validates_processing_of :photo
validate :image_size_validation

validates_processing_of :resume
validate :resume_size_validation
 
private
  def image_size_validation
    errors[:photo] << "should be less than 500KB" if photo.size > 0.5.megabytes
  end

  def resume_size_validation
  	errors[:resume] << "should be less than 2MB" if resume.size > 2.megabytes
  end
end
