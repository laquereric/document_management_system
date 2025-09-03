# UI Components

This directory contains the View Components for the Document Management System, built with Rails ViewComponent and styled with GitHub Primer CSS.

## Structure

```
app/components/
├── application_component.rb          # Base component class
├── ui/                              # General UI components
│   ├── delete_modal_component.rb   # Delete confirmation modal
│   ├── empty_state_component.rb    # Empty state displays
│   └── status_badge_component.rb   # Status display badges
├── layout/                          # Layout and structural components
│   ├── navigation/                  # Navigation components
│   │   ├── header_component.rb     # Top navigation bar
│   │   ├── sidebar_component.rb    # Primary navigation menu
│   │   ├── breadcrumb_component.rb # Breadcrumb navigation
│   │   └── search/                 # Search components
│   │       ├── quick_search_component.rb # Header search functionality
│   │       └── search_form_component.rb  # Advanced search form
│   ├── dashboard/                   # Dashboard components
│   │   ├── stats_card_component.rb # Statistics display cards
│   │   ├── recent_documents_component.rb # Recent documents list
│   │   ├── recent_activity_component.rb # Recent activity feed
│   │   ├── header_component.rb     # Dashboard header
│   │   ├── statistics_grid_component.rb # Statistics grid layout
│   │   ├── user/                   # User dashboard components
│   │   └── admin/                  # Admin dashboard components
│   ├── card/                       # Card components
│   │   ├── actions_menu_component.rb # Action menu for cards
│   │   └── tags/                   # Tag display components
│   │       ├── tag_display_component.rb # Tag display with removal
│   │       └── tag_label_component.rb   # Tag label display
│   ├── card_list/                  # Card list components
│   │   ├── list_component.rb       # List layout for cards
│   │   ├── table_component.rb      # Table layout for cards
│   │   ├── pagination/             # Pagination components
│   │   └── search_filter_sort/     # Search and filter components
│   └── page/                       # Page layout components
├── models/                          # Model-specific components
│   ├── documents/                   # Document components
│   │   ├── card_component.rb       # Document display card
│   │   └── document_form_component.rb # Document creation/editing form
│   ├── activities/                  # Activity components
│   │   ├── activity_item_component.rb # Individual activity item
│   │   ├── activity_list_component.rb # Activity list display
│   │   └── timeline_component.rb   # Activity timeline
│   ├── teams/                       # Team components
│   │   └── team_card_component.rb  # Team information display
│   ├── tags/                        # Tag components
│   │   ├── tag_form_component.rb   # Tag creation/editing form
│   │   └── tag_item_component.rb   # Tag display item
│   ├── folder/                      # Folder components
│   │   └── tree_component.rb       # Hierarchical folder navigation
│   ├── users/                       # User components
│   ├── organization/                # Organization components
│   └── scenario/                    # Scenario components
├── concerns/                        # Shared component concerns
└── previews/                        # Component previews for development
    ├── dashboard/
    ├── forms/
    ├── navigation/
    └── document/
```

## Getting Started

### Prerequisites

1. Ensure `view_component` gem is installed (already in Gemfile)
2. Run `bundle install`
3. Restart your Rails server

### Using Components

Components can be rendered in views using the `render` helper:

```erb
<%= render(Layout::Navigation::HeaderComponent.new(
  current_user: current_user
)) %>
```

### Component Previews

Access component previews at `/rails/view_components` in development mode to see all components in isolation.

## Component Categories

### Dashboard Components

#### UserDashboardComponent
User-specific dashboard layout.

```erb
<%= render(Dashboard::User::DashboardComponent.new(
  current_user: current_user
)) %>
```

#### AdminDashboardComponent
Admin-specific dashboard layout.

```erb
<%= render(Dashboard::Admin::DashboardComponent.new(
  current_user: current_user
)) %>
```

#### StatsCardComponent
Displays statistics in colored cards with icons.

```erb
<%= render(Layout::Dashboard::StatsCardComponent.new(
  title: "Total Documents",
  value: 42,
  icon: "file-text",
  color: "primary"
)) %>
```

#### RecentDocumentsComponent
Shows a list of recent documents with metadata.

```erb
<%= render(Layout::Dashboard::RecentDocumentsComponent.new(
  documents: @recent_documents,
  limit: 5
)) %>
```

#### RecentActivityComponent
Displays recent activity logs with user actions.

```erb
<%= render(Layout::Dashboard::RecentActivityComponent.new(
  activities: @recent_activity,
  limit: 10
)) %>
```

### Document Components

#### DocumentFormComponent
Complete form for creating and editing documents.

```erb
<%= render(Models::Documents::DocumentFormComponent.new(
  document: @document,
  folder: @folder
)) %>
```

#### FolderFormComponent
Complete form for creating and editing folders.

```erb
<%= render(Models::Folder::FolderFormComponent.new(
  folder: @folder
)) %>
```

#### DocumentCardComponent
Individual document display with metadata and actions.

```erb
<%= render(Models::Documents::CardComponent.new(document: @document)) %>
```

#### UserDocumentCardComponent
User-specific document display card.

```erb
<%= render(User::DocumentComponents::CardComponent.new(document: @document)) %>
```

#### DocumentActionsMenuComponent
Generic actions menu for documents and other resources.

```erb
<%= render(Layout::Card::ActionsMenuComponent.new(
  resource: @document,
  resource_type: 'document'
)) %>
```

#### DocumentListComponent
List view for multiple documents with pagination.

```erb
<%= render(Layout::CardList::ListComponent.new(
  documents: @documents,
  layout: :list
)) %>
```

### Activity Log Components

#### ActivityLogItemComponent
Individual activity log entry with action icons and descriptions.

```erb
<%= render(Models::Activities::ActivityItemComponent.new(
  activity_log: @activity_log
)) %>
```

#### ActivityLogListComponent
List of activity logs with pagination support.

```erb
<%= render(Models::Activities::ActivityListComponent.new(
  activity_logs: @activity_logs,
  title: "Activity Log",
  show_pagination: true
)) %>
```

#### ActivityItemComponent
Individual activity item display.

```erb
<%= render(Models::Activities::ActivityItemComponent.new(
  activity: @activity
)) %>
```

#### TimelineComponent
Activity timeline display.

```erb
<%= render(Models::Activities::TimelineComponent.new(
  activities: @activities
)) %>
```

### Team Components

#### TeamCardComponent
Team information display with member counts and management options.

```erb
<%= render(Models::Teams::TeamCardComponent.new(
  team: @team,
  current_user: current_user
)) %>
```

#### TeamsTeamCardComponent
Alternative team card component.

```erb
<%= render(Teams::TeamCardComponent.new(
  team: @team,
  current_user: current_user
)) %>
```

### UI Components

#### UserMenuComponent
User account menu with profile, settings, and sign out options.

```erb
<%= render(Models::Users::UserMenuComponent.new(user: current_user)) %>
```

#### UserCardComponent
User information display card.

```erb
<%= render(Layout::UserCardComponent.new(
  user: @user
)) %>
```

#### StatusBadgeComponent
Status display with proper color contrast.

```erb
<%= render(Ui::StatusBadgeComponent.new(status: @status)) %>
```

#### TagDisplayComponent
Tag display with optional removal functionality.

```erb
<%= render(Layout::Card::Tags::TagDisplayComponent.new(
  tag: @tag,
  removable: true,
  document: @document
)) %>
```

#### TagItemComponent
Individual tag display item.

```erb
<%= render(Models::Tags::TagItemComponent.new(
  tag: @tag,
  removable: true,
  document: @document
)) %>
```

#### TagFormComponent
Tag creation and editing form.

```erb
<%= render(Models::Tags::TagFormComponent.new(
  tag: @tag
)) %>
```

#### EmptyStateComponent
Consistent empty state displays with optional actions.

```erb
<%= render(Ui::EmptyStateComponent.new(
  title: "No Documents",
  description: "Create your first document to get started.",
  icon: "file-text",
  action_text: "Create Document",
  action_url: new_document_path
)) %>
```

### Search Components

#### SearchFormComponent
Advanced search form with multiple filters.

```erb
<%= render(Layout::Navigation::Search::SearchFormComponent.new(q: @q)) %>
```

### Card List Components

#### SearchAndFiltersComponent
Search and filter controls for card lists.

```erb
<%= render(Layout::CardList::SearchFilterSort::SearchAndFiltersComponent.new(
  search: @search,
  filters: @filters
)) %>
```

#### PaginationComponent
Pagination controls for card lists.

```erb
<%= render(Layout::CardList::Pagination::PaginationComponent.new(
  collection: @documents
)) %>
```

#### StatisticsGridComponent
Grid layout for statistics display.

```erb
<%= render(Layout::Dashboard::StatisticsGridComponent.new(
  statistics: @statistics
)) %>
```

### Folder Components

#### FolderTreeComponent
Hierarchical folder navigation tree.

```erb
<%= render(Models::Folder::TreeComponent.new(
  folders: @folders,
  current_folder: @current_folder
)) %>
```

#### UserFolderCardComponent
User-specific folder display card.

```erb
<%= render(User::Folder::CardComponent.new(
  folder: @folder
)) %>
```

#### OrganizationCardComponent
Organization information display.

```erb
<%= render(Organization::CardComponent.new(
  organization: @organization
)) %>
```

#### ScenarioCardComponent
Scenario information display.

```erb
<%= render(Scenario::CardComponent.new(
  scenario: @scenario
)) %>
```

## Design System

These components follow consistent design patterns:

- **GitHub Primer CSS** for styling and layout
- **GitHub Octicons** for consistent iconography
- **Responsive design** for all screen sizes
- **Accessible** by default with proper ARIA labels
- **Consistent spacing** using Primer's spacing utilities
- **Semantic colors** for status and interaction states

## Development Guidelines

### Creating New Components

1. Inherit from `ApplicationComponent`
2. Follow naming convention: `Module::ComponentNameComponent`
3. Place in appropriate subdirectory
4. Create corresponding preview file
5. Document props and use cases

### Component Props

- Use keyword arguments for all props
- Provide sensible defaults
- Validate prop values where appropriate
- Use `**system_arguments` for flexibility

### Example Component Structure

```ruby
class MyModule::MyComponent < ApplicationComponent
  def initialize(required_prop:, optional_prop: :default, **system_arguments)
    @required_prop = required_prop
    @optional_prop = optional_prop
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :required_prop, :optional_prop, :system_arguments

  def component_classes
    # Build CSS classes based on props
  end
end
```

## Testing

Components can be tested using RSpec with ViewComponent test helpers:

```ruby
RSpec.describe MyModule::MyComponent, type: :component do
  it "renders successfully" do
    render_inline(described_class.new(required_prop: "value"))
    
    expect(rendered_component).to have_text("Expected content")
  end
end
```

## Integration with Rails

### Controllers

Pass data to components in controller actions:

```ruby
def index
  @documents = current_user.documents.includes(:author, :folder, :status)
  @recent_activity = ActivityLog.recent.limit(10)
end
```

### Views

Use components in ERB templates:

```erb
<%= render(Document::ListComponent.new(
  documents: @documents,
  layout: params[:layout]&.to_sym || :list
)) %>
```

### Helpers

Components can access Rails helpers and routes:

```ruby
# In component class
def edit_link
  link_to "Edit", edit_document_path(document)
end
```

## Performance

- Components are lightweight and fast to render
- Use `includes` for associations to avoid N+1 queries
- Consider pagination for large collections
- Lazy load heavy components when possible

## Browser Support

- Modern browsers (Chrome, Firefox, Safari, Edge)
- Responsive design for mobile devices
- Progressive enhancement approach
- Graceful degradation for older browsers

## Component Test Page

Visit `/component_test` to see all components working together in a realistic application layout.

## Component Reconciliation Status

The components have been reconciled to match the actual file structure and usage. Here's what was updated:

### ✅ Resolved Inconsistencies
- **Namespace Alignment**: Updated README to use correct component namespaces (e.g., `Models::Documents::CardComponent` instead of `Document::CardComponent`)
- **Missing Components**: Added documentation for components that exist but weren't documented
- **Template Context**: Ensured all components have the `template_context` method for consistent data access
- **View Updates**: Fixed views to use correct component namespaces

### 🔧 Components Added to Documentation
- `Models::Users::UserMenuComponent` - User account menu
- `Layout::CardList::ListComponent` - Document list display
- `Layout::Card::ActionsMenuComponent` - Generic actions menu
- `Models::Folder::TreeComponent` - Folder navigation tree
- `Models::Activities::ActivityItemComponent` - Individual activity display
- `Models::Activities::TimelineComponent` - Activity timeline
- `Models::Tags::TagItemComponent` - Tag display item
- `Models::Tags::TagFormComponent` - Tag creation/editing form
- `Models::Folder::FolderFormComponent` - Folder creation/editing form
- `Dashboard::User::DashboardComponent` - User dashboard
- `Dashboard::Admin::DashboardComponent` - Admin dashboard
- `Layout::CardList::SearchFilterSort::SearchAndFiltersComponent` - Search and filters
- `Layout::CardList::Pagination::PaginationComponent` - Pagination controls
- `Layout::Dashboard::StatisticsGridComponent` - Statistics grid layout

### 📁 Current Component Structure
The components are organized into logical groups:
- **UI Components** (`app/components/ui/`) - General UI elements
- **Layout Components** (`app/components/layout/`) - Structural and navigation components
- **Model Components** (`app/components/models/`) - Domain-specific components
- **Form Components** (`app/components/forms/`) - Form-related components

### 🚀 Next Steps

1. **Testing**: Add comprehensive component tests for all components
2. **Performance**: Optimize component rendering and implement caching strategies
3. **Accessibility**: Enhance ARIA support and keyboard navigation
4. **Documentation**: Complete usage examples and API documentation
5. **Integration**: Continue replacing views with component-based architecture
