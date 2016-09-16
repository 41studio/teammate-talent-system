class Experience < ActiveRecord::Base
	has_and_belongs_to_many :applicants

	before_destroy {|experience| experience.applicants.clear}
end
