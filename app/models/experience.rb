# == Schema Information
#
# Table name: experiences
#
#  id           :integer          not null, primary key
#  name_company :string(255)
#  industry     :string(255)
#  title        :string(255)
#  summary      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Experience < ActiveRecord::Base
	has_and_belongs_to_many :applicants

	before_destroy {|experience| experience.applicants.clear}
end
