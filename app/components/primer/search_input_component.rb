class Primer::SearchInputComponent < ApplicationComponent
  def initialize(
    placeholder: "Search...",
    value: nil,
    url: nil,
    size: :medium,
    loading: false,
    **system_arguments
  )
    @placeholder = placeholder
    @value = value
    @url = url || search_path
    @size = size
    @loading = loading
    @system_arguments = system_arguments.dup
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      "position-relative",
      system_arguments[:classes]
    )
  end

  private

  attr_reader :placeholder, :value, :url, :size, :loading

  def render_search_form
    form_with(
      url: url,
      method: :get,
      local: true,
      class: "d-flex",
      data: { 
        turbo_frame: "search-results",
        controller: "search",
        search_url_value: url
      }
    ) do |form|
      render_input_group(form)
    end
  end

  def render_input_group(form)
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "input-group"
    )) do
      safe_join([
        render_search_input(form),
        render_search_button
      ])
    end
  end

  def render_search_input(form)
    form.text_field(
      :q,
      value: value,
      placeholder: placeholder,
      class: input_classes,
      data: {
        action: "input->search:query",
        search_target: "input"
      }
    )
  end

  def render_search_button
    render(Primer::ButtonComponent.new(
      scheme: :outline,
      size: button_size,
      icon: :search,
      type: "submit",
      classes: "input-group-button"
    ))
  end

  def render_results_dropdown
    render(Primer::BaseComponent.new(
      tag: :div,
      classes: "position-absolute top-100 left-0 right-0 mt-1 d-none z-1",
      data: { search_target: "results" }
    )) do
      render(Primer::CardComponent.new(classes: "Box-overlay")) do
        safe_join([
          render_results_header,
          render_results_body,
          render_results_footer
        ])
      end
    end
  end

  def render_results_header
    render(Primer::CardComponent.new(classes: "Box-header")) do
      content_tag(:h3, "Quick Results", class: "f5 text-semibold")
    end
  end

  def render_results_body
    content_tag(:div, class: "Box-body", data: { search_target: "resultsContent" }) do
      render_loading_state
    end
  end

  def render_loading_state
    content_tag(:div, class: "text-center py-3") do
      safe_join([
        render(Primer::Beta::Octicon.new(
          icon: :search,
          size: :medium,
          color: :muted,
          mb: 2
        )),
        content_tag(:p, "Start typing to search...", class: "color-fg-muted f6")
      ])
    end
  end

  def render_results_footer
    render(Primer::CardComponent.new(classes: "Box-footer")) do
      render(Primer::ButtonComponent.new(
        href: url,
        size: :small,
        scheme: :invisible
      )) do
        "View all results"
      end
    end
  end

  def input_classes
    base_classes = "FormControl-input"
    size_classes = case size
                  when :small
                    "FormControl-small"
                  when :large
                    "FormControl-large"
                  else
                    ""
                  end
    
    class_names(base_classes, size_classes)
  end

  def button_size
    case size
    when :small
      :small
    when :large
      :large
    else
      :medium
    end
  end

  def search_path
    Rails.application.routes.url_helpers.search_index_path
  rescue
    "/search"
  end
end
