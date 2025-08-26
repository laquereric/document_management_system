class ActivityLogs::ActivityLogItemComponent < ApplicationComponent
  def initialize(activity_log:, **system_arguments)
    @activity_log = activity_log
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activity_log, :system_arguments

  def item_classes
    "d-flex align-items-start border-bottom py-2 #{system_arguments[:class]}"
  end

  def action_icon
    case activity_log.action
    when 'created'
      'bi-plus-circle-fill text-success'
    when 'updated'
      'bi-pencil-fill text-primary'
    when 'status_change'
      'bi-arrow-repeat text-warning'
    when 'tag_added'
      'bi-tag-fill text-info'
    when 'tag_removed'
      'bi-tag text-secondary'
    else
      'bi-circle-fill text-primary'
    end
  end

  def action_description
    case activity_log.action
    when 'created'
      'created'
    when 'updated'
      'updated'
    when 'status_change'
      "changed status from #{activity_log.old_status&.name} to #{activity_log.new_status&.name}"
    when 'tag_added'
      "added tag: #{activity_log.notes&.gsub('Added tag: ', '')}"
    when 'tag_removed'
      "removed tag: #{activity_log.notes&.gsub('Removed tag: ', '')}"
    else
      activity_log.action
    end
  end
end
