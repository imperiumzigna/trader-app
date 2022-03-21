Rails.application.routes.draw do
  resources :users, only: [:show, :update]
  get '/', to: 'home#index', as: :home

  devise_for :users, path: '',
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }, path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', registration: 'register' }

  devise_scope :user do
    authenticated  do
      root to: 'dashboard#pages'
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end
end
