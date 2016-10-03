class User < ActiveRecord::Base
	belongs_to :company	
	validates :first_name, :last_name, :email, presence: true
  acts_as_token_authenticatable
  before_save :ensure_authentication_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable         

  def get_schedules
    Schedule.joins(applicant: :job).where(jobs: { company_id: self.company_id, status: "published" } ).order(date: :desc)
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  private
    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
