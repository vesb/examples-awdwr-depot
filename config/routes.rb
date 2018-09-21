Rails.application.routes.draw do
  resources :orders
  resources :line_items
  resources :carts
  root 'store#index', as: 'store_index'

  resources :products do
    # Iteration G2 atom feeds
    get :who_bought, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # CUSTOM routes

  # increment/decrement shopping cart quantities
  patch '/line_items/:id/change',
    to: 'line_items#change',
    as: :line_items_change,
    constraints: {id: /\d+/}
end
