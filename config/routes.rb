# config/routes.rb
# see http://guides.rubyonrails.org/routing.html
ZxTemplateEngine::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :templates do
    resources :placeholders
    resources :instances
  end

  resources :instances do
    resources :values
    member do # see: http://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default
      get 'generate'
      get 'email'
    end
  end

  root :to => 'templates#index'
end
