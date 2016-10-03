# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  body         :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  applicant_id :integer
#  user_id      :integer
#

class Comment < ActiveRecord::Base
	has_one :applicant
	validates :body, presence: true

  def get_user_name(id)
    User.select(:email).find_by_id(id)
  end
end
