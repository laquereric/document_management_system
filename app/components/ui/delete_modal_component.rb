class Ui::DeleteModalComponent < ApplicationComponent
  def initialize(
    title: "Confirm Deletion",
    message: "Are you sure you want to delete this item?",
    item_name: nil,
    delete_url: nil,
    cancel_url: nil,
    **system_arguments
  )
    @title = title
    @message = message
    @item_name = item_name
    @delete_url = delete_url
    @cancel_url = cancel_url
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :title, :message, :item_name, :delete_url, :cancel_url, :system_arguments

  def modal_id
    "delete-modal-#{SecureRandom.hex(4)}"
  end

  def modal_classes
    "modal #{system_arguments[:class]}"
  end

  def danger_button_classes
    "btn btn-danger"
  end

  def cancel_button_classes
    "btn"
  end

  def display_message
    if item_name
      "#{message} <strong>#{item_name}</strong>?"
    else
      message
    end
  end
end
