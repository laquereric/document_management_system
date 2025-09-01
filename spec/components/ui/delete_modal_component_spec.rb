require 'rails_helper'

RSpec.describe Ui::DeleteModalComponent, type: :component do
  let(:title) { 'Delete Document' }
  let(:message) { 'Are you sure you want to delete this document?' }
  let(:delete_url) { '/documents/1' }
  let(:cancel_url) { '/documents' }

  before do
    render_inline(described_class.new(
      title: title,
      message: message,
      delete_url: delete_url,
      cancel_url: cancel_url
    ))
  end

  describe '#template_context' do
    let(:component) { described_class.new(
      title: title,
      message: message,
      delete_url: delete_url,
      cancel_url: cancel_url
    ) }

    it 'returns a hash with modal configuration' do
      context = component.template_context
      expect(context).to have_key(:modal_id)
      expect(context).to have_key(:modal_classes)
      expect(context).to have_key(:title)
      expect(context).to have_key(:display_message)
    end

    it 'returns a hash with button classes' do
      context = component.template_context
      expect(context).to have_key(:danger_button_classes)
      expect(context).to have_key(:cancel_button_classes)
    end

    it 'returns a hash with URLs' do
      context = component.template_context
      expect(context).to have_key(:delete_url)
      expect(context).to have_key(:cancel_url)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [
        :modal_id, :modal_classes, :danger_button_classes, :cancel_button_classes,
        :display_message, :title, :delete_url, :cancel_url
      ]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'modal configuration' do
    let(:component) { described_class.new(
      title: title,
      message: message,
      delete_url: delete_url,
      cancel_url: cancel_url
    ) }

    it 'generates unique modal ID' do
      context = component.template_context
      expect(context[:modal_id]).to include('delete-modal')
      expect(context[:modal_id]).to be_a(String)
    end

    it 'includes modal classes' do
      context = component.template_context
      expect(context[:modal_classes]).to include('modal')
      expect(context[:modal_classes]).to be_a(String)
    end

    it 'sets correct title and message' do
      context = component.template_context
      expect(context[:title]).to eq(title)
      expect(context[:display_message]).to eq(message)
    end
  end

  describe 'button configuration' do
    let(:component) { described_class.new(
      title: title,
      message: message,
      delete_url: delete_url,
      cancel_url: cancel_url
    ) }

    it 'includes danger button classes' do
      context = component.template_context
      expect(context[:danger_button_classes]).to include('btn-danger')
      expect(context[:danger_button_classes]).to be_a(String)
    end

    it 'includes cancel button classes' do
      context = component.template_context
      expect(context[:cancel_button_classes]).to include('btn')
      expect(context[:cancel_button_classes]).to be_a(String)
    end
  end

  describe 'URL configuration' do
    it 'sets correct delete URL' do
      component = described_class.new(
        title: title,
        message: message,
        delete_url: delete_url,
        cancel_url: cancel_url
      )
      context = component.template_context
      expect(context[:delete_url]).to eq(delete_url)
    end

    it 'sets correct cancel URL' do
      component = described_class.new(
        title: title,
        message: message,
        delete_url: delete_url,
        cancel_url: cancel_url
      )
      context = component.template_context
      expect(context[:cancel_url]).to eq(cancel_url)
    end
  end
end
