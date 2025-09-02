class Models::Activities::ActivityItemComponent < ApplicationComponent
  def initialize(activity:, **system_arguments)
    @activity = activity
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :activity, :system_arguments

  def item_classes
    "d-flex align-items-start border-bottom py-2 #{system_arguments[:class]}"
  end

  def action_icon
    case activity.action
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
    case activity.action
    when 'created'
      'created'
    when 'updated'
      'updated'
    when 'status_change'
      "changed status from #{activity.old_status&.name} to #{activity.new_status&.name}"
    when 'tag_added'
      "added tag: #{activity.notes&.gsub('Added tag: ', '')}"
    when 'tag_removed'
      "removed tag: #{activity.notes&.gsub('Removed tag: ', '')}"
    else
      activity.action
    end
  end

  # Context methods for the template
  def template_context
    {
      item_classes: item_classes,
      action_icon: action_icon,
      action_description: action_description,
      activity: activity,
      link_to: method(:link_to),
      time_ago_in_words: method(:time_ago_in_words),
      ActiveRecord: ActiveRecord
    }
  end
end
