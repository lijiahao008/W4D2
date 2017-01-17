Rails.application.routes.draw do
  resources :cats

  resources :cat_rental_requests, only: [:new, :create] do
    member do
      get "/approve", to: "cat_rental_requests#approve"
      get "/deny", to: "cat_rental_requests#deny"
    end
  end
end
