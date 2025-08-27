Rails.application.routes.draw do
  get "search/index"
  get "activity_logs/index"
  get "activity_logs/show"
  get "tags/index"
  get "tags/show"
  get "tags/create"
  get "tags/destroy"
  get "folders/index"
  get "folders/show"
  get "folders/new"
  get "folders/create"
  get "folders/edit"
  get "folders/update"
  get "folders/destroy"
  get "folders/contents"
  get "documents/index"
  get "documents/show"
  get "documents/new"
  get "documents/create"
  get "documents/edit"
  get "documents/update"
  get "documents/destroy"
  get "documents/change_status"
  get "documents/add_tag"
  get "documents/remove_tag"
  get "documents/search"
  get "teams/index"
  get "teams/show"
  get "teams/new"
  get "teams/create"
  get "teams/edit"
  get "teams/update"
  get "teams/destroy"
  get "teams/join"
  get "teams/leave"
  get "organizations/index"
  get "organizations/show"
  get "organizations/new"
  get "organizations/create"
  get "organizations/edit"
  get "organizations/update"
  get "organizations/destroy"
  get "dashboard/index"
  devise_for :users
  
  # Root route
  root "dashboard#index"
  
  # Component test route (development only)
  get "component_test", to: "component_test#index" if Rails.env.development?
  
  # Dashboard
  get "dashboard", to: "dashboard#index"
  
  # Admin routes
  namespace :admin do
    get "users/index"
    get "users/show"
    get "users/edit"
    get "users/update"
    get "users/toggle_role"
    get "organizations/index"
    get "organizations/show"
    get "organizations/new"
    get "organizations/create"
    get "organizations/edit"
    get "organizations/update"
    get "organizations/destroy"
    get "dashboard/index"
    root "dashboard#index"
    resources :organizations
    resources :users do
      member do
        patch :toggle_role
      end
    end
    resources :teams
    resources :statuses
    resources :scenario_types
    resources :tags
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
  
  # Direct document routes for easier access
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
  
  # Folder routes for hierarchical navigation
  resources :folders do
    resources :documents
    member do
      get :contents
    end
  end
  
  # Tag management
  resources :tags
  
  # User management
  resources :users
  
  # Activity logs
  resources :activity_logs, only: [:index, :show]
  
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
