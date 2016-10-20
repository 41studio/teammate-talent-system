require 'sidekiq/web'

Rails.application.routes.draw do
  resources :companies, except: [:index] do
    resources :jobs do 
      resources :applicants, only: [:new, :create, :show] do
        resources :schedules
        resources :comments, only: [:create]
        member do
          get :phase, param: :phase
          get '/disqualified', to: 'applicants#disqualified', as: 'disqualified'
        end
      end
      get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
    end
    get '/jobs/:id/:status', to: 'jobs#upgrade_status', as:'upgrade_status'
    post '/invite_personnel', to: 'companies#invite_personnel', as: 'invite_personnel'
    get 'report/', to: 'report#index'
  end
  # post '/companies/:id/invite_personnel', to: 'companies#invite_personnel', as: 'invite_personnel'
  resources :dashboards, only: [:index]
  # get '/dashboards' => "dashboards#index", as: :user_root
  devise_for :users, :controllers => { registrations: 'registrations',
                                       confirmations: 'confirmations', 
                                       invitations: 'users/invitations' }

  post '/:job_id/:id/email_to_applicant', to: 'applicants#send_email', as: :email_to_applicant
  
  get '/autocomplete/json', to: 'companies#autocomplete_industry', as: 'autocomplete_industry' , defaults: { format: 'json' }

  get '/applicants' => "dashboards#applicant", as: 'applicant'
  root 'landing_page#index'

  mount API::Root => '/'
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine, at: "/swagger-ui"

end