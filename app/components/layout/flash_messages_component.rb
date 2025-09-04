class Layout::FlashMessagesComponent < ApplicationComponent
  def initialize(flash_hash:, **system_arguments)
    @flash_hash = flash_hash
    @system_arguments = system_arguments
  end

  private

  attr_reader :flash_hash

  def flash_messages
    return [] if flash_hash.blank?

    flash_hash.filter_map do |type, message|
      next if message.blank?

      {
        type: normalize_flash_type(type),
        message: message
      }
    end
  end

  def normalize_flash_type(type)
    case type.to_s
    when 'notice', 'success'
      :success
    when 'alert', 'error'
      :danger
    when 'warning'
      :warning
    else
      :default
    end
  end
end
