require 'rails_helper'

RSpec.describe Ui::DeleteModalComponent, type: :component do
  let(:title) { 'Confirm Deletion' }
  let(:message) { 'Are you sure you want to delete this item?' }
  let(:item_name) { 'Test Document' }
  let(:delete_url) { '/documents/1' }
  let(:cancel_url) { '/documents' }
  let(:component) do
    described_class.new(
      title: title,
      message: message,
      item_name: item_name,
      delete_url: delete_url,
      cancel_url: cancel_url
    )
  end

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#modal_id' do
      it 'returns unique modal ID' do
        id = component.send(:modal_id)
        expect(id).to include('delete-modal-')
        expect(id).to match(/delete-modal-[a-f0-9]{8}/)
      end

      it 'generates different IDs for different instances' do
        id1 = component.send(:modal_id)
        id2 = described_class.new.send(:modal_id)
        expect(id1).not_to eq(id2)
      end
    end

    describe '#modal_classes' do
      it 'returns base modal classes' do
        classes = component.send(:modal_classes)
        expect(classes).to include('modal')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(class: 'custom-modal')
        classes = custom_component.send(:modal_classes)
        expect(classes).to include('custom-modal')
      end
    end

    describe '#danger_button_classes' do
      it 'returns danger button classes' do
        classes = component.send(:danger_button_classes)
        expect(classes).to include('btn')
        expect(classes).to include('btn-danger')
      end
    end

    describe '#cancel_button_classes' do
      it 'returns cancel button classes' do
        classes = component.send(:cancel_button_classes)
        expect(classes).to include('btn')
      end
    end

    describe '#display_message' do
      context 'when item_name is provided' do
        it 'includes item name in message' do
          message = component.send(:display_message)
          expect(message).to include('Test Document')
          expect(message).to include('Are you sure you want to delete this item?')
        end
      end

      context 'when item_name is nil' do
        let(:item_name) { nil }

        it 'returns original message' do
          message = component.send(:display_message)
          expect(message).to eq('Are you sure you want to delete this item?')
        end
      end

      context 'when item_name is empty' do
        let(:item_name) { '' }

        it 'returns original message' do
          message = component.send(:display_message)
          expect(message).to eq('Are you sure you want to delete this item?')
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :modal_id,
          :modal_classes,
          :danger_button_classes,
          :cancel_button_classes,
          :display_message,
          :title,
          :delete_url,
          :cancel_url
        )
      end

      it 'includes SecureRandom object' do
        context = component.send(:template_context)
        expect(context).to include(:SecureRandom)
      end

      it 'includes method references' do
        context = component.send(:template_context)
        expect(context[:modal_id_generator]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders modal with correct structure' do
      render_inline(component)
      expect(page).to have_css('.modal')
    end

    it 'renders modal title' do
      render_inline(component)
      expect(page).to have_content('Confirm Deletion')
    end

    it 'renders modal message' do
      render_inline(component)
      expect(page).to have_content('Are you sure you want to delete this item?')
      expect(page).to have_content('Test Document')
    end

    it 'renders delete button' do
      render_inline(component)
      expect(page).to have_button('Delete')
    end

    it 'renders cancel button' do
      render_inline(component)
      expect(page).to have_link('Cancel', href: '/documents')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.btn.btn-danger')
      expect(page).to have_css('.btn')
    end

    it 'renders with custom title' do
      custom_title = 'Custom Delete Confirmation'
      custom_component = described_class.new(title: custom_title)
      render_inline(custom_component)
      expect(page).to have_content(custom_title)
    end

    it 'renders with custom message' do
      custom_message = 'Custom deletion message'
      custom_component = described_class.new(message: custom_message)
      render_inline(custom_component)
      expect(page).to have_content(custom_message)
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different titles correctly' do
      custom_title = 'Different Title'
      custom_component = described_class.new(title: custom_title)
      context = custom_component.send(:template_context)
      expect(context[:title]).to eq(custom_title)
    end

    it 'handles different messages correctly' do
      custom_message = 'Different message'
      custom_component = described_class.new(message: custom_message)
      context = custom_component.send(:template_context)
      expect(context[:message]).to eq(custom_message)
    end

    it 'handles different item names correctly' do
      custom_item_name = 'Custom Item'
      custom_component = described_class.new(item_name: custom_item_name)
      message = custom_component.send(:display_message)
      expect(message).to include(custom_item_name)
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:modal_id] }.not_to raise_error
      expect { context[:modal_classes] }.not_to raise_error
      expect { context[:danger_button_classes] }.not_to raise_error
      expect { context[:cancel_button_classes] }.not_to raise_error
      expect { context[:display_message] }.not_to raise_error
    end

    it 'integrates with SecureRandom for ID generation' do
      context = component.send(:template_context)
      expect(context[:SecureRandom]).to respond_to(:hex)
    end

    it 'handles URLs correctly' do
      context = component.send(:template_context)
      expect(context[:delete_url]).to eq('/documents/1')
      expect(context[:cancel_url]).to eq('/documents')
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil title gracefully' do
      nil_title_component = described_class.new(title: nil)
      expect { nil_title_component.send(:modal_classes) }.not_to raise_error
    end

    it 'handles nil message gracefully' do
      nil_message_component = described_class.new(message: nil)
      expect { nil_message_component.send(:modal_classes) }.not_to raise_error
    end

    it 'handles nil item_name gracefully' do
      nil_item_component = described_class.new(item_name: nil)
      expect { nil_item_component.send(:display_message) }.not_to raise_error
    end

    it 'handles nil delete_url gracefully' do
      nil_delete_component = described_class.new(delete_url: nil)
      expect { nil_delete_component.send(:modal_classes) }.not_to raise_error
    end

    it 'handles nil cancel_url gracefully' do
      nil_cancel_component = described_class.new(cancel_url: nil)
      expect { nil_cancel_component.send(:modal_classes) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new
      expect { minimal_component.send(:modal_classes) }.not_to raise_error
    end
  end

  # Modal ID Generation Tests
  describe 'Modal ID generation' do
    it 'generates unique IDs for each instance' do
      ids = []
      5.times do
        ids << described_class.new.send(:modal_id)
      end
      expect(ids.uniq.length).to eq(5)
    end

    it 'generates IDs with correct format' do
      id = component.send(:modal_id)
      expect(id).to match(/^delete-modal-[a-f0-9]{8}$/)
    end

    it 'uses SecureRandom for ID generation' do
      allow(SecureRandom).to receive(:hex).with(4).and_return('test1234')
      id = component.send(:modal_id)
      expect(id).to eq('delete-modal-test1234')
    end
  end

  # Message Display Logic Tests
  describe 'Message display logic' do
    context 'with item name' do
      it 'formats message with item name' do
        message = component.send(:display_message)
        expect(message).to include('<strong>Test Document</strong>')
      end
    end

    context 'without item name' do
      let(:item_name) { nil }

      it 'returns original message' do
        message = component.send(:display_message)
        expect(message).to eq('Are you sure you want to delete this item?')
      end
    end

    context 'with empty item name' do
      let(:item_name) { '' }

      it 'returns original message' do
        message = component.send(:display_message)
        expect(message).to eq('Are you sure you want to delete this item?')
      end
    end

    context 'with special characters in item name' do
      let(:item_name) { 'Item with "quotes" & <tags>' }

      it 'handles special characters correctly' do
        message = component.send(:display_message)
        expect(message).to include('Item with "quotes" & <tags>')
      end
    end
  end

  # CSS Classes Tests
  describe 'CSS classes' do
    it 'applies correct modal classes' do
      classes = component.send(:modal_classes)
      expect(classes).to include('modal')
    end

    it 'applies correct danger button classes' do
      classes = component.send(:danger_button_classes)
      expect(classes).to include('btn', 'btn-danger')
    end

    it 'applies correct cancel button classes' do
      classes = component.send(:cancel_button_classes)
      expect(classes).to include('btn')
    end

    it 'includes custom classes from system arguments' do
      custom_component = described_class.new(class: 'custom-class')
      classes = custom_component.send(:modal_classes)
      expect(classes).to include('custom-class')
    end
  end
end
