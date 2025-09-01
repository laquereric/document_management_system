class Activities::TimelineComponent < ApplicationComponent
  def initialize(activities:, **system_arguments)
    @activities = activities
    super(**system_arguments)
  end

  private

  attr_reader :activities

  def action_icon(action)
    case action
    when 'created'
      'plus'
    when 'updated'
      'pencil'
    when 'status_change'
      'arrow-switch'
    when 'deleted'
      'trash'
    else
      'dot'
    end
  end

  def action_color(action)
    case action
    when 'created'
      'success'
    when 'updated'
      'accent'
    when 'status_change'
      'attention'
    when 'deleted'
      'danger'
    else
      'muted'
    end
  end

  # Context methods for the template
  def template_context
    {
      action_icon: method(:action_icon),
      action_color: method(:action_color),
      activities: activities
    }
  end
end
