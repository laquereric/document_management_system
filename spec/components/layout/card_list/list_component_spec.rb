require 'rails_helper'

RSpec.describe Layout::CardList::ListComponent, type: :component do
  let(:documents) { [ double('document1'), double('document2') ] }
  let(:component) { described_class.new(documents: documents, layout: :list, show_filters: true, show_sorting: true) }

  before do
    allow(component).to receive(:helpers).and_return(double('helpers'))
    allow(component.helpers).to receive(:form_with)
    allow(component.helpers).to receive(:documents_path).and_return('/documents')
    allow(component.helpers).to receive(:params).and_return({})
    allow(component.helpers).to receive(:options_for_select)

    # Mock the filter panel component to avoid rendering issues
    allow(component).to receive(:render).and_return('')
  end

  describe '#container_classes' do
    context 'when layout is grid' do
      let(:component) { described_class.new(documents: documents, layout: :grid) }

      it 'returns grid classes' do
        expect(component.send(:container_classes)).to include('d-grid')
      end
    end

    context 'when layout is list' do
      let(:component) { described_class.new(documents: documents, layout: :list) }

      it 'returns list classes' do
        expect(component.send(:container_classes)).to include('d-flex flex-column gap-3')
      end
    end

    context 'when layout is table' do
      let(:component) { described_class.new(documents: documents, layout: :table) }

      it 'returns empty string' do
        expect(component.send(:container_classes)).to eq('')
      end
    end
  end

  describe '#sort_options' do
    it 'returns sort options with current sort marked as selected' do
      component = described_class.new(documents: documents, current_sort: :created_at)
      options = component.send(:sort_options)

      expect(options).to be_an(Array)
      expect(options.find { |opt| opt[:value] == :created_at }[:selected]).to be true
    end
  end

  describe '#layout_options' do
    it 'returns layout options with current layout marked as active' do
      component = described_class.new(documents: documents, layout: :grid)
      options = component.send(:layout_options)

      expect(options).to be_an(Array)
      expect(options.find { |opt| opt[:value] == :grid }[:active]).to be true
    end
  end

  describe 'rendering' do
    it 'renders the list component' do
      render_inline(component)
      expect(page).to have_css('.document-list')
    end
  end
end
