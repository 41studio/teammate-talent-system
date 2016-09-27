desc 'send_email_reminder_schedule'

task send_email_reminder_schedule: :environment do

	SendMail.sample_email(@applicant.email).deliver

end