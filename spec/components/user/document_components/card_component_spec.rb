require 'rails_helper'

RSpec.describe User::DocumentComponents::CardComponent, type: :component do
  let(:document) { build(:document, title: 'Test Document', content: 'Test content') }
  let(:show_actions) { true }
  let(:component) { described_class.new(document: document, show_actions: show_actions) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#card_classes' do
      it 'returns base card classes' do
        classes = component.send(:card_classes)
        expect(classes).to include('Box')
        expect(classes).to include('p-3')
        expect(classes).to include('mb-3')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(document: document, class: 'custom-card')
        classes = custom_component.send(:card_classes)
        expect(classes).to include('custom-card')
      end
    end

    describe '#title_classes' do
      it 'returns title classes' do
        classes = component.send(:title_classes)
        expect(classes).to include('h4')
        expect(classes).to include('mb-2')
      end
    end

    describe '#content_classes' do
      it 'returns content classes' do
        classes = component.send(:content_classes)
        expect(classes).to include('color-fg-muted')
        expect(classes).to include('mb-3')
      end
    end

    describe '#meta_classes' do
      it 'returns meta classes' do
        classes = component.send(:meta_classes)
        expect(classes).to include('color-fg-muted')
        expect(classes).to include('f6')
      end
    end

    describe '#action_classes' do
      it 'returns action classes' do
        classes = component.send(:action_classes)
        expect(classes).to include('d-flex')
        expect(classes).to include('justify-content-between')
        expect(classes).to include('align-items-center')
      end
    end

    describe '#truncated_title' do
      context 'when title is short' do
        let(:document) { build(:document, title: 'Short Title') }

        it 'returns original title' do
          title = component.send(:truncated_title)
          expect(title).to eq('Short Title')
        end
      end

      context 'when title is long' do
        let(:document) { build(:document, title: 'This is a very long title that should be truncated') }

        it 'truncates title to 50 characters' do
          title = component.send(:truncated_title)
          expect(title.length).to be <= 50
          expect(title).to end_with('...')
        end
      end

      context 'when title is exactly 50 characters' do
        let(:document) { build(:document, title: 'A' * 50) }

        it 'returns original title' do
          title = component.send(:truncated_title)
          expect(title).to eq('A' * 50)
        end
      end
    end

    describe '#truncated_content' do
      context 'when content is short' do
        let(:document) { build(:document, content: 'Short content') }

        it 'returns original content' do
          content = component.send(:truncated_content)
          expect(content).to eq('Short content')
        end
      end

      context 'when content is long' do
        let(:document) { build(:document, content: 'This is a very long content that should be truncated to fit within the card display') }

        it 'truncates content to 100 characters' do
          content = component.send(:truncated_content)
          expect(content.length).to be <= 100
          expect(content).to end_with('...')
        end
      end

      context 'when content is exactly 100 characters' do
        let(:document) { build(:document, content: 'A' * 100) }

        it 'returns original content' do
          content = component.send(:truncated_content)
          expect(content).to eq('A' * 100)
        end
      end
    end

    describe '#formatted_date' do
      let(:document) { build(:document, created_at: Time.current) }

      it 'formats date correctly' do
        date = component.send(:formatted_date)
        expect(date).to be_a(String)
        expect(date).not_to be_empty
      end

      context 'when created_at is nil' do
        let(:document) { build(:document, created_at: nil) }

        it 'handles nil date gracefully' do
          date = component.send(:formatted_date)
          expect(date).to eq('Unknown date')
        end
      end
    end

    describe '#file_extension' do
      context 'when file is attached' do
        let(:document) { build(:document, file: fixture_file_upload('test.pdf', 'application/pdf')) }

        it 'returns file extension' do
          extension = component.send(:file_extension)
          expect(extension).to eq('pdf')
        end
      end

      context 'when no file is attached' do
        let(:document) { build(:document, file: nil) }

        it 'returns nil' do
          extension = component.send(:file_extension)
          expect(extension).to be_nil
        end
      end
    end

    describe '#file_icon' do
      context 'when file is attached' do
        let(:document) { build(:document, file: fixture_file_upload('test.pdf', 'application/pdf')) }

        it 'returns file icon' do
          icon = component.send(:file_icon)
          expect(icon).to eq('file-pdf')
        end
      end

      context 'when no file is attached' do
        let(:document) { build(:document, file: nil) }

        it 'returns default icon' do
          icon = component.send(:file_icon)
          expect(icon).to eq('file-text')
        end
      end

      context 'with different file types' do
        it 'returns correct icon for PDF' do
          document = build(:document, file: fixture_file_upload('test.pdf', 'application/pdf'))
          component = described_class.new(document: document)
          expect(component.send(:file_icon)).to eq('file-pdf')
        end

        it 'returns correct icon for image' do
          document = build(:document, file: fixture_file_upload('test.jpg', 'image/jpeg'))
          component = described_class.new(document: document)
          expect(component.send(:file_icon)).to eq('file-media')
        end

        it 'returns correct icon for document' do
          document = build(:document, file: fixture_file_upload('test.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'))
          component = described_class.new(document: document)
          expect(component.send(:file_icon)).to eq('file-text')
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :card_classes,
          :title_classes,
          :content_classes,
          :meta_classes,
          :action_classes,
          :truncated_title,
          :truncated_content,
          :formatted_date,
          :file_extension,
          :file_icon,
          :document
        )
      end

      it 'includes path helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :document_path,
          :edit_document_path,
          :rails_blob_path
        )
      end

      it 'includes Rails helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :button_to,
          :link_to,
          :render
        )
      end

      it 'includes method references for dynamic paths' do
        context = component.send(:template_context)
        expect(context[:document_path]).to respond_to(:call)
        expect(context[:edit_document_path]).to respond_to(:call)
        expect(context[:rails_blob_path]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders document title' do
      render_inline(component)
      expect(page).to have_content('Test Document')
    end

    it 'renders document content' do
      render_inline(component)
      expect(page).to have_content('Test content')
    end

    it 'renders card with correct structure' do
      render_inline(component)
      expect(page).to have_css('.Box')
      expect(page).to have_css('.p-3')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.h4.mb-2')
      expect(page).to have_css('.color-fg-muted.mb-3')
    end

    it 'renders with custom classes' do
      custom_component = described_class.new(document: document, class: 'custom-class')
      render_inline(custom_component)
      expect(page).to have_css('.custom-class')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different document titles correctly' do
      different_document = build(:document, title: 'Different Title')
      different_component = described_class.new(document: different_document)
      title = different_component.send(:truncated_title)
      expect(title).to eq('Different Title')
    end

    it 'handles different document content correctly' do
      different_document = build(:document, content: 'Different content')
      different_component = described_class.new(document: different_document)
      content = different_component.send(:truncated_content)
      expect(content).to eq('Different content')
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)
      
      # Test that all required methods are callable
      expect { context[:card_classes] }.not_to raise_error
      expect { context[:title_classes] }.not_to raise_error
      expect { context[:content_classes] }.not_to raise_error
      expect { context[:truncated_title] }.not_to raise_error
      expect { context[:truncated_content] }.not_to raise_error
      expect { context[:formatted_date] }.not_to raise_error
    end

    it 'integrates with Rails path helpers' do
      context = component.send(:template_context)
      
      # Test that path helpers are available and callable
      expect(context[:document_path]).to respond_to(:call)
      expect(context[:edit_document_path]).to respond_to(:call)
      expect(context[:rails_blob_path]).to respond_to(:call)
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
      expect { nil_document_component.send(:card_classes) }.not_to raise_error
    end

    it 'handles document with nil title gracefully' do
      nil_title_document = build(:document, title: nil)
      nil_title_component = described_class.new(document: nil_title_document)
      expect { nil_title_component.send(:truncated_title) }.not_to raise_error
    end

    it 'handles document with nil content gracefully' do
      nil_content_document = build(:document, content: nil)
      nil_content_component = described_class.new(document: nil_content_document)
      expect { nil_content_component.send(:truncated_content) }.not_to raise_error
    end

    it 'handles document with nil created_at gracefully' do
      nil_date_document = build(:document, created_at: nil)
      nil_date_component = described_class.new(document: nil_date_document)
      expect { nil_date_component.send(:formatted_date) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(document: document)
      expect { minimal_component.send(:card_classes) }.not_to raise_error
    end
  end

  # Text Truncation Logic Tests
  describe 'Text truncation logic' do
    context 'with various title lengths' do
      it 'handles empty title' do
        empty_title_document = build(:document, title: '')
        empty_title_component = described_class.new(document: empty_title_document)
        title = empty_title_component.send(:truncated_title)
        expect(title).to eq('')
      end

      it 'handles nil title' do
        nil_title_document = build(:document, title: nil)
        nil_title_component = described_class.new(document: nil_title_document)
        title = nil_title_component.send(:truncated_title)
        expect(title).to eq('')
      end

      it 'handles very long title' do
        long_title = 'A' * 100
        long_title_document = build(:document, title: long_title)
        long_title_component = described_class.new(document: long_title_document)
        title = long_title_component.send(:truncated_title)
        expect(title.length).to eq(50)
        expect(title).to end_with('...')
      end
    end

    context 'with various content lengths' do
      it 'handles empty content' do
        empty_content_document = build(:document, content: '')
        empty_content_component = described_class.new(document: empty_content_document)
        content = empty_content_component.send(:truncated_content)
        expect(content).to eq('')
      end

      it 'handles nil content' do
        nil_content_document = build(:document, content: nil)
        nil_content_component = described_class.new(document: nil_content_document)
        content = nil_content_component.send(:truncated_content)
        expect(content).to eq('')
      end

      it 'handles very long content' do
        long_content = 'A' * 200
        long_content_document = build(:document, content: long_content)
        long_content_component = described_class.new(document: long_content_document)
        content = long_content_component.send(:truncated_content)
        expect(content.length).to eq(100)
        expect(content).to end_with('...')
      end
    end
  end

  # File Handling Tests
  describe 'File handling' do
    context 'with different file types' do
      it 'handles PDF files' do
        document = build(:document, file: fixture_file_upload('test.pdf', 'application/pdf'))
        component = described_class.new(document: document)
        expect(component.send(:file_extension)).to eq('pdf')
        expect(component.send(:file_icon)).to eq('file-pdf')
      end

      it 'handles image files' do
        document = build(:document, file: fixture_file_upload('test.jpg', 'image/jpeg'))
        component = described_class.new(document: document)
        expect(component.send(:file_extension)).to eq('jpg')
        expect(component.send(:file_icon)).to eq('file-media')
      end

      it 'handles document files' do
        document = build(:document, file: fixture_file_upload('test.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'))
        component = described_class.new(document: document)
        expect(component.send(:file_extension)).to eq('docx')
        expect(component.send(:file_icon)).to eq('file-text')
      end

      it 'handles files without extension' do
        document = build(:document, file: fixture_file_upload('test', 'text/plain'))
        component = described_class.new(document: document)
        expect(component.send(:file_extension)).to be_nil
        expect(component.send(:file_icon)).to eq('file-text')
      end
    end
  end

  # CSS Classes Tests
  describe 'CSS classes' do
    it 'applies correct base classes' do
      classes = component.send(:card_classes)
      expect(classes).to include('Box', 'p-3', 'mb-3')
    end

    it 'applies correct title classes' do
      classes = component.send(:title_classes)
      expect(classes).to include('h4', 'mb-2')
    end

    it 'applies correct content classes' do
      classes = component.send(:content_classes)
      expect(classes).to include('color-fg-muted', 'mb-3')
    end

    it 'applies correct meta classes' do
      classes = component.send(:meta_classes)
      expect(classes).to include('color-fg-muted', 'f6')
    end

    it 'applies correct action classes' do
      classes = component.send(:action_classes)
      expect(classes).to include('d-flex', 'justify-content-between', 'align-items-center')
    end

    it 'includes custom classes from system arguments' do
      custom_component = described_class.new(document: document, class: 'custom-class')
      classes = custom_component.send(:card_classes)
      expect(classes).to include('custom-class')
    end
  end
end
