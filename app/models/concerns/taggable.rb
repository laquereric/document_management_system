module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  # Add a tag to this model
  def add_tag(tag)
    tags << tag unless tags.include?(tag)
  end

  # Remove a tag from this model
  def remove_tag(tag)
    tags.delete(tag)
  end

  # Check if this model has a specific tag
  def has_tag?(tag)
    tags.include?(tag)
  end

  # Get tag names as a comma-separated string
  def tag_names
    tags.pluck(:name).join(", ")
  end

  # Get tag names as an array
  def tag_name_array
    tags.pluck(:name)
  end

  # Get tags by name
  def tags_by_name(*names)
    tags.where(name: names)
  end

  # Get tags by color
  def tags_by_color(color)
    tags.where(color: color)
  end

  # Count of tags
  def tag_count
    tags.count
  end

  # Check if this model has any tags
  def tagged?
    tags.any?
  end

  # Get tags in a specific context (organization, team, folder, or global)
  def tags_in_context(context)
    case context
    when "organization"
      if respond_to?(:organization) && organization
        # Get tags that are scoped to this organization
        Tag.where(organization_id: organization.id)
      else
        Tag.none
      end
    when "team"
      if respond_to?(:team) && team
        # Get tags that are scoped to this team
        Tag.where(team_id: team.id)
      else
        Tag.none
      end
    when "folder"
      if respond_to?(:folder) && folder
        # Get tags that are scoped to this folder
        Tag.where(folder_id: folder.id)
      else
        Tag.none
      end
    when "global"
      # Get tags that are not scoped to any specific context
      Tag.where(organization_id: nil, team_id: nil, folder_id: nil)
    else
      # Return all tags
      Tag.all
    end
  end
end
