# == Schema Information
#
# Table name: function_lists
#
#  id       :integer          not null, primary key
#  function :string(255)
#

class FunctionList < ActiveRecord::Base
	belongs_to :job
end
