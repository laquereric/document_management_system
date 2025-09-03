class Layout::Dashboard::QuickActionsComponent < ApplicationComponent
  def initialize(actions:, **system_arguments)
    @actions = actions
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :actions, :system_arguments

  def has_actions?
    actions.any?
  end

  def template_context
    {
      actions: actions,
      has_actions?: has_actions?
    }
  end
end
