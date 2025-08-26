# Document Management System - UI Component Storyboard

## Overview

This document outlines the Primer View Components architecture for the Document Management System. The components are organized into logical groups and designed to work together to create a cohesive user experience.

## Component Architecture

### 1. Layout Components

#### `Ui::LayoutComponent`
**Purpose**: Main application shell providing consistent structure
**Props**:
- `title`: Page title
- `sidebar_variant`: `:default`, `:collapsed`, `:hidden`
- `show_breadcrumbs`: Boolean
- `current_user`: User object

**Use Cases**:
- Wrap all application pages
- Responsive sidebar behavior
- Consistent header/navigation placement

#### `Navigation::HeaderComponent`
**Purpose**: Top navigation bar with branding and user actions
**Props**:
- `current_user`: User object
- `title`: Optional page title suffix

**Use Cases**:
- App branding and logo display
- Quick search functionality
- User menu and notifications
- Consistent across all pages

#### `Navigation::SidebarComponent`
**Purpose**: Primary navigation menu
**Props**:
- `current_user`: User object
- `variant`: `:default`, `:collapsed`

**Use Cases**:
- Main application navigation
- Role-based menu items
- Collapsible for mobile/responsive design
- Active state indication

#### `Navigation::BreadcrumbComponent`
**Purpose**: Secondary navigation showing current location
**Props**:
- `breadcrumbs`: Array of breadcrumb objects (auto-generated if nil)

**Use Cases**:
- Show current page hierarchy
- Quick navigation to parent pages
- Auto-generation from controller/action

### 2. Document Components

#### `Document::CardComponent`
**Purpose**: Display individual document information
**Props**:
- `document`: Document object
- `layout`: `:list`, `:grid`, `:compact`
- `show_actions`: Boolean
- `show_metadata`: Boolean

**Use Cases**:
- Document listings (various layouts)
- Search results display
- Recent documents widgets
- Document previews in folders

**Variants**:
- **List Layout**: Full information with metadata
- **Grid Layout**: Card-style for gallery views
- **Compact Layout**: Minimal information for dense lists

#### `Document::ListComponent`
**Purpose**: Display collection of documents with controls
**Props**:
- `documents`: Collection of Document objects
- `layout`: `:list`, `:grid`, `:table`
- `show_filters`: Boolean
- `show_sorting`: Boolean
- `current_sort`: Sort field

**Use Cases**:
- Main documents index page
- Folder contents display
- Search results pages
- User's documents dashboard

#### `Document::ActionsMenuComponent`
**Purpose**: Contextual actions for documents
**Props**:
- `document`: Document object

**Use Cases**:
- Document card actions
- Context menus
- Bulk actions (when extended)

### 3. Folder Components

#### `Folder::TreeComponent`
**Purpose**: Hierarchical folder navigation
**Props**:
- `folders`: Collection of Folder objects
- `current_folder`: Currently selected folder
- `expanded_folders`: Array of expanded folder IDs
- `show_actions`: Boolean

**Use Cases**:
- Sidebar folder navigation
- Document organization interface
- Folder selection in forms
- File browser experience

### 4. Search Components

#### `Search::QuickSearchComponent`
**Purpose**: Header search functionality
**Props**:
- `placeholder`: Search input placeholder
- `value`: Current search value
- `size`: `:small`, `:medium`, `:large`

**Use Cases**:
- Global document search
- Quick access from any page
- Auto-complete functionality
- Real-time search suggestions

### 5. UI Components

#### `Ui::UserMenuComponent`
**Purpose**: User account menu and actions
**Props**:
- `user`: User object

**Use Cases**:
- User profile access
- Settings navigation
- Sign out functionality
- User identification

## Storyboard Use Cases

### 1. Dashboard View
```ruby
render(Ui::LayoutComponent.new(
  title: "Dashboard",
  current_user: current_user
)) do
  # Dashboard content with recent documents
  render(Document::ListComponent.new(
    documents: recent_documents,
    layout: :grid,
    show_filters: false
  ))
end
```

### 2. Document Library
```ruby
render(Ui::LayoutComponent.new(
  title: "Documents",
  current_user: current_user
)) do
  # Two-column layout: folders + documents
  content_tag(:div, class: "d-flex") do
    # Folder sidebar
    content_tag(:div, class: "flex-shrink-0 mr-3") do
      render(Folder::TreeComponent.new(
        folders: user_folders,
        current_folder: @folder,
        expanded_folders: session[:expanded_folders]
      ))
    end +
    
    # Document list
    content_tag(:div, class: "flex-auto") do
      render(Document::ListComponent.new(
        documents: @documents,
        layout: params[:layout]&.to_sym || :list
      ))
    end
  end
end
```

### 3. Document Detail View
```ruby
render(Ui::LayoutComponent.new(
  title: @document.title,
  current_user: current_user
)) do
  # Document header with actions
  content_tag(:div, class: "d-flex justify-content-between mb-4") do
    content_tag(:h1, @document.title) +
    render(Document::ActionsMenuComponent.new(document: @document))
  end +
  
  # Document content and metadata
  # ... document display logic
end
```

### 4. Search Results
```ruby
render(Ui::LayoutComponent.new(
  title: "Search Results",
  current_user: current_user
)) do
  # Search header
  content_tag(:div, class: "mb-4") do
    content_tag(:h2, "Search Results for \"#{params[:q]}\"") +
    content_tag(:p, "#{@documents.count} documents found", class: "color-fg-muted")
  end +
  
  # Results
  render(Document::ListComponent.new(
    documents: @documents,
    layout: :list,
    show_filters: true
  ))
end
```

### 5. Mobile/Responsive Behavior
- **Collapsed Sidebar**: Use `sidebar_variant: :collapsed` for tablets
- **Hidden Sidebar**: Use `sidebar_variant: :hidden` for mobile with toggle
- **Grid to List**: Document cards adapt layout based on screen size
- **Responsive Search**: Search component adjusts size and behavior

## Component Relationships

```
Ui::LayoutComponent
├── Navigation::HeaderComponent
│   ├── Search::QuickSearchComponent
│   └── Ui::UserMenuComponent
├── Navigation::SidebarComponent
│   └── Folder::TreeComponent (embedded)
├── Navigation::BreadcrumbComponent
└── [Main Content Area]
    ├── Document::ListComponent
    │   └── Document::CardComponent (multiple)
    │       └── Document::ActionsMenuComponent
    └── [Other page-specific components]
```

## Design Tokens & Theming

### Colors
- Primary: GitHub Primer accent colors
- Status indicators: Success (green), Warning (yellow), Danger (red)
- Text hierarchy: Primary, muted, subtle

### Spacing
- Component padding: `spacing_classes(:small|:medium|:large)`
- Consistent gaps between elements
- Responsive spacing adjustments

### Typography
- Text sizing: `text_size_classes(:small|:medium|:large|:xlarge)`
- Font weights: Regular, bold for emphasis
- Consistent line heights

## Accessibility Features

- Proper ARIA labels on interactive elements
- Keyboard navigation support
- Screen reader friendly structure
- High contrast compliance
- Focus management

## Performance Considerations

- Lazy loading for large document lists
- Virtual scrolling for folder trees with many items
- Efficient re-rendering with proper component boundaries
- Minimal JavaScript footprint using Primer's built-in interactions

## Future Extensions

### Planned Components
- `Document::FilterPanelComponent`: Advanced filtering interface
- `Document::TableComponent`: Table view for documents
- `Folder::ActionsMenuComponent`: Folder-specific actions
- `Ui::NotificationComponent`: Toast notifications
- `Dashboard::WidgetComponent`: Dashboard widgets
- `Activity::LogComponent`: Activity feed display

### Integration Points
- CanCanCan authorization checks in action menus
- Ransack integration for search/filtering
- Stimulus controllers for interactive behavior
- Turbo Frames for dynamic content updates
