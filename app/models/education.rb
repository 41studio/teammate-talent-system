# == Schema Information
#
# Table name: educations
#
#  id          :integer          not null, primary key
#  name_school :string(255)
#  field_study :string(255)
#  degree      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Education < ActiveRecord::Base
	has_and_belongs_to_many :applicants
	
	before_destroy {|education| education.applicants.clear}
end
