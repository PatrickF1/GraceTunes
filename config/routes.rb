Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/songs')

  resources :songs do
    member do
      get 'print'
      get 'praise_set_song'
    end
  end

  resources :praise_sets do
    member do
      put 'archive'
      put 'unarchive'
    end
  end

  resources :audits, only: [:index]

  get 'songs/:id/history', to: 'audits#song_history', as: 'song_history'

  get "feedback", to: "contact#feedback"
  get "request_song", to: "contact#request_song"

  # Authentication
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#error'
  get 'signout', to: 'sessions#destroy', as: 'sign_out'
  get 'signin', to: 'sessions#new', as: 'sign_in'
end
