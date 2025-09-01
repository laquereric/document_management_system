require 'rails_helper'

RSpec.describe User::DocumentComponents::CardComponent, type: :component do
  let(:document) { create(:document) }
  let(:show_actions) { true }

  before do
    render_inline(described_class.new(
      document: document,
      show_actions: show_actions
    ))
  end

  describe '#template_context' do
    let(:component) { described_class.new(
      document: document,
      show_actions: show_actions
    ) }

    it 'returns a hash with card configuration' do
      context = component.template_context
      expect(context).to have_key(:card_classes)
      expect(context).to have_key(:document)
    end

    it 'returns a hash with document data' do
      context = component.template_context
      expect(context).to have_key(:truncated_content)
      expect(context).to have_key(:formatted_date)
      expect(context).to have_key(:author_name)
      expect(context).to have_key(:folder_name)
      expect(context).to have_key(:team_name)
      expect(context).to have_key(:organization_name)
    end

    it 'returns a hash with file information' do
      context = component.template_context
      expect(context).to have_key(:has_file?)
      expect(context).to have_key(:file_extension)
      expect(context).to have_key(:file_icon)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [
        :card_classes, :truncated_content, :formatted_date, :author_name,
        :folder_name, :team_name, :organization_name, :has_file?,
        :file_extension, :file_icon, :document
      ]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'card configuration' do
    let(:component) { described_class.new(
      document: document,
      show_actions: show_actions
    ) }

    it 'generates card classes' do
      context = component.template_context
      expect(context[:card_classes]).to include('Box')
      expect(context[:card_classes]).to be_a(String)
    end

    it 'includes document object' do
      context = component.template_context
      expect(context[:document]).to eq(document)
    end
  end

  describe 'document data processing' do
    let(:component) { described_class.new(
      document: document,
      show_actions: show_actions
    ) }

    it 'truncates content correctly' do
      context = component.template_context
      expect(context[:truncated_content]).to be_a(String)
      expect(context[:truncated_content].length).to be <= 200
    end

    it 'formats date correctly' do
      context = component.template_context
      expect(context[:formatted_date]).to be_a(String)
      expect(context[:formatted_date]).to include('ago')
    end

    it 'generates author name' do
      context = component.template_context
      expect(context[:author_name]).to be_a(String)
    end

    it 'generates folder name' do
      context = component.template_context
      expect(context[:folder_name]).to be_a(String)
    end

    it 'generates team name' do
      context = component.template_context
      expect(context[:team_name]).to be_a(String)
    end

    it 'generates organization name' do
      context = component.template_context
      expect(context[:organization_name]).to be_a(String)
    end
  end

  describe 'file handling' do
    let(:component) { described_class.new(
      document: document,
      show_actions: show_actions
    ) }

    it 'detects file presence' do
      context = component.template_context
      expect(context[:has_file?]).to be_in([true, false])
    end

    it 'generates file extension' do
      context = component.template_context
      expect(context[:file_extension]).to be_a(String)
    end

    it 'generates file icon' do
      context = component.template_context
      expect(context[:file_icon]).to be_a(String)
    end
  end

  describe 'document with file attachment' do
    let(:document_with_file) { create(:document, :with_file) }
    let(:component) { described_class.new(
      document: document_with_file,
      show_actions: show_actions
    ) }

    it 'handles file attachments correctly' do
      context = component.template_context
      expect(context[:has_file?]).to be true
      expect(context[:file_extension]).to be_present
      expect(context[:file_icon]).to be_present
    end
  end
end
