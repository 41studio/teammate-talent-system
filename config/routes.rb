Rails.application.routes.draw do
  resources :companies do
    resources :jobs, only: [:new, :create, :edit, :update]
  end
  resources :jobs, only: [:show, :destroy, :index] do 
    resources :applicants, only: [:new, :create, :edit, :show] do
      get '/:phase', to: 'applicants#phase', as: 'phase'
    end
    get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
  end
  get '/jobs/:id/:status', to: 'jobs#upgrade_status', as:'upgrade_status'
  resources :dashboards
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }

  post '/:job_id/:id/email_to_applicant', to: 'applicants#send_email', as: :email_to_applicant
  get '/dashboards' => "dashboards#index", as: :user_root

  resources :schedules, only: [:index, :show, :destroy]
  get '/applicants/:id/schedules/new' => 'schedules#new', as: 'new_applicant_schedule'
  post '/applicants/:id/schedules/' => 'schedules#create', as: 'applicant_schedules'
  get 'aplicants/:applicant_id/schedules/:id/edit' => 'schedules#edit', as: 'edit_applicant_schedule'
  patch 'aplicants/:applicant_id/schedules/:id' => 'schedules#update', as: 'applicant_schedule'
  # put 'aplicants/:applicant_id/schedules/:id' => 'schedules#update', as: 'applicant_schedule'


  get '/applicants' => "dashboards#applicant", as: 'applicant'
  root 'landing_page#index'

  mount API::Root => '/'
end