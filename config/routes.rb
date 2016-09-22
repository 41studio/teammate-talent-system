Rails.application.routes.draw do
  resources :companies do
    resources :jobs, only: [:new, :create, :edit, :update]
  end
  resources :jobs, only: [:show, :destroy] do 
    resources :applicants, only: [:new, :create, :edit, :show, :destroy] do
      get '/:phase', to: 'applicants#phase', as: 'phase'
    end
    get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
  end
  get '/jobs/:id/:status', to: 'jobs#upgrade_status', as:'upgrade_status'
  resources :dashboards
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }
  resources :jobs


  get '/dashboards' => "dashboards#index", as: :user_root

  root 'landing_page#index'

  mount API::Root => '/'
end
