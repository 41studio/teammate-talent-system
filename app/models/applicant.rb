class Applicant < ActiveRecord::Base

has_many :experiences
has_many :educations

mount_uploader :photo, PhotoUploader
mount_uploader :resume, ResumeUploader

validates_processing_of :photo
validate :image_size_validation
 
private
  def image_size_validation
    errors[:photo] << "should be less than 500KB" if photo.size > 0.5.megabytes
  end
end
