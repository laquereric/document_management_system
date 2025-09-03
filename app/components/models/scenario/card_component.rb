class Models::Scenario::CardComponent < ApplicationComponent
  def initialize(scenario:, show_actions: true, admin_context: false, **system_arguments)
    @scenario = scenario
    @show_actions = show_actions
    @admin_context = admin_context
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :scenario, :show_actions, :admin_context, :system_arguments

  def card_classes
    "Box p-3 h-full #{system_arguments[:class]}"
  end

  def has_actions?
    show_actions && admin_context
  end

  def documents_count
    scenario.documents.count
  end

  def created_time_ago
    time_ago_in_words(scenario.created_at)
  end

  def admin_scenario_path
    models_scenario_path(scenario)
  end

  def edit_admin_scenario_path
    models_edit_scenario_path(scenario)
  end

  # Context methods for the template
  def template_context
    {
      card_classes: card_classes,
      has_actions?: has_actions?,
      documents_count: documents_count,
      created_time_ago: created_time_ago,
      scenario: scenario,
      show_actions: show_actions,
      admin_context: admin_context,
      admin_scenario_path: method(:admin_scenario_path),
      edit_admin_scenario_path: method(:edit_admin_scenario_path),
      link_to: method(:link_to),
      pluralize: method(:pluralize),
      time_ago_in_words: method(:time_ago_in_words)
    }
  end
end
