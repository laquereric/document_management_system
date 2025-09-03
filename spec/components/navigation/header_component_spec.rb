require 'rails_helper'

RSpec.describe Layout::Navigation::HeaderComponent, type: :component do
  let(:current_user) { build(:user) }
  let(:title) { 'Document Management System' }
  let(:component) { described_class.new(current_user: current_user, title: title) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#header_classes' do
      it 'returns base header classes' do
        classes = component.send(:header_classes)
        expect(classes).to include('Header')
        expect(classes).to include('Header--full')
        expect(classes).to include('border-bottom')
        expect(classes).to include('color-bg-default')
        expect(classes).to include('px-3')
        expect(classes).to include('py-2')
        expect(classes).to include('d-flex')
        expect(classes).to include('flex-items-center')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(current_user: current_user, title: title, class: 'custom-header')
        classes = custom_component.send(:header_classes)
        expect(classes).to include('custom-header')
      end
    end

    describe '#brand_classes' do
      it 'returns brand classes' do
        classes = component.send(:brand_classes)
        expect(classes).to include('Header-item')
        expect(classes).to include('d-flex')
        expect(classes).to include('flex-items-center')
      end
    end

    describe '#nav_classes' do
      it 'returns navigation classes' do
        classes = component.send(:nav_classes)
        expect(classes).to include('Header-item')
        expect(classes).to include('d-flex')
      end
    end

    describe '#root_path' do
      it 'returns root path' do
        allow(component).to receive(:root_path).and_return('/')
        expect(component.send(:root_path)).to eq('/')
      end
    end

    describe '#new_user_session_path' do
      it 'returns new user session path' do
        allow(component).to receive(:new_user_session_path).and_return('/users/sign_in')
        expect(component.send(:new_user_session_path)).to eq('/users/sign_in')
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :header_classes,
          :brand_classes,
          :nav_classes,
          :root_path,
          :new_user_session_path,
          :current_user,
          :title
        )
      end

      it 'includes Rails object' do
        context = component.send(:template_context)
        expect(context).to include(:Rails)
      end

      it 'includes method references for path helpers' do
        context = component.send(:template_context)
        expect(context[:root_path_helper]).to respond_to(:call)
        expect(context[:new_user_session_path_helper]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders header with correct structure' do
      render_inline(component)
      expect(page).to have_css('.Header')
      expect(page).to have_css('.Header--full')
    end

    it 'renders brand section' do
      render_inline(component)
      expect(page).to have_css('.Header-item')
    end

    it 'renders navigation section' do
      render_inline(component)
      expect(page).to have_css('.Header-item')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.Header.border-bottom.color-bg-default')
    end

    it 'renders with custom title' do
      custom_title = 'Custom Application Title'
      custom_component = described_class.new(current_user: current_user, title: custom_title)
      render_inline(custom_component)
      expect(page).to have_content(custom_title)
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different titles correctly' do
      custom_title = 'Different Title'
      custom_component = described_class.new(current_user: current_user, title: custom_title)
      context = custom_component.send(:template_context)
      expect(context[:title]).to eq(custom_title)
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:header_classes] }.not_to raise_error
      expect { context[:brand_classes] }.not_to raise_error
      expect { context[:nav_classes] }.not_to raise_error
      expect { context[:root_path] }.not_to raise_error
      expect { context[:new_user_session_path] }.not_to raise_error
    end

    it 'integrates with Rails path helpers' do
      context = component.send(:template_context)

      # Test that path helpers are available and callable
      expect(context[:root_path_helper]).to respond_to(:call)
      expect(context[:new_user_session_path_helper]).to respond_to(:call)
    end

    it 'handles current_user correctly' do
      context = component.send(:template_context)
      expect(context[:current_user]).to eq(current_user)
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil current_user gracefully' do
      nil_user_component = described_class.new(current_user: nil, title: title)
      expect { nil_user_component.send(:header_classes) }.not_to raise_error
      expect { nil_user_component.send(:brand_classes) }.not_to raise_error
      expect { nil_user_component.send(:nav_classes) }.not_to raise_error
    end

    it 'handles nil title gracefully' do
      nil_title_component = described_class.new(current_user: current_user, title: nil)
      expect { nil_title_component.send(:header_classes) }.not_to raise_error
    end

    it 'handles empty title gracefully' do
      empty_title_component = described_class.new(current_user: current_user, title: '')
      expect { empty_title_component.send(:header_classes) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(current_user: current_user)
      expect { minimal_component.send(:header_classes) }.not_to raise_error
    end
  end

  # Header Structure Tests
  describe 'Header structure' do
    it 'maintains correct header hierarchy' do
      render_inline(component)
      expect(page).to have_css('.Header')
      expect(page).to have_css('.Header-item')
    end

    it 'applies responsive design classes' do
      render_inline(component)
      expect(page).to have_css('.d-flex')
      expect(page).to have_css('.flex-items-center')
    end

    it 'includes proper spacing classes' do
      render_inline(component)
      expect(page).to have_css('.px-3')
      expect(page).to have_css('.py-2')
    end
  end

  # User Authentication Context Tests
  describe 'User authentication context' do
    context 'when user is logged in' do
      it 'provides user context to template' do
        context = component.send(:template_context)
        expect(context[:current_user]).to eq(current_user)
      end
    end

    context 'when user is not logged in' do
      let(:component) { described_class.new(current_user: nil, title: title) }

      it 'handles nil user gracefully' do
        context = component.send(:template_context)
        expect(context[:current_user]).to be_nil
      end
    end
  end
end
