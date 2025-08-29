module CardConcerns
  extend ActiveSupport::Concern

  included do
    private

    attr_reader :show_actions, :system_arguments
  end

  def initialize_card_base(show_actions: true, **system_arguments)
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  # Common card CSS classes
  def base_card_classes
    "Box"
  end

  def condensed_card_classes
    "Box Box--condensed"
  end

  def card_classes
    classes = [base_card_classes, system_arguments[:class]].compact.join(" ")
    classes.strip
  end

  # Common Box section classes
  def header_classes
    "Box-header"
  end

  def title_classes
    "Box-title"
  end

  def body_classes
    "Box-body"
  end

  def footer_classes
    "Box-footer"
  end

  # Common date formatting
  def formatted_date(date = nil)
    target_date = date || (respond_to?(:created_at) ? created_at : nil)
    target_date&.strftime("%b %d, %Y") || "Unknown date"
  end

  def formatted_datetime(date = nil)
    target_date = date || (respond_to?(:created_at) ? created_at : nil)
    target_date&.strftime("%B %d, %Y at %I:%M %p") || "Unknown date"
  end

  # Common text truncation
  def truncate_text(text, length: 150)
    return "" if text.blank?
    text.length > length ? "#{text[0..length]}..." : text
  end

  def truncated_description(description = nil, length: 150)
    text = description || (respond_to?(:description) ? self.description : "")
    truncate_text(text, length: length)
  end

  def truncated_content(content = nil, length: 150)
    text = content || (respond_to?(:content) ? self.content : "")
    truncate_text(text, length: length)
  end

  # Common safe name getters
  def safe_name(object, fallback = "Unknown")
    object&.name || fallback
  end

  def organization_name(organization = nil)
    target_org = organization || (respond_to?(:organization) ? self.organization : nil)
    safe_name(target_org, "Unknown organization")
  end

  def team_name(team = nil)
    target_team = team || (respond_to?(:team) ? self.team : nil)
    safe_name(target_team, "Unknown team")
  end

  def author_name(author = nil)
    target_author = author || (respond_to?(:author) ? self.author : nil)
    safe_name(target_author, "Unknown author")
  end

  def folder_name(folder = nil)
    target_folder = folder || (respond_to?(:folder) ? self.folder : nil)
    safe_name(target_folder, "Unknown folder")
  end

  # Common count helpers with error handling
  def safe_count(relation)
    return 0 if relation.nil?
    
    if relation.respond_to?(:count) && !relation.is_a?(Array)
      relation.count
    else
      relation.length || 0
    end
  rescue
    0
  end

  # Permission helpers (can be overridden in components)
  def can_edit?
    return false unless respond_to?(:current_user) && current_user
    show_actions
  end

  def can_delete?
    return false unless respond_to?(:current_user) && current_user
    current_user.admin?
  end

  def can_manage?
    return false unless respond_to?(:current_user) && current_user
    current_user.admin?
  end

  # Icon helpers
  def default_icon
    "circle"
  end

  # Role-based label classes
  def role_label_class(role)
    case role.to_s.downcase
    when 'admin'
      'danger'
    when 'team_leader', 'leader'
      'attention'
    when 'active'
      'success'
    when 'inactive', 'archived'
      'secondary'
    else
      'secondary'
    end
  end

  class_methods do
    # Class-level helpers for card components
    def card_component_for(model_name)
      "#{model_name.to_s.classify}::CardComponent".constantize
    end
  end
end