require 'rails_helper'

RSpec.describe Layout::Navigation::BreadcrumbComponent, type: :component do
  let(:current_user) { build(:user) }
  let(:breadcrumbs) { nil }
  let(:component) { described_class.new(breadcrumbs: breadcrumbs) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#breadcrumb_classes' do
      it 'returns base breadcrumb classes' do
        classes = component.send(:breadcrumb_classes)
        expect(classes).to include('Breadcrumbs')
        expect(classes).to include('py-2')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(breadcrumbs: breadcrumbs, class: 'custom-class')
        classes = custom_component.send(:breadcrumb_classes)
        expect(classes).to include('custom-class')
      end
    end

    describe '#build_breadcrumbs_from_params' do
      before do
        allow(component).to receive(:controller_name).and_return('dashboard')
        allow(component).to receive(:action_name).and_return('index')
        allow(component).to receive(:params).and_return({})
        allow(component).to receive(:current_user).and_return(current_user)
        allow(component).to receive(:dashboard_index_path).and_return('/dashboard')
      end

      it 'always includes home breadcrumb' do
        breadcrumbs = component.send(:build_breadcrumbs_from_params)
        home_crumb = breadcrumbs.first
        expect(home_crumb[:label]).to eq('Home')
        expect(home_crumb[:path]).to eq('/')
      end

      context 'when controller is dashboard' do
        it 'adds dashboard breadcrumb' do
          breadcrumbs = component.send(:build_breadcrumbs_from_params)
          dashboard_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Dashboard' }
          expect(dashboard_crumb).to be_present
          expect(dashboard_crumb[:path]).to eq('/dashboard')
        end
      end

      context 'when controller is documents' do
        before do
          allow(component).to receive(:controller_name).and_return('documents')
          allow(component).to receive(:documents_path).and_return('/documents')
        end

        it 'adds documents breadcrumb' do
          breadcrumbs = component.send(:build_breadcrumbs_from_params)
          documents_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Documents' }
          expect(documents_crumb).to be_present
          expect(documents_crumb[:path]).to eq('/documents')
        end

        context 'when action is show' do
          before do
            allow(component).to receive(:action_name).and_return('show')
            allow(component).to receive(:params).and_return({ id: '123' })
          end

          it 'adds document details breadcrumb' do
            breadcrumbs = component.send(:build_breadcrumbs_from_params)
            details_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Document Details' }
            expect(details_crumb).to be_present
            expect(details_crumb[:path]).to be_nil
          end
        end

        context 'when action is new' do
          before do
            allow(component).to receive(:action_name).and_return('new')
          end

          it 'adds new document breadcrumb' do
            breadcrumbs = component.send(:build_breadcrumbs_from_params)
            new_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'New Document' }
            expect(new_crumb).to be_present
            expect(new_crumb[:path]).to be_nil
          end
        end
      end

      context 'when controller is folders' do
        before do
          allow(component).to receive(:controller_name).and_return('folders')
          allow(component).to receive(:folders_path).and_return('/folders')
        end

        it 'adds folders breadcrumb' do
          breadcrumbs = component.send(:build_breadcrumbs_from_params)
          folders_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Folders' }
          expect(folders_crumb).to be_present
          expect(folders_crumb[:path]).to eq('/folders')
        end

        context 'when action is show' do
          before do
            allow(component).to receive(:action_name).and_return('show')
            allow(component).to receive(:params).and_return({ id: '123' })
          end

          it 'adds folder details breadcrumb' do
            breadcrumbs = component.send(:build_breadcrumbs_from_params)
            details_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Folder Details' }
            expect(details_crumb).to be_present
            expect(details_crumb[:path]).to be_nil
          end
        end
      end

      context 'when controller is activities' do
        before do
          allow(component).to receive(:controller_name).and_return('activities')
          allow(component).to receive(:user_activities_path).and_return('/user/activities')
        end

        it 'adds activity breadcrumb' do
          breadcrumbs = component.send(:build_breadcrumbs_from_params)
          activity_crumb = breadcrumbs.find { |crumb| crumb[:label] == 'Activity' }
          expect(activity_crumb).to be_present
          expect(activity_crumb[:path]).to eq('/user/activities')
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :breadcrumbs,
          :breadcrumb_classes,
          :controller_name,
          :action_name,
          :params,
          :current_user
        )
      end

      it 'includes path helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :dashboard_index_path,
          :documents_path,
          :folders_path,
          :organizations_path,
          :tags_path
        )
      end

      it 'includes method references for dynamic paths' do
        context = component.send(:template_context)
        expect(context[:user_activities_path]).to respond_to(:call)
        expect(context[:build_breadcrumbs_from_params]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    let(:custom_breadcrumbs) do
      [
        { label: 'Home', path: '/' },
        { label: 'Documents', path: '/documents' },
        { label: 'Document Details', path: nil }
      ]
    end

    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders custom breadcrumbs when provided' do
      custom_component = described_class.new(breadcrumbs: custom_breadcrumbs)
      render_inline(custom_component)
      expect(page).to have_content('Home')
      expect(page).to have_content('Documents')
      expect(page).to have_content('Document Details')
    end

    it 'renders breadcrumbs with correct structure' do
      custom_component = described_class.new(breadcrumbs: custom_breadcrumbs)
      render_inline(custom_component)
      expect(page).to have_css('.Breadcrumbs')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.Breadcrumbs.py-2')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different controller names correctly' do
      allow(component).to receive(:controller_name).and_return('documents')
      allow(component).to receive(:action_name).and_return('show')
      allow(component).to receive(:params).and_return({ id: '123' })
      allow(component).to receive(:documents_path).and_return('/documents')

      breadcrumbs = component.send(:build_breadcrumbs_from_params)
      expect(breadcrumbs.length).to eq(3)
      expect(breadcrumbs[1][:label]).to eq('Documents')
      expect(breadcrumbs[2][:label]).to eq('Document Details')
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:breadcrumbs] }.not_to raise_error
      expect { context[:breadcrumb_classes] }.not_to raise_error
      expect { context[:build_breadcrumbs_from_params].call }.not_to raise_error
    end

    it 'integrates with Rails path helpers' do
      context = component.send(:template_context)

      # Test that path helpers are available
      expect(context[:dashboard_index_path]).to be_present
      expect(context[:documents_path]).to be_present
      expect(context[:folders_path]).to be_present
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil breadcrumbs gracefully' do
      nil_breadcrumbs_component = described_class.new(breadcrumbs: nil)
      expect { nil_breadcrumbs_component.send(:breadcrumb_classes) }.not_to raise_error
    end

    it 'handles empty breadcrumbs array gracefully' do
      empty_breadcrumbs_component = described_class.new(breadcrumbs: [])
      expect { empty_breadcrumbs_component.send(:breadcrumb_classes) }.not_to raise_error
    end

    it 'handles missing controller_name gracefully' do
      allow(component).to receive(:controller_name).and_return(nil)
      expect { component.send(:build_breadcrumbs_from_params) }.not_to raise_error
    end

    it 'handles missing action_name gracefully' do
      allow(component).to receive(:action_name).and_return(nil)
      expect { component.send(:build_breadcrumbs_from_params) }.not_to raise_error
    end

    it 'handles missing params gracefully' do
      allow(component).to receive(:params).and_return(nil)
      expect { component.send(:build_breadcrumbs_from_params) }.not_to raise_error
    end
  end

  # Breadcrumb Structure Tests
  describe 'Breadcrumb structure' do
    it 'maintains correct breadcrumb hierarchy' do
      allow(component).to receive(:controller_name).and_return('documents')
      allow(component).to receive(:action_name).and_return('show')
      allow(component).to receive(:params).and_return({ id: '123' })
      allow(component).to receive(:documents_path).and_return('/documents')

      breadcrumbs = component.send(:build_breadcrumbs_from_params)

      expect(breadcrumbs[0][:label]).to eq('Home')
      expect(breadcrumbs[0][:path]).to eq('/')

      expect(breadcrumbs[1][:label]).to eq('Documents')
      expect(breadcrumbs[1][:path]).to eq('/documents')

      expect(breadcrumbs[2][:label]).to eq('Document Details')
      expect(breadcrumbs[2][:path]).to be_nil
    end

    it 'handles breadcrumbs without paths' do
      breadcrumbs_without_paths = [
        { label: 'Home', path: '/' },
        { label: 'Current Page', path: nil }
      ]

      custom_component = described_class.new(breadcrumbs: breadcrumbs_without_paths)
      expect { custom_component.send(:breadcrumb_classes) }.not_to raise_error
    end
  end
end
