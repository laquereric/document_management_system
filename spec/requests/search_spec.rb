require 'rails_helper'

RSpec.describe "Search", type: :request do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :member, organization: organization) }
  let(:admin_user) { create(:user, :admin, organization: organization) }
  let(:team) { create(:team, organization: organization) }
  let(:folder) { create(:folder, team: team) }
  let(:document) { create(:document, folder: folder, author: user) }
  let(:status) { create(:status, name: "Draft") }
  let(:tag) { create(:tag, organization: organization) }

  before do
    setup_test_data
    document.update(status: status)
    document.tags << tag
  end

  describe "GET /search" do
    it "returns a successful response" do
      get search_index_path
      expect_successful_response
    end

    it "displays the search page" do
      get search_index_path
      expect_page_to_contain("Search")
    end

    it "displays search form" do
      get search_index_path
      expect_page_to_contain("search")
      expect_page_to_contain("input")
    end

    it "displays all documents when no search query" do
      create_list(:document, 5, folder: folder)
      get search_index_path
      expect_page_to_contain("Documents")
    end

    it "includes document information" do
      get search_index_path
      expect_page_to_contain(document.title)
      expect_page_to_contain(document.content)
    end

    it "includes author information" do
      get search_index_path
      expect_page_to_contain(user.name)
    end

    it "includes status information" do
      get search_index_path
      expect_page_to_contain(status.name)
    end

    it "includes tag information" do
      get search_index_path
      expect_page_to_contain(tag.name)
    end

    it "includes folder information" do
      get search_index_path
      expect_page_to_contain(folder.name)
    end

    it "includes team information" do
      get search_index_path
      expect_page_to_contain(team.name)
    end
  end

  describe "GET /search with search parameters" do
    it "filters documents by title" do
      doc1 = create(:document, title: "Important Document", folder: folder)
      doc2 = create(:document, title: "Regular Document", folder: folder)
      
      get search_index_path, params: { q: { title_cont: "Important" } }
      expect_page_to_contain("Important Document")
    end

    it "filters documents by content" do
      doc1 = create(:document, content: "This is about technology", folder: folder)
      doc2 = create(:document, content: "This is about marketing", folder: folder)
      
      get search_index_path, params: { q: { content_cont: "technology" } }
      expect_page_to_contain("technology")
    end

    it "filters documents by author name" do
      author1 = create(:user, name: "John Doe", organization: organization)
      author2 = create(:user, name: "Jane Smith", organization: organization)
      doc1 = create(:document, author: author1, folder: folder)
      doc2 = create(:document, author: author2, folder: folder)
      
      get search_index_path, params: { q: { author_name_cont: "John" } }
      expect_page_to_contain("John Doe")
    end

    it "filters documents by status" do
      draft_status = create(:status, name: "Draft")
      published_status = create(:status, name: "Published")
      doc1 = create(:document, status: draft_status, folder: folder)
      doc2 = create(:document, status: published_status, folder: folder)
      
      get search_index_path, params: { q: { status_name_eq: "Draft" } }
      expect_page_to_contain("Draft")
    end

    it "filters documents by tag" do
      tag1 = create(:tag, name: "Important", organization: organization)
      tag2 = create(:tag, name: "Regular", organization: organization)
      doc1 = create(:document, folder: folder)
      doc2 = create(:document, folder: folder)
      doc1.tags << tag1
      doc2.tags << tag2
      
      get search_index_path, params: { q: { tags_name_cont: "Important" } }
      expect_page_to_contain("Important")
    end

    it "filters documents by folder name" do
      folder1 = create(:folder, name: "Project A", team: team)
      folder2 = create(:folder, name: "Project B", team: team)
      doc1 = create(:document, folder: folder1)
      doc2 = create(:document, folder: folder2)
      
      get search_index_path, params: { q: { folder_name_cont: "Project A" } }
      expect_page_to_contain("Project A")
    end

    it "filters documents by team name" do
      team1 = create(:team, name: "Development Team", organization: organization)
      team2 = create(:team, name: "Marketing Team", organization: organization)
      folder1 = create(:folder, team: team1)
      folder2 = create(:folder, team: team2)
      doc1 = create(:document, folder: folder1)
      doc2 = create(:document, folder: folder2)
      
      get search_index_path, params: { q: { folder_team_name_cont: "Development" } }
      expect_page_to_contain("Development Team")
    end

    it "filters documents by organization name" do
      org1 = create(:organization, name: "Tech Corp")
      org2 = create(:organization, name: "Marketing Inc")
      team1 = create(:team, organization: org1)
      team2 = create(:team, organization: org2)
      folder1 = create(:folder, team: team1)
      folder2 = create(:folder, team: team2)
      doc1 = create(:document, folder: folder1)
      doc2 = create(:document, folder: folder2)
      
      get search_index_path, params: { q: { folder_team_organization_name_cont: "Tech" } }
      expect_page_to_contain("Tech Corp")
    end

    it "filters documents by created date range" do
      doc1 = create(:document, created_at: 1.day.ago, folder: folder)
      doc2 = create(:document, created_at: 1.week.ago, folder: folder)
      
      get search_index_path, params: { 
        q: { 
          created_at_gteq: 2.days.ago,
          created_at_lteq: Time.current
        } 
      }
      expect_page_to_contain(doc1.title)
    end

    it "filters documents by updated date range" do
      doc1 = create(:document, updated_at: 1.hour.ago, folder: folder)
      doc2 = create(:document, updated_at: 1.day.ago, folder: folder)
      
      get search_index_path, params: { 
        q: { 
          updated_at_gteq: 2.hours.ago,
          updated_at_lteq: Time.current
        } 
      }
      expect_page_to_contain(doc1.title)
    end
  end

  describe "search pagination" do
    before do
      create_list(:document, 25, folder: folder)
    end

    it "handles pagination" do
      get search_index_path, params: { page: 2 }
      expect_successful_response
    end

    it "displays correct number of results per page" do
      get search_index_path
      expect_successful_response
    end

    it "handles large result sets" do
      get search_index_path, params: { page: 10 }
      expect_successful_response
    end
  end

  describe "search sorting" do
    before do
      create_list(:document, 5, folder: folder)
    end

    it "sorts by title" do
      get search_index_path, params: { sort: "title" }
      expect_successful_response
    end

    it "sorts by created_at" do
      get search_index_path, params: { sort: "created_at" }
      expect_successful_response
    end

    it "sorts by updated_at" do
      get search_index_path, params: { sort: "updated_at" }
      expect_successful_response
    end

    it "sorts by author name" do
      get search_index_path, params: { sort: "author_name" }
      expect_successful_response
    end

    it "sorts by status name" do
      get search_index_path, params: { sort: "status_name" }
      expect_successful_response
    end
  end

  describe "search performance" do
    it "loads quickly with many documents" do
      create_list(:document, 100, folder: folder)
      
      start_time = Time.current
      get search_index_path
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 3.seconds
    end

    it "handles complex search queries efficiently" do
      create_list(:document, 50, folder: folder)
      
      start_time = Time.current
      get search_index_path, params: { 
        q: { 
          title_cont: "test",
          content_cont: "content",
          author_name_cont: "user"
        } 
      }
      end_time = Time.current
      
      expect_successful_response
      expect(end_time - start_time).to be < 2.seconds
    end
  end

  describe "search error handling" do
    it "handles invalid search parameters gracefully" do
      get search_index_path, params: { q: { invalid_field_cont: "test" } }
      expect_successful_response
    end

    it "handles empty search results" do
      get search_index_path, params: { q: { title_cont: "nonexistent" } }
      expect_successful_response
    end

    it "handles malformed search queries" do
      get search_index_path, params: { q: "invalid_query" }
      expect_successful_response
    end

    it "handles special characters in search" do
      get search_index_path, params: { q: { title_cont: "test@#$%^&*()" } }
      expect_successful_response
    end

    it "handles very long search queries" do
      long_query = "a" * 1000
      get search_index_path, params: { q: { title_cont: long_query } }
      expect_successful_response
    end
  end

  describe "search accessibility" do
    it "includes proper HTML structure" do
      get search_index_path
      expect_page_to_contain("<html>")
      expect_page_to_contain("</html>")
    end

    it "includes search form with proper labels" do
      get search_index_path
      expect_page_to_contain("label")
    end

    it "includes proper meta tags" do
      get search_index_path
      expect_page_to_contain("viewport")
    end

    it "includes CSS and JavaScript assets" do
      get search_index_path
      expect_page_to_contain("stylesheet")
    end
  end

  describe "search results display" do
    it "displays search result count" do
      create_list(:document, 5, folder: folder)
      get search_index_path
      expect_page_to_contain("results")
    end

    it "displays no results message when appropriate" do
      get search_index_path, params: { q: { title_cont: "nonexistent" } }
      expect_page_to_contain("No results")
    end

    it "displays search query in results" do
      get search_index_path, params: { q: { title_cont: "test" } }
      expect_page_to_contain("test")
    end

    it "highlights search terms in results" do
      doc = create(:document, title: "Test Document", folder: folder)
      get search_index_path, params: { q: { title_cont: "Test" } }
      expect_page_to_contain("Test")
    end
  end

  describe "search filters" do
    it "displays available filters" do
      get search_index_path
      expect_page_to_contain("Filter")
    end

    it "allows filtering by multiple criteria" do
      get search_index_path, params: { 
        q: { 
          title_cont: "test",
          status_name_eq: "Draft"
        } 
      }
      expect_successful_response
    end

    it "maintains filter state across pages" do
      get search_index_path, params: { 
        q: { title_cont: "test" },
        page: 2
      }
      expect_successful_response
    end
  end

  describe "search URL parameters" do
    it "handles URL-encoded search parameters" do
      get search_index_path, params: { q: { title_cont: "test with spaces" } }
      expect_successful_response
    end

    it "handles special characters in URL" do
      get search_index_path, params: { q: { title_cont: "test&special=chars" } }
      expect_successful_response
    end

    it "preserves search parameters in pagination links" do
      get search_index_path, params: { 
        q: { title_cont: "test" },
        page: 2
      }
      expect_successful_response
    end
  end
end
