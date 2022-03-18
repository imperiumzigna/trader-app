Rails.application.routes.draw do
  devise_for :users, path: '',
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }, path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', registration: 'register' }

  devise_scope :user do
    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end
end
