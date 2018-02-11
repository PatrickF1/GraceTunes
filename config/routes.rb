Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/songs')

  resources :songs do
    member do
      get 'print'
    end
  end

  get "feedback", to: "contact#feedback"

  # Authentication
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#error'
  get 'signout', to: 'sessions#destroy', as: 'sign_out'
  get 'signin', to: 'sessions#new', as: 'sign_in'
end
