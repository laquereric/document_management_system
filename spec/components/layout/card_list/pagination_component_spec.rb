require 'rails_helper'

RSpec.describe Layout::CardList::PaginationComponent, type: :component do
  let(:collection) { double('collection') }
  let(:component) { described_class.new(collection: collection) }

  describe '#render?' do
    context 'when collection supports pagination and has multiple pages' do
      before do
        allow(collection).to receive(:respond_to?).with(:current_page).and_return(true)
        allow(collection).to receive(:total_pages).and_return(5)
      end

      it 'returns true' do
        expect(component.send(:render?)).to be true
      end
    end

    context 'when collection does not support pagination' do
      before do
        allow(collection).to receive(:respond_to?).with(:current_page).and_return(false)
      end

      it 'returns false' do
        expect(component.send(:render?)).to be false
      end
    end

    context 'when collection has only one page' do
      before do
        allow(collection).to receive(:respond_to?).with(:current_page).and_return(true)
        allow(collection).to receive(:total_pages).and_return(1)
      end

      it 'returns false' do
        expect(component.send(:render?)).to be false
      end
    end
  end

  describe '#pagination_options' do
    it 'returns the expected pagination options' do
      expected_options = {
        theme: 'bootstrap',
        window: 2,
        left: 1,
        right: 1,
        gap: true
      }

      expect(component.send(:pagination_options)).to eq(expected_options)
    end
  end

  describe 'rendering' do
    context 'when pagination should be rendered' do
      before do
        allow(collection).to receive(:respond_to?).with(:current_page).and_return(true)
        allow(collection).to receive(:total_pages).and_return(5)
        allow(component).to receive(:helpers).and_return(double('helpers'))
        allow(component.helpers).to receive(:paginate)
      end

      it 'renders the pagination component' do
        render_inline(component)
        expect(page).to have_css('.d-flex.flex-justify-center.mt-4')
      end
    end

    context 'when pagination should not be rendered' do
      before do
        allow(collection).to receive(:respond_to?).with(:current_page).and_return(false)
      end

      it 'does not render the pagination component' do
        render_inline(component)
        expect(page).not_to have_css('.d-flex.flex-justify-center.mt-4')
      end
    end
  end
end
