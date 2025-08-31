class ActivityLogs::TimelineComponent < ApplicationComponent
  def initialize(activity_logs:, **system_arguments)
    @activity_logs = activity_logs
    super(**system_arguments)
  end

  private

  attr_reader :activity_logs

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
end
