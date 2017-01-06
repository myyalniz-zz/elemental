Rails.application.routes.draw do
  resources :inputs
  resources :video_selectors
  resources :audio_selectors
  resources :input_types
  resources :input_processings do
    collection do
      get :change_attributes_wid
      get :change_attributes_wlabel

      get :prepare_wid
      get :prepare_wlabel
      get :prepare

      get :activate_wid
      get :activate_wlabel
      get :activate
      
      get :delete_wid
      get :delete_wlabel
      get :delete

      get :add_wids
      get :add
      
      get :replace_wids
      get :replace
      
      get :single_add_wids
      get :single_add
      
      post :reorder
    end
  end
  
  resources :live_events do
    collection do 
      get :start
      get :stop
      get :cancel
      get :archive
      get :reset
      get :priority
      get :set_priority
    end
  end
  
  
  root to: "live_events#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
