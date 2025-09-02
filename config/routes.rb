Rails.application.routes.draw do
  get "search/index", to: "search#index"
  get "dashboard/index"
  devise_for :users
  
  # Root route - point directly to user dashboard
  root "dashboard/user#index"
  
  # Component test route (development only)
  get "component_test", to: "models/component_test#index" if Rails.env.development?
  
  # Models namespace for all model-related functionality
  namespace :models do
    # Activities routes
    get "activities", to: "activities#index"
    get "activities/:id", to: "activities#show", as: :activity
    
    # Tags routes
    get "tags", to: "tags#index"
    get "tags/:id", to: "tags#show", as: :tag
    get "tags/new", to: "tags#new", as: :new_tag
    get "tags/:id/edit", to: "tags#edit", as: :edit_tag
    post "tags", to: "tags#create"
    patch "tags/:id", to: "tags#update"
    delete "tags/:id", to: "tags#destroy"
    
    # Folders routes
    get "folders", to: "folders#index"
    get "folders/:id", to: "folders#show", as: :folder
    get "folders/new", to: "folders#new", as: :new_folder
    get "folders/:id/edit", to: "folders#edit", as: :edit_folder
    post "folders", to: "folders#create"
    patch "folders/:id", to: "folders#update"
    delete "folders/:id", to: "folders#destroy"
    get "folders/:id/contents", to: "folders#contents"
    
    # Documents routes
    get "documents", to: "documents#index"
    get "documents/:id", to: "documents#show", as: :document
    get "documents/new", to: "documents#new", as: :new_document
    get "documents/:id/edit", to: "documents#edit", as: :edit_document
    post "documents", to: "documents#create"
    patch "documents/:id", to: "documents#update"
    delete "documents/:id", to: "documents#destroy"
    patch "documents/:id/change_status", to: "documents#change_status"
    post "documents/:id/add_tag", to: "documents#add_tag"
    delete "documents/:id/remove_tag", to: "documents#remove_tag"
    get "documents/search", to: "documents#search"
    
    # Teams routes
    get "teams", to: "teams#index"
    get "teams/:id", to: "teams#show", as: :team
    get "teams/new", to: "teams#new", as: :new_team
    get "teams/:id/edit", to: "teams#edit", as: :edit_team
    post "teams", to: "teams#create"
    patch "teams/:id", to: "teams#update"
    delete "teams/:id", to: "teams#destroy"
    post "teams/:id/join", to: "teams#join"
    delete "teams/:id/leave", to: "teams#leave"
    
    # Organizations routes
    get "organizations", to: "organizations#index"
    get "organizations/:id", to: "organizations#show", as: :organization
    get "organizations/new", to: "organizations#new", as: :new_organization
    get "organizations/:id/edit", to: "organizations#edit", as: :edit_organization
    post "organizations", to: "organizations#create"
    patch "organizations/:id", to: "organizations#update"
    delete "organizations/:id", to: "organizations#destroy"
    
    # Scenarios routes
    get "scenarios", to: "scenarios#index"
    get "scenarios/:id", to: "scenarios#show", as: :scenario
    get "scenarios/new", to: "scenarios#new", as: :new_scenario
    get "scenarios/:id/edit", to: "scenarios#edit", as: :edit_scenario
    post "scenarios", to: "scenarios#create"
    patch "scenarios/:id", to: "scenarios#update"
    delete "scenarios/:id", to: "scenarios#destroy"
    
    # Users routes
    get "users", to: "users#index"
    get "users/:id", to: "users#show", as: :user
    get "users/new", to: "users#new", as: :new_user
    get "users/:id/edit", to: "users#edit", as: :edit_user
    post "users", to: "users#create"
    patch "users/:id", to: "users#update"
    patch "users/:id/toggle_role", to: "users#toggle_role"
    delete "users/:id", to: "users#destroy"
  end
  
  # Admin routes
  namespace :admin do
    get "dashboard/index", to: "dashboard/admin#index"
    root "dashboard/admin#index"
    
    # Admin-specific routes now point to models controllers
    get "users", to: "models/users#index"
    get "users/:id", to: "models/users#show", as: :user
    get "users/:id/edit", to: "models/users#edit", as: :edit_user
    patch "users/:id", to: "models/users#update"
    patch "users/:id/toggle_role", to: "models/users#toggle_role", as: :toggle_role_user
    delete "users/:id", to: "models/users#destroy"
    
    get "organizations", to: "models/organizations#index"
    get "organizations/:id", to: "models/organizations#show", as: :organization
    get "organizations/:id/edit", to: "models/organizations#edit", as: :edit_organization
    patch "organizations/:id", to: "models/organizations#update"
    delete "organizations/:id", to: "models/organizations#destroy"
    
    get "teams", to: "models/teams#index"
    get "teams/:id", to: "models/teams#show", as: :team
    get "teams/:id/edit", to: "models/teams#edit", as: :edit_team
    patch "teams/:id", to: "models/teams#update"
    delete "teams/:id", to: "models/teams#destroy"
    
    get "tags", to: "models/tags#index"
    get "tags/:id", to: "models/tags#show", as: :tag
    get "tags/:id/edit", to: "models/tags#edit", as: :edit_tag
    patch "tags/:id", to: "models/tags#update"
    delete "tags/:id", to: "models/tags#destroy"
    
    get "scenarios", to: "models/scenarios#index"
    get "scenarios/:id", to: "models/scenarios#show", as: :scenario
    get "scenarios/:id/edit", to: "models/scenarios#edit", as: :edit_scenario
    patch "scenarios/:id", to: "models/scenarios#update"
    delete "scenarios/:id", to: "models/scenarios#destroy"
    
    get "infrastructure", to: "infrastructure#index"
    get "financial", to: "financial#index"
  end
  
  # Main application routes
  resources :organizations do
    resources :teams do
      resources :folders do
        resources :documents
      end
      member do
        post :join
        delete :leave
      end
    end
  end
  
  # User management and nested resources - now using models controllers
  resources :user, only: [] do
    get "dashboard", to: "dashboard/user#index"
    get "activities", to: "models/activities#user_activities"
    get "teams", to: "models/teams#user_teams"
    get "tags", to: "models/tags#user_tags"
    get "organizations", to: "models/organizations#user_organizations"
    resources :documents do
      member do
        patch :change_status
        post :add_tag
        delete :remove_tag
      end
      collection do
        get :search
      end
    end
    resources :folders do
      resources :documents
      member do
        get :contents
      end
    end
  end
  
  # Legacy routes for backward compatibility
  resources :tags
  resources :users
  
  # Search
  get "search", to: "search#index"
  
  # API routes for AJAX requests
  namespace :api do
    namespace :v1 do
      resources :documents, only: [:index, :show, :update]
      resources :folders, only: [:index, :show]
      resources :tags, only: [:index]
    end
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
