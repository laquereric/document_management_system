# UI Components

This directory contains the Primer View Components for the Document Management System.

## Structure

```
app/components/
├── application_component.rb          # Base component class
├── ui/                              # General UI components
│   ├── layout_component.rb         # Main application layout
│   └── user_menu_component.rb      # User account menu
├── navigation/                      # Navigation components
│   ├── header_component.rb         # Top navigation bar
│   ├── sidebar_component.rb        # Primary navigation menu
│   └── breadcrumb_component.rb     # Breadcrumb navigation
├── document/                        # Document-related components
│   ├── card_component.rb           # Document display card
│   ├── list_component.rb           # Document collection display
│   └── actions_menu_component.rb   # Document action menu
├── folder/                          # Folder-related components
│   └── tree_component.rb           # Hierarchical folder navigation
├── search/                          # Search components
│   └── quick_search_component.rb   # Header search functionality
└── previews/                        # Component previews for development
    ├── document/
    └── navigation/
```

## Getting Started

### Prerequisites

1. Ensure `primer_view_components` gem is installed (already in Gemfile)
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

## Design System

These components follow the GitHub Primer Design System:

- **Consistent spacing** using Primer's spacing scale
- **Semantic colors** for status and interaction states  
- **Accessible** by default with proper ARIA labels
- **Responsive** design patterns
- **Modern** CSS using Primer's utility classes

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
