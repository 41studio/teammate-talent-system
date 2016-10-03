Rails.application.routes.draw do
  resources :companies, except: [:index] do
    resources :jobs do 
      resources :applicants, only: [:new, :create, :show] do
        get '/:phase', to: 'applicants#phase', as: 'phase'
        resources :comments
      end
      get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
    end
    get '/jobs/:id/:status', to: 'jobs#upgrade_status', as:'upgrade_status'
  end
  resources :dashboards, only: [:index]
  # applicant comment
  # post '/applicant/:id/comments/', to: 'comments#create', as: 'applicant_comments'
  # get '/applicant/:id/comments/new', to: 'comments#new', as: 'new_applicant_comments'
  # applicant comment
  # get '/dashboards' => "dashboards#index", as: :user_root
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }

  post '/:job_id/:id/email_to_applicant', to: 'applicants#send_email', as: :email_to_applicant

  resources :schedules, except: [:new, :create]
  get '/applicants/:id/schedules/new' => 'schedules#new', as: 'new_applicant_schedule'
  post '/applicants/:id/schedules/' => 'schedules#create', as: 'applicant_schedules'
  get '/applicants' => "dashboards#applicant", as: 'applicant'
  root 'landing_page#index'

  mount API::Root => '/'
end