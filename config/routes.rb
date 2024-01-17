Rails.application.routes.draw do
  resources :products
  get 'index' => 'products#new'
  get 'products/validate_upc_code/:upc_code', to: 'products#validate_upc_code', as: :validate_upc_code
  get 'products/fetch_product_info/:upc_code', to: 'products#fetch_product_info', as: :fetch_product_info

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'products#new'
end
