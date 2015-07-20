Rails.application.routes.draw do

  root :to => 'home#index'

  devise_for :users

  resources :users, :only => :show, shallow: true do
    resources :goals, shallow: true do
      resources :milestones
      resources :posts, shallow: true do
        resources :comments
      end
    end
  end

end
