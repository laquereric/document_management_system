class Models::Documents::TableComponent < ApplicationComponent
  def initialize(documents:, **system_arguments)
    @documents = documents
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :documents, :system_arguments

  def table_classes
    "Table Table--full-width #{system_arguments[:class]}"
  end

  # Context methods for the template
  def template_context
    {
      table_classes: table_classes,
      documents: documents,
      truncate: method(:truncate),
      time_ago_in_words: method(:time_ago_in_words),
      render: method(:render)
    }
  end
end
