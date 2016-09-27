class Schedule < ActiveRecord::Base
	belongs_to :applicant

	validates_presence_of :date, :category
end
