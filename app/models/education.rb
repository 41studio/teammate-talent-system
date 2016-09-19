class Education < ActiveRecord::Base
	has_and_belongs_to_many :applicants
	
	before_destroy {|education| education.applicants.clear}
end
