Rails.application.routes.draw do

  root :to => 'home#index'

  get 'search', to: 'search#index'

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, :only => :show, shallow: true do
    resources :goals, shallow: true do
      resources :milestones
      resources :posts, shallow: true do
        resources :comments
      end
    end
    member do
      get :following, :followers
    end
  end

  resources :relationships, :only => [:create, :destroy]

end
