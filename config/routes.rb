# config/routes.rb
# see http://guides.rubyonrails.org/routing.html
ZxTemplateEngine::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
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
#  get "home/index"
#  get "home/logout"
#  root :to => 'home#index'
  root :to => 'templates#index'
end
