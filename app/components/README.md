# UI Components

This directory contains the View Components for the Document Management System, built with Rails ViewComponent and styled with Bootstrap.

## Structure

```
app/components/
├── application_component.rb          # Base component class
├── ui/                              # General UI components
│   ├── layout_component.rb         # Main application layout
│   ├── user_menu_component.rb      # User account menu
│   ├── status_badge_component.rb   # Status display badges
│   └── empty_state_component.rb    # Empty state displays
├── navigation/                      # Navigation components
│   ├── header_component.rb         # Top navigation bar
│   ├── sidebar_component.rb        # Primary navigation menu
│   └── breadcrumb_component.rb     # Breadcrumb navigation
├── dashboard/                       # Dashboard components
│   ├── stats_card_component.rb     # Statistics display cards
│   ├── recent_documents_component.rb # Recent documents list
│   └── recent_activity_component.rb # Recent activity feed
├── document/                        # Document-related components
│   ├── card_component.rb           # Document display card
│   ├── list_component.rb           # Document collection display
│   └── actions_menu_component.rb   # Document action menu
├── forms/                           # Form components
│   └── document_form_component.rb  # Document creation/editing form
├── activity_logs/                   # Activity log components
│   ├── activity_log_item_component.rb # Individual activity log item
│   └── activity_log_list_component.rb # Activity log list with pagination
├── teams/                           # Team components
│   └── team_card_component.rb      # Team information display
├── tags/                            # Tag components
│   └── tag_badge_component.rb      # Tag display with optional removal
├── search/                          # Search components
│   ├── quick_search_component.rb   # Header search functionality
│   └── search_form_component.rb    # Advanced search form
├── folder/                          # Folder-related components
│   └── tree_component.rb           # Hierarchical folder navigation
└── previews/                        # Component previews for development
    ├── dashboard/
    └── forms/
```

## Getting Started

### Prerequisites

1. Ensure `view_component` gem is installed (already in Gemfile)
2. Run `bundle install`
3. Restart your Rails server

### Using Components

Components can be rendered in views using the `render` helper:

```erb
<%= render(Ui::LayoutComponent.new(
  title: "My Page",
  current_user: current_user
)) do %>
  <!-- Page content here -->
<% end %>
```

### Component Previews

Access component previews at `/rails/view_components` in development mode to see all components in isolation.

## Component Categories

### Dashboard Components

#### StatsCardComponent
Displays statistics in colored cards with icons.

```erb
<%= render(Dashboard::StatsCardComponent.new(
  title: "Total Documents",
  value: 42,
  icon: "file-text",
  color: "primary"
)) %>
```

#### RecentDocumentsComponent
Shows a list of recent documents with metadata.

```erb
<%= render(Dashboard::RecentDocumentsComponent.new(
  documents: @recent_documents,
  limit: 5
)) %>
```

#### RecentActivityComponent
Displays recent activity logs with user actions.

```erb
<%= render(Dashboard::RecentActivityComponent.new(
  activities: @recent_activity,
  limit: 10
)) %>
```

### Document Components

#### DocumentFormComponent
Complete form for creating and editing documents.

```erb
<%= render(Forms::DocumentFormComponent.new(
  document: @document,
  folder: @folder
)) %>
```

#### DocumentCardComponent
Individual document display with metadata and actions.

```erb
<%= render(Document::CardComponent.new(document: @document)) %>
```

#### DocumentListComponent
List view for multiple documents with pagination.

```erb
<%= render(Document::ListComponent.new(
  documents: @documents,
  layout: :list
)) %>
```

### Activity Log Components

#### ActivityLogItemComponent
Individual activity log entry with action icons and descriptions.

```erb
<%= render(ActivityLogs::ActivityLogItemComponent.new(
  activity_log: @activity_log
)) %>
```

#### ActivityLogListComponent
List of activity logs with pagination support.

```erb
<%= render(ActivityLogs::ActivityLogListComponent.new(
  activity_logs: @activity_logs,
  title: "Activity Log",
  show_pagination: true
)) %>
```

### Team Components

#### TeamCardComponent
Team information display with member counts and management options.

```erb
<%= render(Teams::TeamCardComponent.new(
  team: @team,
  current_user: current_user
)) %>
```

### UI Components

#### StatusBadgeComponent
Status display with proper color contrast.

```erb
<%= render(Ui::StatusBadgeComponent.new(status: @status)) %>
```

#### TagDisplayComponent
Tag display with optional removal functionality.

```erb
<%= render(Tags::TagDisplayComponent.new(
  tag: @tag,
  removable: true,
  document: @document
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
<%= render(Search::SearchFormComponent.new(q: @q)) %>
```

## Design System

These components follow consistent design patterns:

- **Bootstrap 5** for styling and layout
- **Bootstrap Icons** for consistent iconography
- **Responsive design** for all screen sizes
- **Accessible** by default with proper ARIA labels
- **Consistent spacing** using Bootstrap's spacing utilities
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

## Next Steps

1. **Integration**: Replace existing views with component-based architecture
2. **Testing**: Add comprehensive component tests
3. **Documentation**: Complete usage examples and API documentation
4. **Performance**: Optimize component rendering and caching
5. **Accessibility**: Enhance ARIA support and keyboard navigation
