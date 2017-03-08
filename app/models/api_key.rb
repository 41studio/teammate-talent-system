class ApiKey < ActiveRecord::Base  
  # attr_accessible :access_token, :expires_at, :user_id, :active, :application
  before_create :generate_access_token
  before_save :set_expiration
  belongs_to :user

  scope :are_not_expired, -> { where("expires_at > (?)", DateTime.now) }

  def expired?
    DateTime.now >= self.expires_at
  end

  private
    def generate_access_token
      begin
        self.access_token = Devise.friendly_token
      end while self.class.exists?(access_token: access_token)
    end

    def set_expiration
      self.expires_at = DateTime.now + 30.days
    end
end  
