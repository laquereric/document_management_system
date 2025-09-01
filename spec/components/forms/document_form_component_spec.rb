require 'rails_helper'

RSpec.describe Forms::DocumentFormComponent, type: :component do
  let(:document) { build(:document) }
  let(:statuses) { create_list(:status, 3) }
  let(:scenarios) { create_list(:scenario, 2) }
  let(:folders) { create_list(:folder, 3) }

  before do
    render_inline(described_class.new(
      document: document,
      statuses: statuses,
      scenarios: scenarios,
      folders: folders
    ))
  end

  describe '#template_context' do
    let(:component) { described_class.new(
      document: document,
      statuses: statuses,
      scenarios: scenarios,
      folders: folders
    ) }

    it 'returns a hash with form classes' do
      context = component.template_context
      expect(context).to have_key(:form_classes)
      expect(context[:form_classes]).to be_a(String)
    end

    it 'returns a hash with field classes' do
      context = component.template_context
      expect(context).to have_key(:title_field_classes)
      expect(context).to have_key(:content_field_classes)
      expect(context).to have_key(:url_field_classes)
      expect(context).to have_key(:select_classes)
      expect(context).to have_key(:file_field_classes)
    end

    it 'returns a hash with button classes' do
      context = component.template_context
      expect(context).to have_key(:submit_button_classes)
      expect(context).to have_key(:cancel_button_classes)
    end

    it 'returns a hash with form data' do
      context = component.template_context
      expect(context).to have_key(:statuses)
      expect(context).to have_key(:scenarios)
      expect(context).to have_key(:folders)
      expect(context).to have_key(:form_url)
      expect(context).to have_key(:form_method)
      expect(context).to have_key(:submit_text)
      expect(context).to have_key(:cancel_url)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [
        :form_classes, :title_field_classes, :content_field_classes, :url_field_classes,
        :select_classes, :file_field_classes, :submit_button_classes, :cancel_button_classes,
        :statuses, :scenarios, :folders, :form_url, :form_method, :submit_text, :cancel_url
      ]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'form URL generation' do
    let(:new_document) { build(:document) }
    let(:existing_document) { create(:document) }

    it 'generates correct URL for new document' do
      component = described_class.new(
        document: new_document,
        statuses: statuses,
        scenarios: scenarios,
        folders: folders
      )
      context = component.template_context
      expect(context[:form_url]).to eq('/documents')
      expect(context[:form_method]).to eq(:post)
      expect(context[:submit_text]).to eq('Create Document')
    end

    it 'generates correct URL for existing document' do
      component = described_class.new(
        document: existing_document,
        statuses: statuses,
        scenarios: scenarios,
        folders: folders
      )
      context = component.template_context
      expect(context[:form_url]).to eq("/documents/#{existing_document.id}")
      expect(context[:form_method]).to eq(:patch)
      expect(context[:submit_text]).to eq('Update Document')
    end
  end

  describe 'cancel URL generation' do
    it 'generates correct cancel URL for new document' do
      component = described_class.new(
        document: document,
        statuses: statuses,
        scenarios: scenarios,
        folders: folders
      )
      context = component.template_context
      expect(context[:cancel_url]).to eq('/documents')
    end

    it 'generates correct cancel URL for existing document' do
      existing_document = create(:document)
      component = described_class.new(
        document: existing_document,
        statuses: statuses,
        scenarios: scenarios,
        folders: folders
      )
      context = component.template_context
      expect(context[:cancel_url]).to eq("/documents/#{existing_document.id}")
    end
  end
end
