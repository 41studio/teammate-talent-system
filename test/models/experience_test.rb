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

require 'test_helper'

class ExperienceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
