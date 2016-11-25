class ApplicantPushNotification
  PATH = 'applicants'
  BASE_URI = 'https://teamhire-ee5d5.firebaseio.com/'

  def initialize(applicant)
    @applicant = applicant
    @firebase = Firebase::Client.new(BASE_URI)
    @data = {}
    @users = @applicant.job_company.users
    @responses = []
  end

  def set_notice(notice)
    @data[:notice] = notice
  end

  def push!
    @users.each do |user|
      user.api_keys.are_not_expired.pluck(:firebase_access_token).uniq.each do |token|
        @data[:created_at] = Firebase::ServerValue::TIMESTAMP 
        @firebase.secret_key = token
        @responses << @firebase.push(PATH, @data)
      end
    end

    @responses
  end
end
