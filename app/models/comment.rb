class Comment < ActiveRecord::Base
	has_one :applicant

  def get_user_name(id)
    User.select(:email).find_by_id(id)
  end
end
