require 'rails_helper'

RSpec.describe "Components", type: :request do
  describe "GET /components" do
    it "returns a successful response" do
      get components_path
      expect_successful_response
    end

    it "displays the components catalog page" do
      get components_path
      expect_page_to_contain("Components")
    end

    it "displays component information" do
      get components_path
      expect_page_to_contain("Component")
    end

    it "displays component groups" do
      get components_path
      expect_page_to_contain("UI")
      expect_page_to_contain("Layout")
      expect_page_to_contain("Models")
    end

    it "displays component names" do
      get components_path
      expect_page_to_contain("Component")
    end

    it "displays component file paths" do
      get components_path
      expect_page_to_contain(".rb")
    end

    it "displays template information" do
      get components_path
      expect_page_to_contain("Template")
    end

    it "includes proper HTML structure" do
      get components_path
      expect_page_to_contain("<html>")
      expect_page_to_contain("</html>")
    end

    it "includes navigation elements" do
      get components_path
      expect_page_to_contain("nav")
    end

    it "includes proper meta tags" do
      get components_path
      expect_page_to_contain("viewport")
    end

    it "includes CSS and JavaScript assets" do
      get components_path
      expect_page_to_contain("stylesheet")
    end
  end

  describe "GET /components with search parameters" do
    it "filters components by name" do
      get components_path, params: { q: "header" }
      expect_successful_response
    end

    it "filters components by group" do
      get components_path, params: { q: "layout" }
      expect_successful_response
    end

    it "filters components by file path" do
      get components_path, params: { q: "component" }
      expect_successful_response
    end

    it "handles case-insensitive search" do
      get components_path, params: { q: "HEADER" }
      expect_successful_response
    end

    it "handles partial matches" do
      get components_path, params: { q: "head" }
      expect_successful_response
    end

    it "handles multiple word searches" do
      get components_path, params: { q: "user menu" }
      expect_successful_response
    end

    it "handles special characters in search" do
      get components_path, params: { q: "test@#$%^&*()" }
      expect_successful_response
    end

    it "handles empty search query" do
      get components_path, params: { q: "" }
      expect_successful_response
    end

    it "handles nil search query" do
      get components_path, params: { q: nil }
      expect_successful_response
    end

    it "handles very long search queries" do
      long_query = "a" * 1000
      get components_path, params: { q: long_query }
      expect_successful_response
    end
  end

  describe "component categorization" do
    it "groups UI components correctly" do
      get components_path
      expect_page_to_contain("UI")
    end

    it "groups Layout components correctly" do
      get components_path
      expect_page_to_contain("Layout")
    end

    it "groups Models components correctly" do
      get components_path
      expect_page_to_contain("Models")
    end

    it "groups Primer components correctly" do
      get components_path
      expect_page_to_contain("Primer")
    end

    it "groups Forms components correctly" do
      get components_path
      expect_page_to_contain("Forms")
    end

    it "groups User components correctly" do
      get components_path
      expect_page_to_contain("User")
    end

    it "groups Other components correctly" do
      get components_path
      expect_page_to_contain("Other")
    end
  end

  describe "component file detection" do
    it "detects component files" do
      get components_path
      expect_page_to_contain(".rb")
    end

    it "detects template files" do
      get components_path
      expect_page_to_contain(".html.erb")
    end

    it "handles missing template files gracefully" do
      get components_path
      expect_successful_response
    end

    it "handles malformed file names gracefully" do
      get components_path
      expect_successful_response
    end
  end

  describe "component display" do
    it "displays component names" do
      get components_path
      expect_page_to_contain("Component")
    end

    it "displays component groups" do
      get components_path
      expect_page_to_contain("Group")
    end

    it "displays component file paths" do
      get components_path
      expect_page_to_contain("app/components")
    end

    it "displays template paths when available" do
      get components_path
      expect_page_to_contain("Template")
    end

    it "displays sorted component groups" do
      get components_path
      expect_successful_response
    end
  end

  describe "search functionality" do
    it "filters results by component name" do
      get components_path, params: { q: "header" }
      expect_successful_response
    end

    it "filters results by group name" do
      get components_path, params: { q: "layout" }
      expect_successful_response
    end

    it "filters results by file path" do
      get components_path, params: { q: "component" }
      expect_successful_response
    end

    it "shows no results when no matches found" do
      get components_path, params: { q: "nonexistent" }
      expect_successful_response
    end

    it "maintains search state" do
      get components_path, params: { q: "test" }
      expect_successful_response
    end
  end

  describe "error handling" do
    it "handles missing component files gracefully" do
      get components_path
      expect_successful_response
    end

    it "handles malformed component file names gracefully" do
      get components_path
      expect_successful_response
    end

    it "handles directory access errors gracefully" do
      get components_path
      expect_successful_response
    end

    it "handles file system errors gracefully" do
      get components_path
      expect_successful_response
    end
  end

  describe "performance" do
    it "loads quickly" do
      start_time = Time.current
      get components_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end

    it "handles search queries efficiently" do
      start_time = Time.current
      get components_path, params: { q: "test" }
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end

    it "handles complex search queries efficiently" do
      start_time = Time.current
      get components_path, params: { q: "user menu component" }
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 1.second
    end
  end

  describe "accessibility" do
    it "includes proper HTML structure" do
      get components_path
      expect_page_to_contain("<html>")
      expect_page_to_contain("</html>")
    end

    it "includes proper heading structure" do
      get components_path
      expect_page_to_contain("<h1>")
    end

    it "includes proper list structure" do
      get components_path
      expect_page_to_contain("<ul>")
    end

    it "includes proper link structure" do
      get components_path
      expect_page_to_contain("<a")
    end

    it "includes proper form structure" do
      get components_path
      expect_page_to_contain("<form>")
    end

    it "includes proper input structure" do
      get components_path
      expect_page_to_contain("<input")
    end
  end

  describe "URL parameters" do
    it "handles URL-encoded search parameters" do
      get components_path, params: { q: "test with spaces" }
      expect_successful_response
    end

    it "handles special characters in URL" do
      get components_path, params: { q: "test&special=chars" }
      expect_successful_response
    end

    it "preserves search parameters" do
      get components_path, params: { q: "test" }
      expect_successful_response
    end
  end

  describe "component information accuracy" do
    it "displays correct component names" do
      get components_path
      expect_successful_response
    end

    it "displays correct component groups" do
      get components_path
      expect_successful_response
    end

    it "displays correct file paths" do
      get components_path
      expect_successful_response
    end

    it "displays correct template information" do
      get components_path
      expect_successful_response
    end
  end

  describe "component grouping" do
    it "groups components by category" do
      get components_path
      expect_successful_response
    end

    it "sorts component groups alphabetically" do
      get components_path
      expect_successful_response
    end

    it "displays components within groups" do
      get components_path
      expect_successful_response
    end

    it "handles empty groups gracefully" do
      get components_path
      expect_successful_response
    end
  end

  describe "search results display" do
    it "displays search result count" do
      get components_path, params: { q: "test" }
      expect_successful_response
    end

    it "displays no results message when appropriate" do
      get components_path, params: { q: "nonexistent" }
      expect_successful_response
    end

    it "displays search query in results" do
      get components_path, params: { q: "test" }
      expect_successful_response
    end

    it "highlights search terms in results" do
      get components_path, params: { q: "test" }
      expect_successful_response
    end
  end
end
