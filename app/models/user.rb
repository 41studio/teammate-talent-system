class User < ActiveRecord::Base
	belongs_to :job
		
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :recoverable, :rememberable, :trackable, :confirmable, :confirmable
end
