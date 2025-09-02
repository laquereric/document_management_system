require 'rails_helper'

RSpec.describe Layout::CardList::SearchFilterSort::SearchAndFiltersComponent, type: :component do
  let(:search_object) { double('search_object') }
  let(:url) { '/test' }
  let(:title) { "Search & Filters" }
  let(:fields) { [{ name: :name_cont, label: "Name" }] }
  let(:component) { described_class.new(search_object: search_object, url: url, title: title, fields: fields) }

  before do
    allow(component).to receive(:helpers).and_return(double('helpers'))
    allow(component.helpers).to receive(:search_form_for)
    allow(component.helpers).to receive(:options_for_select)
    allow(component.helpers).to receive(:link_to)
  end

  describe '#render?' do
    context 'when fields are present' do
      it 'returns true' do
        expect(component.send(:render?)).to be true
      end
    end

    context 'when fields are empty' do
      let(:fields) { [] }

      it 'returns false' do
        expect(component.send(:render?)).to be false
      end
    end
  end

  describe '#has_search_params?' do
    context 'when search object has conditions with values' do
      before do
        allow(search_object).to receive(:conditions).and_return([
          { values: ['test'] }
        ])
      end

      it 'returns true' do
        expect(component.send(:has_search_params?)).to be true
      end
    end

    context 'when search object has no conditions' do
      before do
        allow(search_object).to receive(:conditions).and_return([])
      end

      it 'returns false' do
        expect(component.send(:has_search_params?)).to be false
      end
    end

    context 'when search object is nil' do
      let(:search_object) { nil }

      it 'returns false' do
        expect(component.send(:has_search_params?)).to be false
      end
    end
  end

  describe 'rendering' do
    before do
      allow(search_object).to receive(:conditions).and_return([])
    end

    it 'renders the search and filters component' do
      render_inline(component)
      expect(page).to have_css('.Box')
      expect(page).to have_text(title)
    end
  end
end
