Rails.application.routes.draw do
  get 'home/index'
  get 'home/value_calculator'

  devise_for :users

  root :to => 'home#index'

  namespace :user do
    # #@todo add destroy and update for
    resources :investments, only: [:index, :show, :new, :create]
  end
end
