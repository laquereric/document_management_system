Rails.application.routes.draw do
  get "search/index", to: "search#index"
  get "activities/index", to: "models/activities#index"
  get "activities/show", to: "models/activities#show"
  get "tags/index", to: "models/tags#index"
  get "tags/show", to: "models/tags#show"
  get "tags/create", to: "models/tags#create"
  get "tags/destroy", to: "models/tags#destroy"
  get "folders/index", to: "models/folders#index"
  get "folders/show", to: "models/folders#show"
  get "folders/new", to: "models/folders#new"
  get "folders/create", to: "models/folders#create"
  get "folders/edit", to: "models/folders#edit"
  get "folders/update", to: "models/folders#update"
  get "folders/destroy", to: "models/folders#destroy"
  get "folders/contents", to: "models/folders#contents"
  get "documents/index", to: "models/documents#index"
  get "documents/show", to: "models/documents#show"
  get "documents/new", to: "models/documents#new"
  get "documents/create", to: "models/documents#create"
  get "documents/edit", to: "models/documents#edit"
  get "documents/update", to: "models/documents#update"
  get "documents/destroy", to: "models/documents#destroy"
  get "documents/change_status", to: "models/documents#change_status"
  get "documents/add_tag", to: "models/documents#add_tag"
  get "documents/remove_tag", to: "models/documents#remove_tag"
  get "documents/search", to: "models/documents#search"
  get "teams/index", to: "models/teams#index"
  get "teams/show", to: "models/teams#show"
  get "teams/new", to: "models/teams#new"
  get "teams/create", to: "models/teams#create"
  get "teams/edit", to: "models/teams#edit"
  get "teams/update", to: "models/teams#update"
  get "teams/destroy", to: "models/teams#destroy"
  get "teams/join", to: "models/teams#join"
  get "teams/leave", to: "models/teams#leave"
  get "organizations/index", to: "models/organizations#index"
  get "organizations/show", to: "models/organizations#show"
  get "organizations/new", to: "models/organizations#new"
  get "organizations/create", to: "models/organizations#create"
  get "organizations/edit", to: "models/organizations#edit"
  get "organizations/update", to: "models/organizations#update"
  get "organizations/destroy", to: "models/organizations#destroy"
  get "dashboard/index"
  devise_for :users
  
  # Root route - point directly to user dashboard
  root "dashboard/user#index"
  
  # Component test route (development only)
  get "component_test", to: "models/component_test#index" if Rails.env.development?
  
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
