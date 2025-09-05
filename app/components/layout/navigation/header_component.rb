class Layout::Navigation::HeaderComponent < ApplicationComponent
  def initialize(current_user: nil, title: nil, **system_arguments)
    @current_user = current_user
    @title = title
    @system_arguments = merge_system_arguments(system_arguments)
  end

  private

  attr_reader :current_user, :title, :system_arguments
end
