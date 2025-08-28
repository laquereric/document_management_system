# Document Management System

A comprehensive Ruby on Rails application for managing documents with organizational structure, workflow states, and tagging capabilities.

## Features

### Core Functionality
- **Document Management**: Create, edit, view, and organize documents
- **Organizational Structure**: Organizations, teams, and user management
- **Workflow States**: Document status tracking (Draft, Pending, Approved, Rejected, Published)
- **Tagging System**: Categorize documents with colored tags
- **Activity Logging**: Track all document changes and user actions
- **Hierarchical Folders**: Organize documents in nested folder structures

### User Roles
- **Admin**: Full system access, user management, organization management
- **Team Leader**: Manage team documents and members
- **Member**: Create and manage own documents within team folders

### Key Components
- **Dashboard**: Overview of documents, teams, and recent activity
- **Document Workflow**: Status changes with activity logging
- **Team Management**: Join/leave teams, folder-based organization
- **Search & Filtering**: Find documents by title, content, tags, or status
- **Admin Panel**: User management, infrastructure, and financial tabs

## Technology Stack

- **Ruby**: 3.3.6
- **Rails**: 8.0.2.1
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Frontend**: Bootstrap 5.3.0 with Bootstrap Icons
- **Testing**: RSpec and Cucumber

## Installation

### Prerequisites
- Ruby 3.3.6
- PostgreSQL
- Node.js (for asset compilation)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd document_management_system
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   # Start PostgreSQL service
   sudo service postgresql start
   
   # Create PostgreSQL user (if needed)
   sudo -u postgres createuser -s <your-username>
   
   # Create and migrate database
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the application**
   ```bash
   rails server
   ```

5. **Access the application**
   - Open your browser to `http://localhost:3000`
   - Login with the default admin account:
     - Email: `admin@example.com`
     - Password: `password123`

## Database Schema

### Core Models
- **User**: Authentication and user management
- **Organization**: Top-level organizational structure
- **Team**: Groups within organizations
- **TeamMembership**: Join table for users and teams
- **Folder**: Hierarchical document organization
- **Document**: Core document entity
- **Status**: Document workflow states
- **ScenarioType**: Document categorization
- **Tag**: Document tagging system
- **DocumentTag**: Join table for documents and tags
- **ActivityLog**: Audit trail for all document actions

### Key Relationships
- Organizations have many teams
- Teams belong to organizations and have many users through memberships
- Folders belong to teams and can have parent folders (hierarchical)
- Documents belong to folders and have authors (users)
- Documents have statuses and scenario types
- Documents can have many tags through document_tags
- All document changes are logged in activity_logs

## Configuration

### Environment Variables
The application uses standard Rails configuration. Key settings:

- **Database**: Configure in `config/database.yml`
- **Devise**: Email settings in `config/initializers/devise.rb`
- **Host Authorization**: Configured in `config/environments/development.rb`

### Seed Data
The application includes seed data with:
- Default statuses (Draft, Pending, Approved, Rejected, Published)
- Default scenario types (Standard Document, Policy Document, etc.)
- Default tags (Important, Urgent, Technical, etc.)
- Sample organization, team, and admin user
- Sample document for demonstration

## Testing

### RSpec Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
```

### Cucumber Features
```bash
# Run all features
bundle exec cucumber

# Run specific features
bundle exec cucumber features/authentication.feature
```

## API Endpoints

The application includes API endpoints for AJAX requests:

### Documents API
- `GET /api/v1/documents` - List documents
- `GET /api/v1/documents/:id` - Show document
- `PATCH /api/v1/documents/:id` - Update document

### Folders API
- `GET /api/v1/folders` - List folders
- `GET /api/v1/folders/:id` - Show folder contents

### Tags API
- `GET /api/v1/tags` - List all tags

## Security Features

- **Authentication**: Devise-based user authentication
- **Authorization**: Role-based access control
- **CSRF Protection**: Rails built-in CSRF protection
- **SQL Injection Prevention**: ActiveRecord parameterized queries
- **Host Authorization**: Configured for development and production

## CI/CD Support

The application includes built-in CI/CD support with automated setup scripts and security bypass capabilities for automated testing and deployment.

### CI/CD Scripts

#### Ruby Environment Management
```bash
# Configure Ruby environment only
./bin/cicd_ruby

# Check Ruby version information
./bin/cicd_ruby --version

# Show help
./bin/cicd_ruby --help
```

#### Complete Setup (for CI/CD pipelines)
```bash
# Setup environment without starting server
./bin/cicd_setup
```

#### Start Server (after setup)
```bash
# Start the Rails server
bundle exec rails server
```

### CI/CD Security Management

The application includes rake tasks to manage authentication for CI/CD environments:

```bash
# Check current security status
rake cicd_security:status

# Disable authentication for CI/CD
rake cicd_security:disable

# Re-enable authentication
rake cicd_security:enable
```

### What the CI/CD Scripts Do

#### `bin/cicd_ruby` - Ruby Environment Manager
- **Automatic Ruby Installation**: Installs Ruby if not available on the system
- **Cross-Platform Support**: Works on macOS, Linux, and Windows (with manual install)
- **Version Management**: Detect and validate Ruby version (supports .ruby-version file)
- **Auto-switch Ruby versions**: Uses rbenv or rvm if needed
- **Bundler Management**: Install Bundler if not available
- **Gem Management**: Install/update Ruby gems automatically
- **Rails Validation**: Validate Rails installation
- **Independent Operation**: Can be run independently with `--version` or `--help` options

#### `bin/cicd_setup` - Complete Environment Setup
1. **Ruby Environment**: Calls `bin/cicd_ruby` to configure Ruby
2. **Security Setup**: Disable authentication for automated testing
3. **Database Setup**: Create database and run migrations
4. **Data Seeding**: Populate with initial data (admin user, etc.)
5. **Asset Compilation**: Precompile assets for production readiness

### CI/CD Security Features

- **Authentication Bypass**: Temporarily disable user authentication for automated testing
- **Git Ignored**: Security bypass file is automatically ignored by Git
- **Easy Management**: Simple rake tasks to enable/disable security
- **Status Checking**: Clear status messages with current security state

### Ruby Environment Management

The CI/CD scripts include comprehensive Ruby environment setup:

- **Automatic Installation**: Installs Ruby automatically if not available on the system
- **Cross-Platform**: Supports macOS (Homebrew, rbenv, rvm), Linux (rbenv, rvm, apt-get, yum), and Windows
- **Version Detection**: Automatically detects current Ruby version
- **Version Management**: Supports `.ruby-version` file for version specification
- **Auto-switching**: Uses rbenv or rvm to switch Ruby versions if needed
- **Bundler Setup**: Installs Bundler if not available
- **Gem Management**: Automatically installs/updates Ruby gems
- **Rails Validation**: Ensures Rails is properly installed and configured

### Example CI/CD Pipeline Usage

```yaml
# Example GitHub Actions workflow
- name: Setup CI/CD Environment
  run: ./bin/cicd_setup

- name: Run Tests
  run: bundle exec rspec

- name: Re-enable Security
  run: bundle exec rake cicd_security:enable
```

### Example Development Workflow

```bash
# 1. Configure Ruby environment (if needed)
./bin/cicd_ruby

# 2. Setup complete environment
./bin/cicd_setup

# 3. Start the server
bundle exec rails server
```

## Deployment

### Production Deployment

1. **Environment Setup**
   ```bash
   # Set production environment
   export RAILS_ENV=production
   
   # Install production gems
   bundle install --without development test
   ```

2. **Database Configuration**
   ```bash
   # Create production database
   rails db:create RAILS_ENV=production
   rails db:migrate RAILS_ENV=production
   rails db:seed RAILS_ENV=production
   ```

3. **Asset Compilation**
   ```bash
   rails assets:precompile RAILS_ENV=production
   ```

4. **Server Configuration**
   - Configure web server (Nginx/Apache)
   - Set up application server (Puma/Unicorn)
   - Configure SSL certificates
   - Set up monitoring and logging

### Docker Deployment (Optional)

Create a `Dockerfile`:
```dockerfile
FROM ruby:3.3.6
WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

## Monitoring and Maintenance

### Log Files
- Application logs: `log/production.log`
- Database queries: Enable in Rails configuration
- Error tracking: Consider integrating Sentry or similar

### Backup Strategy
- Regular database backups
- File storage backups (if using file uploads)
- Configuration backups

### Performance Optimization
- Database indexing on frequently queried columns
- Caching strategies for frequently accessed data
- Asset optimization and CDN usage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions:
- Check the application logs for error details
- Review the Rails guides for framework-specific issues
- Consult the gem documentation for third-party dependencies

## Version History

- **v1.0.0**: Initial release with core document management features
  - User authentication and authorization
  - Document CRUD operations
  - Organizational structure (Organizations, Teams, Folders)
  - Workflow states and activity logging
  - Tagging system
  - Admin panel with user management
  - Bootstrap-based responsive UI
