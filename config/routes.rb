ProjectV1::Application.routes.draw do
  root "sessions#new"

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#logout', as: 'logout'

  resources :leave_reason_categories

  resources :leaves, :only => [:new,:edit,:create,:update,:destroy,:index] do
    collection do 
      get :get_leaves
      get :reports
    end
  end
  
  resources :dashboard, only: [:index] do
    collection do
      get :dashboard_events
    end
  end
  
  resources :teams do
    collection do
      get 'unallocated_members'
    end
  end

  resources :ratings do
    collection do
      post 'create_mass_rate'
      post 'import'
      get 'ratings_import'
      get 'employee_rate'
    end
  end

  resources :employee, :only => [:update, :edit,:index,:show] do
    collection do
      match '/toggle_active/:id', to: 'employee#toggle_active', via: 'post', as: 'state_changed'
      match '/configure/:id' ,  to: 'employee#configure'   , via: ['post'],  as: 'configure'
      match '/change/:id'    ,  to: 'employee#change'      , via: ['get'], as: 'change_employee' 
    end
    resources :ratings, :only => [:new, :update, :create, :index]
  end

  resources :factors do
    collection do
      match '/destroy_factor_guidline/:id', to: 'factors#destroy_factor_guidline', via: 'post', as: 'disable_guidline'
    end
  end

  resources :technologies, :only => [:edit,:create, :new, :index, :update, :destroy]

  resources :chart,:only => [:index] do 
    collection do
      get :top_improving_degrading_employees
      get :top_employees
      get :employee_yesterday_rating
      get :overall_employee_impression
      get :line_chart
      get :leaves_pie
      get :most_regular_irregular_employees
      get :leave_reason_category_comparison
    end
  end

  match '/reports'       ,  to: 'reports#index'        , via: ['get','post']  
  match '/apihelp'       ,  to: 'apidocument#apihelp'    , via: 'get'
  match '/reports/export',  to: 'reports#export'       , via: 'post'
 
  resources :events ,:only => [:create,:index] do
    collection do 
      match '/get_events', to: 'events#get_events', via: 'get', as: 'get_events'
    end
  end
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

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :sessions, :only => [:create] do
        collection do 
          get 'logout'
        end
      end
      match '/sessions/badge_zero', to: 'sessions#update_badge_to_zero', via: 'get'
      resources :team, :only => [:index,:create,:update] do
        collection do
          post 'add_member'
          get 'project_manager_for_new_team'        
        end
      end
      resources :employee, :only => [:update, :show] do
        collection do
          get :project_manager_index
          get :upcomming_birthdays        
        end
      end
      resources :ratings, :only => [:create, :index, :show, :update] 
      resources :factor, :only => [:create, :index, :update]  do
        collection do
          match '/change_factor_state/:id' ,  to: 'factor#factor_state_toggle'   , via: ['post'],  as: 'configure_factor'
          match '/deactivate_guideline/:id', to: 'factor#deactivate_guideline', via: ['post'],  as: 'deactive_factor_guidline'
        end
      end
      resources :charts do 
        collection do
          get 'date_factorwise_employees'
          get 'employee_total_rating'
          get 'top_improving_employees'
          get 'rating_gauge'
        end
      end
      resources :leaves, :only => [:create,:index,:update] do
        collection do
          get 'reason_categories'
        end
      end
    end
  end

   match "*path", :to => "application#routing", :as => "error" ,:via => :all
end




