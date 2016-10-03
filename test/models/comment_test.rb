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

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
