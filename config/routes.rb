Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'songs#index'

  # Authentication
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#error'
  get 'signout', to: 'sessions#destroy', as: 'sign_out'
  get 'signin', to: 'sessions#new', as: 'sign_in'

  get '/*path', to: 'songs#index'

  # Mobile API
  namespace :api, defaults: {format: :json} do
    get 'songs', to: 'songs#recently_updated'
    get 'songs/deleted', to: 'songs#deleted'
  end
end
