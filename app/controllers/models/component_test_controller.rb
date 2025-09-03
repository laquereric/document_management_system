# Simple test controller to demonstrate components
require "ostruct"

class Models::ComponentTestController < Models::ModelsController
  skip_before_action :authenticate_user!, only: [ :index ] if Rails.env.development?

  def index
    # Sample data for components
    @q = defined?(Document) ? Document.ransack(params[:q]) : nil

    # Sample search object for filter panel
    @sample_search = OpenStruct.new(
      status_eq: params[:status_eq],
      folder_id_eq: params[:folder_id_eq],
      tags_id_in: params[:tags_id_in]
    )

    # Sample documents
    @sample_documents = [
      OpenStruct.new(
        id: 1,
        title: "Project Requirements Document",
        content: "This is a comprehensive document outlining the project requirements.",
        author: OpenStruct.new(email: "john.doe@example.com", name: "John Doe"),
        folder: OpenStruct.new(path: "Projects / Documentation", name: "Documentation", id: 1),
        status: OpenStruct.new(name: "review", color: "#ffc107"),
        tags: [ OpenStruct.new(name: "Important"), OpenStruct.new(name: "Draft") ],
        updated_at: 2.hours.ago,
        created_at: 1.day.ago,
        file: OpenStruct.new(attached?: true, content_type: "application/pdf", byte_size: 1024000, filename: "requirements.pdf")
      ),
      OpenStruct.new(
        id: 2,
        title: "API Documentation",
        content: "Technical documentation for the REST API endpoints.",
        author: OpenStruct.new(email: "jane.smith@example.com", name: "Jane Smith"),
        folder: OpenStruct.new(path: "Documentation / API", name: "API", id: 2),
        status: OpenStruct.new(name: "approved", color: "#28a745"),
        tags: [ OpenStruct.new(name: "Technical") ],
        updated_at: 1.day.ago,
        created_at: 3.days.ago,
        file: OpenStruct.new(attached?: false)
      )
    ]

    @sample_document = @sample_documents.first

    # Sample teams
    @sample_teams = [
      OpenStruct.new(
        id: 1,
        name: "Development Team",
        organization: OpenStruct.new(name: "Tech Corp"),
        leader: OpenStruct.new(name: "John Doe"),
        team_memberships: [ OpenStruct.new, OpenStruct.new, OpenStruct.new ],
        folders: [ OpenStruct.new(documents: [ OpenStruct.new, OpenStruct.new ]) ]
      ),
      OpenStruct.new(
        id: 2,
        name: "Design Team",
        organization: OpenStruct.new(name: "Tech Corp"),
        leader: OpenStruct.new(name: "Jane Smith"),
        team_memberships: [ OpenStruct.new, OpenStruct.new ],
        folders: [ OpenStruct.new(documents: [ OpenStruct.new ]) ]
      )
    ]

    # Sample activity logs
    @sample_activities = [
      OpenStruct.new(
        id: 1,
        user: OpenStruct.new(name: "John Doe"),
        action: "created",
        document: OpenStruct.new(title: "Project Requirements Document"),
        created_at: 2.hours.ago,
        notes: "Document created"
      ),
      OpenStruct.new(
        id: 2,
        user: OpenStruct.new(name: "Jane Smith"),
        action: "status_change",
        document: OpenStruct.new(title: "API Documentation"),
        old_status: OpenStruct.new(name: "Draft"),
        new_status: OpenStruct.new(name: "Approved"),
        created_at: 1.day.ago,
        notes: "Status updated"
      ),
      OpenStruct.new(
        id: 3,
        user: OpenStruct.new(name: "Mike Johnson"),
        action: "tag_added",
        document: OpenStruct.new(title: "Project Requirements Document"),
        created_at: 3.hours.ago,
        notes: "Added tag: Important"
      )
    ]

    # Sample statuses
    @sample_statuses = [
      OpenStruct.new(name: "Draft", color: "#6c757d"),
      OpenStruct.new(name: "Review", color: "#ffc107"),
      OpenStruct.new(name: "Approved", color: "#28a745"),
      OpenStruct.new(name: "Rejected", color: "#dc3545")
    ]

    # Sample tags
    @sample_tags = [
      OpenStruct.new(id: 1, name: "Important"),
      OpenStruct.new(id: 2, name: "Draft"),
      OpenStruct.new(id: 3, name: "Technical"),
      OpenStruct.new(id: 4, name: "Review")
    ]

    # Sample folders
    @sample_folders = [
      OpenStruct.new(id: 1, name: "Documentation"),
      OpenStruct.new(id: 2, name: "API"),
      OpenStruct.new(id: 3, name: "Projects")
    ]

    # Mock the Tag and Folder models for the filter panel
    unless defined?(Tag)
      self.class.const_set(:Tag, Struct.new(:id, :name)) do
        def self.all
          [
            new(1, "Important"),
            new(2, "Draft"),
            new(3, "Technical"),
            new(4, "Review")
          ]
        end
      end
    end

    unless defined?(Folder)
      self.class.const_set(:Folder, Struct.new(:id, :name)) do
        def self.all
          [
            new(1, "Documentation"),
            new(2, "API"),
            new(3, "Projects")
          ]
        end
      end
    end
  end
end
