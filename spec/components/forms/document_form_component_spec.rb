require 'rails_helper'

RSpec.describe Forms::DocumentFormComponent, type: :component do
  let(:document) { build(:document) }
  let(:submit_text) { 'Save Document' }
  let(:cancel_url) { '/documents' }
  let(:component) { described_class.new(document: document, submit_text: submit_text, cancel_url: cancel_url) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#form_classes' do
      it 'returns form classes' do
        classes = component.send(:form_classes)
        expect(classes).to be_a(String)
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(document: document, class: 'custom-form')
        classes = custom_component.send(:form_classes)
        expect(classes).to include('custom-form')
      end
    end

    describe '#title_field_classes' do
      it 'returns title field classes' do
        classes = component.send(:title_field_classes)
        expect(classes).to include('FormControl-input')
        expect(classes).to include('FormControl-large')
      end
    end

    describe '#content_field_classes' do
      it 'returns content field classes' do
        classes = component.send(:content_field_classes)
        expect(classes).to include('FormControl-textarea')
      end
    end

    describe '#url_field_classes' do
      it 'returns URL field classes' do
        classes = component.send(:url_field_classes)
        expect(classes).to include('FormControl-input')
      end
    end

    describe '#select_classes' do
      it 'returns select classes' do
        classes = component.send(:select_classes)
        expect(classes).to include('FormControl-select')
      end
    end

    describe '#file_field_classes' do
      it 'returns file field classes' do
        classes = component.send(:file_field_classes)
        expect(classes).to include('FormControl-input')
      end
    end

    describe '#submit_button_classes' do
      it 'returns submit button classes' do
        classes = component.send(:submit_button_classes)
        expect(classes).to include('btn')
        expect(classes).to include('btn-primary')
      end
    end

    describe '#cancel_button_classes' do
      it 'returns cancel button classes' do
        classes = component.send(:cancel_button_classes)
        expect(classes).to include('btn')
      end
    end

    describe '#statuses' do
      it 'returns statuses when Status model is defined' do
        allow(Status).to receive(:all).and_return([ build(:status) ])
        statuses = component.send(:statuses)
        expect(statuses).to be_an(Array)
      end

      it 'returns empty array when Status model is not defined' do
        hide_const('Status')
        statuses = component.send(:statuses)
        expect(statuses).to eq([])
      end
    end

    describe '#scenarios' do
      it 'returns scenarios when Scenario model is defined' do
        allow(Scenario).to receive(:all).and_return([ build(:scenario) ])
        scenarios = component.send(:scenarios)
        expect(scenarios).to be_an(Array)
      end

      it 'returns empty array when Scenario model is not defined' do
        hide_const('Scenario')
        scenarios = component.send(:scenarios)
        expect(scenarios).to eq([])
      end
    end

    describe '#folders' do
      it 'returns folders when Folder model is defined' do
        allow(Folder).to receive(:all).and_return([ build(:folder) ])
        folders = component.send(:folders)
        expect(folders).to be_an(Array)
      end

      it 'returns empty array when Folder model is not defined' do
        hide_const('Folder')
        folders = component.send(:folders)
        expect(folders).to eq([])
      end
    end

    describe '#form_url' do
      context 'when document is persisted' do
        let(:document) { build(:document, id: 1) }

        it 'returns document path' do
          allow(component).to receive(:document_path).and_return('/documents/1')
          url = component.send(:form_url)
          expect(url).to eq('/documents/1')
        end
      end

      context 'when document is not persisted' do
        let(:document) { build(:document, id: nil) }

        it 'returns documents path' do
          allow(component).to receive(:documents_path).and_return('/documents')
          url = component.send(:form_url)
          expect(url).to eq('/documents')
        end
      end
    end

    describe '#form_method' do
      context 'when document is persisted' do
        let(:document) { build(:document, id: 1) }

        it 'returns patch method' do
          method = component.send(:form_method)
          expect(method).to eq(:patch)
        end
      end

      context 'when document is not persisted' do
        let(:document) { build(:document, id: nil) }

        it 'returns post method' do
          method = component.send(:form_method)
          expect(method).to eq(:post)
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :form_classes,
          :title_field_classes,
          :content_field_classes,
          :url_field_classes,
          :select_classes,
          :file_field_classes,
          :submit_button_classes,
          :cancel_button_classes,
          :statuses,
          :scenarios,
          :folders,
          :form_url,
          :form_method,
          :submit_text,
          :cancel_url
        )
      end

      it 'includes document object' do
        context = component.send(:template_context)
        expect(context).to include(:document)
      end

      it 'includes path helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :document_path,
          :documents_path
        )
      end

      it 'includes model classes' do
        context = component.send(:template_context)
        expect(context).to include(:Status, :Scenario, :Folder)
      end

      it 'includes method references for dynamic paths' do
        context = component.send(:template_context)
        expect(context[:document_path]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders form with correct structure' do
      render_inline(component)
      expect(page).to have_css('form')
    end

    it 'renders form fields' do
      render_inline(component)
      expect(page).to have_field('Title')
      expect(page).to have_field('Content')
    end

    it 'renders submit button with correct text' do
      render_inline(component)
      expect(page).to have_button('Save Document')
    end

    it 'renders cancel link' do
      render_inline(component)
      expect(page).to have_link('Cancel', href: '/documents')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.FormControl-input')
      expect(page).to have_css('.btn.btn-primary')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different submit texts correctly' do
      custom_submit_text = 'Create Document'
      custom_component = described_class.new(document: document, submit_text: custom_submit_text)
      context = custom_component.send(:template_context)
      expect(context[:submit_text]).to eq(custom_submit_text)
    end

    it 'handles different cancel URLs correctly' do
      custom_cancel_url = '/dashboard'
      custom_component = described_class.new(document: document, cancel_url: custom_cancel_url)
      context = custom_component.send(:template_context)
      expect(context[:cancel_url]).to eq(custom_cancel_url)
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:form_classes] }.not_to raise_error
      expect { context[:title_field_classes] }.not_to raise_error
      expect { context[:content_field_classes] }.not_to raise_error
      expect { context[:form_url] }.not_to raise_error
      expect { context[:form_method] }.not_to raise_error
    end

    it 'integrates with Rails path helpers' do
      context = component.send(:template_context)

      # Test that path helpers are available and callable
      expect(context[:documents_path]).to be_present
      expect(context[:document_path]).to respond_to(:call)
    end

    it 'handles document object correctly' do
      context = component.send(:template_context)
      expect(context[:document]).to eq(document)
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil document gracefully' do
      nil_document_component = described_class.new(document: nil)
      expect { nil_document_component.send(:form_classes) }.not_to raise_error
      expect { nil_document_component.send(:form_url) }.not_to raise_error
      expect { nil_document_component.send(:form_method) }.not_to raise_error
    end

    it 'handles nil submit_text gracefully' do
      nil_submit_component = described_class.new(document: document, submit_text: nil)
      expect { nil_submit_component.send(:form_classes) }.not_to raise_error
    end

    it 'handles nil cancel_url gracefully' do
      nil_cancel_component = described_class.new(document: document, cancel_url: nil)
      expect { nil_cancel_component.send(:form_classes) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(document: document)
      expect { minimal_component.send(:form_classes) }.not_to raise_error
    end
  end

  # Form Method Logic Tests
  describe 'Form method logic' do
    context 'with new document' do
      let(:new_document) { build(:document, id: nil) }

      it 'uses POST method for new documents' do
        new_component = described_class.new(document: new_document)
        expect(new_component.send(:form_method)).to eq(:post)
      end

      it 'uses documents path for new documents' do
        allow(described_class.new(document: new_document)).to receive(:documents_path).and_return('/documents')
        url = described_class.new(document: new_document).send(:form_url)
        expect(url).to eq('/documents')
      end
    end

    context 'with existing document' do
      let(:existing_document) { build(:document, id: 123) }

      it 'uses PATCH method for existing documents' do
        existing_component = described_class.new(document: existing_document)
        expect(existing_component.send(:form_method)).to eq(:patch)
      end

      it 'uses document path for existing documents' do
        allow(described_class.new(document: existing_document)).to receive(:document_path).and_return('/documents/123')
        url = described_class.new(document: existing_document).send(:form_url)
        expect(url).to eq('/documents/123')
      end
    end
  end

  # Model Integration Tests
  describe 'Model integration' do
    it 'handles Status model availability' do
      allow(Status).to receive(:all).and_return([ build(:status) ])
      statuses = component.send(:statuses)
      expect(statuses).to be_an(Array)
    end

    it 'handles Scenario model availability' do
      allow(Scenario).to receive(:all).and_return([ build(:scenario) ])
      scenarios = component.send(:scenarios)
      expect(scenarios).to be_an(Array)
    end

    it 'handles Folder model availability' do
      allow(Folder).to receive(:all).and_return([ build(:folder) ])
      folders = component.send(:folders)
      expect(folders).to be_an(Array)
    end
  end
end
