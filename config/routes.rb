require 'sidekiq/web'

Rails.application.routes.draw do
  mount API::Root => '/api'
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine, at: "api/documentation"

  resources :companies, except: [:index] do

    resources :schedules, only: [:index] do 
      collection do
        get :filter
      end
    end

    resources :jobs do 
      resources :applicants, only: [:new, :create, :show] do
        member do
          get :phase, path: 'phase/:phase'
          get :disqualified
        end
        resources :comments, only: [:create]
        resources :schedules, except: [:index]
      end
      get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
    end
    get '/jobs/:id/:status', to: 'jobs#upgrade_status', as:'upgrade_status'
    post '/invite_personnel', to: 'companies#invite_personnel', as: 'invite_personnel'
    resources :report, only: [:index]
    get 'report/download_report', to: 'report#download_report', as: 'report_download'
  end
  # post '/companies/:id/invite_personnel', to: 'companies#invite_personnel', as: 'invite_personnel'
  get '/applicants' => "dashboards#applicant", as: 'applicant'
  resources :dashboards, only: [:index]
  # get '/dashboards' => "dashboards#index", as: :user_root
  devise_for :users, :controllers => { registrations: 'registrations',
                                       confirmations: 'confirmations', 
                                       invitations: 'users/invitations' }

  post '/:job_id/:id/email_to_applicant', to: 'applicants#send_email', as: :email_to_applicant
  
  get '/autocomplete/json', to: 'companies#autocomplete_industry', as: 'autocomplete_industry' , defaults: { format: 'json' }

  root 'landing_page#index'

end