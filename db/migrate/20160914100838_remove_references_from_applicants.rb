class RemoveReferencesFromApplicants < ActiveRecord::Migration
    def change
        remove_reference(:applicants, :experience, index: true, foreign_key: true)
        remove_reference(:applicants, :education, index: true, foreign_key: true)
    end
end

