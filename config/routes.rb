Rails.application.routes.draw do
  get "search/index"
  get "activities/index"
  get "activities/show"
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
  
  # Root route - point directly to user dashboard
  root "user/dashboard#index"
  
  # Component test route (development only)
  get "component_test", to: "component_test#index" if Rails.env.development?
  
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
