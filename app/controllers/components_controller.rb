class ComponentsController < ApplicationController
  def index
    @query = params[:q].to_s.strip.downcase

    component_files = Dir.glob(Rails.root.join("app", "components", "**", "*_component.rb"))

    @components = component_files.map do |path|
      rel_path = Pathname.new(path).relative_path_from(Rails.root).to_s
      name_parts = rel_path.sub("app/components/", "").sub(".rb", "").split("/")
      class_name = name_parts.map { |p| p.camelize }.join("::").sub("::", "::")

      group = case name_parts.first
              when "ui" then "UI"
              when "layout" then "Layout"
              when "models" then "Models"
              when "primer" then "Primer"
              when "forms" then "Forms"
              when "user" then "User"
              else "Other"
              end

      template_path = rel_path.sub(".rb", ".html.erb")
      has_template = File.exist?(Rails.root.join(template_path))

      { name: class_name, group: group, file: rel_path, template: has_template ? template_path : nil }
    end

    if @query.present?
      @components.select! do |c|
        [c[:name], c[:group], c[:file]].any? { |v| v.to_s.downcase.include?(@query) }
      end
    end

    @groups = @components.group_by { |c| c[:group] }.sort_by { |g, _| g }
  end
end
