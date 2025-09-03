class Layout::CardList::DocumentGrid < ApplicationComponent
  def initialize(documents:, **system_arguments)
    @documents = documents
    super(**system_arguments)
  end

  private

  attr_reader :documents

  def container_classes
    "d-flex flex-wrap gap-3"
  end

  def item_classes
    "flex-auto"
  end

  def item_styles
    "min-width: 300px; max-width: 400px;"
  end
end
