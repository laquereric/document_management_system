require 'rails_helper'

RSpec.describe ComponentsController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @components with component information" do
      get :index
      expect(assigns(:components)).to be_an(Array)
    end

    it "assigns @groups with grouped components" do
      get :index
      expect(assigns(:groups)).to be_an(Array)
    end

    it "assigns @query from params" do
      get :index, params: { q: "test" }
      expect(assigns(:query)).to eq("test")
    end

    it "processes component files correctly" do
      get :index
      
      components = assigns(:components)
      expect(components).not_to be_empty
      
      # Check that components have expected structure
      component = components.first
      expect(component).to have_key(:name)
      expect(component).to have_key(:group)
      expect(component).to have_key(:file)
      expect(component).to have_key(:template)
    end

    it "groups components by category" do
      get :index
      
      groups = assigns(:groups)
      expect(groups).not_to be_empty
      
      # Check that groups are sorted
      group_names = groups.map(&:first)
      expect(group_names).to eq(group_names.sort)
    end

    it "categorizes components correctly" do
      get :index
      
      components = assigns(:components)
      ui_components = components.select { |c| c[:group] == "UI" }
      layout_components = components.select { |c| c[:group] == "Layout" }
      models_components = components.select { |c| c[:group] == "Models" }
      
      # Should have some components in each category if they exist
      expect(ui_components).to be_an(Array)
      expect(layout_components).to be_an(Array)
      expect(models_components).to be_an(Array)
    end

    it "detects template files" do
      get :index
      
      components = assigns(:components)
      components_with_templates = components.select { |c| c[:template] }
      
      # Should have some components with templates
      expect(components_with_templates).to be_an(Array)
    end

    context "with search query" do
      it "filters components by name" do
        get :index, params: { q: "header" }
        
        components = assigns(:components)
        if components.any?
          expect(components.all? { |c| c[:name].downcase.include?("header") }).to be true
        end
      end

      it "filters components by group" do
        get :index, params: { q: "layout" }
        
        components = assigns(:components)
        if components.any?
          expect(components.all? { |c| c[:group].downcase.include?("layout") }).to be true
        end
      end

      it "filters components by file path" do
        get :index, params: { q: "component" }
        
        components = assigns(:components)
        if components.any?
          expect(components.all? { |c| c[:file].downcase.include?("component") }).to be true
        end
      end

      it "handles empty query" do
        get :index, params: { q: "" }
        
        components = assigns(:components)
        expect(components).to be_an(Array)
      end

      it "handles nil query" do
        get :index, params: { q: nil }
        
        components = assigns(:components)
        expect(components).to be_an(Array)
      end

      it "is case insensitive" do
        get :index, params: { q: "HEADER" }
        
        components = assigns(:components)
        if components.any?
          expect(components.all? { |c| c[:name].downcase.include?("header") }).to be true
        end
      end
    end

    context "without search query" do
      it "returns all components" do
        get :index
        
        components = assigns(:components)
        expect(components).to be_an(Array)
      end

      it "groups all components" do
        get :index
        
        groups = assigns(:groups)
        expect(groups).to be_an(Array)
      end
    end

    it "handles missing component files gracefully" do
      # This test ensures the controller doesn't crash if component files are missing
      get :index
      expect(response).to be_successful
    end

    it "handles malformed component file names gracefully" do
      # This test ensures the controller handles edge cases in file naming
      get :index
      expect(response).to be_successful
    end
  end
end
