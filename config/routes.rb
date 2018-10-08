Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users

  resources :products do
    # Iteration G2 atom feeds
    get :who_bought, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end

  # CUSTOM routes

  # increment/decrement shopping cart quantities
  patch '/line_items/:id/change',
    to: 'line_items#change',
    as: :line_items_change,
    constraints: {id: /\d+/}
end
