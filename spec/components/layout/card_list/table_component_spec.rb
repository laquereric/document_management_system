require 'rails_helper'

RSpec.describe Layout::CardList::TableComponent, type: :component do
  let(:documents) do
    [
      double('document1', 
        title: 'Document 1', 
        author: double('author1', name: 'Author 1', email: 'author1@example.com'),
        folder: double('folder1', name: 'Folder 1'),
        status: double('status1', name: 'active'),
        content: 'Content 1',
        created_at: 1.day.ago, 
        updated_at: 1.hour.ago
      ),
      double('document2', 
        title: 'Document 2', 
        author: double('author2', name: 'Author 2', email: 'author2@example.com'),
        folder: double('folder2', name: 'Folder 2'),
        status: double('status2', name: 'draft'),
        content: 'Content 2',
        created_at: 2.days.ago, 
        updated_at: 2.hours.ago
      )
    ]
  end
  let(:component) { described_class.new(documents: documents) }

  before do
    allow(component).to receive(:helpers).and_return(double('helpers'))
    allow(component.helpers).to receive(:truncate)
    allow(component.helpers).to receive(:time_ago_in_words)
    allow(component.helpers).to receive(:render)
    
    # Mock the actions menu component to avoid rendering issues
    allow(component).to receive(:render).and_return('')
  end

  describe '#table_classes' do
    it 'returns table classes with system arguments' do
      component = described_class.new(documents: documents, class: 'custom-class')
      expect(component.send(:table_classes)).to include('Table Table--full-width custom-class')
    end

    it 'returns default table classes without system arguments' do
      expect(component.send(:table_classes)).to eq('Table Table--full-width ')
    end
  end

  describe 'rendering' do
    it 'renders the table component' do
      render_inline(component)
      expect(page).to have_css('.Table')
    end
  end
end
