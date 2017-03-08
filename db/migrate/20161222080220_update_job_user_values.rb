class UpdateJobUserValues < ActiveRecord::Migration
  def data
    Job.all.each do |job|
      user_id = job.company.users.first.id
      job.update(user_id: user_id)
    end
  end
end
