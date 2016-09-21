Rails.application.routes.draw do
  resources :companies do
    resources :jobs, only: [:new, :create, :edit, :update]
  end
  resources :jobs, only: [:show, :destroy] do 
    resources :applicants, only: [:new, :create, :edit]
    get '/applicant/:status', to: 'applicants#applicant_status', as: 'applicant_status'
  end
  resources :applicants, only: [:show, :edit, :destroy] do
    get '/:phase', to: 'applicants#phase', as: 'phase'
  end
  resources :dashboards
  devise_for :users, :controllers => { registrations: 'registrations', confirmations: 'confirmations' }
  resources :applicants
  resources :jobs


  get '/dashboards' => "dashboards#index", as: :user_root

  root 'landing_page#index'

  mount API::Root => '/'
end
