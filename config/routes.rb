Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :products do
        resources :add_ons
      end
      resources :add_ons
    end
  end

  namespace :admin do
    resources :products do
      resources :add_ons
    end
  end
end
