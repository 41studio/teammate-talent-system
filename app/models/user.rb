# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  authentication_token   :string(255)      not null
#  company_id             :integer
#

class User < ActiveRecord::Base
	belongs_to :company	
	has_many :api_keys
  has_many :schedules

  validates :first_name, :last_name, :email, presence: true
  validate :avatar_size_validation

  before_save :ensure_authentication_token
  
  mount_uploader :avatar, AvatarUploader
  
  acts_as_token_authenticatable
  paginates_per 10

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable
  def fullname
    "#{self.first_name} #{self.last_name}"
  end  
  
  def get_schedules
    Schedule.joins(applicant: :job).where(jobs: { company_id: self.company_id, status: "published" } ).order(start_date: :desc)
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def self.authenticate_for_api(email, password)
    if user = self.find_for_authentication(email: email)
      if user.valid_password?(password)
        key = user.api_keys.create
        user.save
        user
      else
        false
      end
    else
      false      
    end
  end

  def avatar_size_validation
    errors[:avatar] << "should be less than 700KB" if avatar.size > 0.7.megabytes
  end
  
  def token
    self.api_keys.nil? ? nil : self.api_keys.last.access_token
  end
  
  private
    scope :by_company_id, -> (company_id) { self.joins(:company).where(companies: {id: company_id}) }

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
