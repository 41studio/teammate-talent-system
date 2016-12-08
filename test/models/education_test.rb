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

require 'test_helper'

class EducationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
