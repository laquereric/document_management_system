class Layout::Card::CardComponent < ApplicationComponent
  def initialize(show_actions: true, **system_arguments)
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :show_actions, :system_arguments

  def initialize_card_base(show_actions: true, **system_arguments)
    @show_actions = show_actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  def base_card_classes
    "Box p-3"
  end

  def condensed_card_classes
    "Box p-3"
  end

  def truncated_description(text, length: 100)
    return "" unless text.present?
    text.length > length ? "#{text[0...length]}..." : text
  end

  def formatted_date(date)
    return "Unknown date" unless date.present?
    date.strftime("%B %d, %Y")
  end

  def team_name(team)
    safe_name(team, "No team")
  end

  def safe_name(object, default = "Unknown")
    object&.name || default
  end

  def safe_count(collection)
    collection&.count || 0
  end

  def folder_path(folder)
    helpers.models_folder_path(folder)
  end

  def edit_folder_path(folder)
    helpers.models_edit_folder_path(folder)
  end

  def link_to(text, url, **options)
    helpers.link_to(text, url, **options)
  end

  def pluralize(count, singular, plural = nil)
    helpers.pluralize(count, singular, plural)
  end
end
