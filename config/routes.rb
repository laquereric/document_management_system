Rails.application.routes.draw do
  get "search/index", to: "models/search#index"
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
  root "user/dashboard#index"
  
  # Component test route (development only)
  get "component_test", to: "models/component_test#index" if Rails.env.development?
  
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
    resources :teams do
      member do
        patch :add_member
        patch :remove_member
      end
    end
    resources :statuses
    resources :scenarios
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
  

  
  # User management and nested resources
  resources :user, only: [] do
    get "dashboard", to: "dashboard#index"
    resources :activities, only: [:index, :show]
    resources :teams, only: [:index, :show]
    resources :tags, only: [:index, :show]
    resources :organizations, only: [:index, :show]
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
