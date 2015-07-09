Rails.application.routes.draw do

  root :to => 'home#index'

  devise_for :users

  resources :users, :only => :show do
    resources :goals, shallow: true
  end

end
