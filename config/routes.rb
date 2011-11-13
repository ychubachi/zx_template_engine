ZxTemplateEngine::Application.routes.draw do
  devise_for :users

#  root :to => 'home#index'
  root :to => 'templates#index'

  get "home/index"
  get "home/logout"

  resources :placeholders
  resources :instances
  resources :values
  resources :templates do
    resources :placeholders
    resources :instances do
      resources :values
      member do # see: http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default
        get 'generate'
      end
    end
  end
end
