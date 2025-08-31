class Layout::CardComponent < ApplicationComponent
  include CardConcerns

  def initialize(show_actions: true, **system_arguments)
    initialize_card_base(show_actions: show_actions, **system_arguments)
  end

  private

  def card_classes
    base_card_classes
  end
end
