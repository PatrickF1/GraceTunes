# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/songs')

  resources :songs do
    member do
      get 'print'
    end
  end

  resources :audits, only: [:index]

  get 'songs/:id/history', to: 'audits#song_history', as: 'song_history'

  get "about", to: "general#about"
  get "request_song", to: "general#request_song"

  # Authentication
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#error'
  get 'signout', to: 'sessions#destroy', as: 'sign_out'
  get 'signin', to: 'sessions#new', as: 'sign_in'

  namespace :api, defaults: {format: :json} do
    scope :v1 do
      resources :songs

      scope :audits do
        scope :songs do
          get ':id', to: "audits#song_history"
          get '', to: 'audits#songs_history_index'
        end
      end
    end
  end
end
