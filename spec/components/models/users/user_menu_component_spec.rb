require 'rails_helper'

RSpec.describe Models::Users::UserMenuComponent, type: :component do
  let(:user) { build(:user, email: 'john.doe@example.com') }
  let(:component) { described_class.new(user: user) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#menu_items' do
      it 'returns array of menu items' do
        items = component.send(:menu_items)
        expect(items).to be_an(Array)
        expect(items).not_to be_empty
      end

      it 'includes profile menu item' do
        items = component.send(:menu_items)
        profile_item = items.find { |item| item[:label] == 'Profile' }
        expect(profile_item).to be_present
        expect(profile_item[:icon]).to eq(:person)
        expect(profile_item[:href]).to eq('#')
      end

      it 'includes settings menu item' do
        items = component.send(:menu_items)
        settings_item = items.find { |item| item[:label] == 'Settings' }
        expect(settings_item).to be_present
        expect(settings_item[:icon]).to eq(:gear)
        expect(settings_item[:href]).to eq('#')
      end

      it 'includes help menu item' do
        items = component.send(:menu_items)
        help_item = items.find { |item| item[:label] == 'Help' }
        expect(help_item).to be_present
        expect(help_item[:icon]).to eq(:question)
        expect(help_item[:href]).to eq('#')
      end

      it 'includes divider' do
        items = component.send(:menu_items)
        expect(items).to include(:divider)
      end

      it 'includes sign out menu item' do
        items = component.send(:menu_items)
        sign_out_item = items.find { |item| item[:label] == 'Sign Out' }
        expect(sign_out_item).to be_present
        expect(sign_out_item[:icon]).to eq(:sign_out)
        expect(sign_out_item[:method]).to eq(:delete)
        expect(sign_out_item[:classes]).to eq('color-fg-danger')
      end

      it 'uses destroy_user_session_path for sign out' do
        allow(component).to receive(:destroy_user_session_path).and_return('/users/sign_out')
        items = component.send(:menu_items)
        sign_out_item = items.find { |item| item[:label] == 'Sign Out' }
        expect(sign_out_item[:href]).to eq('/users/sign_out')
      end
    end

    describe '#user_initials' do
      context 'when email has single name' do
        let(:user) { build(:user, email: 'john@example.com') }

        it 'returns first letter of name' do
          initials = component.send(:user_initials)
          expect(initials).to eq('J')
        end
      end

      context 'when email has multiple names' do
        let(:user) { build(:user, email: 'john.doe@example.com') }

        it 'returns first letter of each name' do
          initials = component.send(:user_initials)
          expect(initials).to eq('JD')
        end
      end

      context 'when email has three names' do
        let(:user) { build(:user, email: 'john.michael.doe@example.com') }

        it 'returns first letter of each name' do
          initials = component.send(:user_initials)
          expect(initials).to eq('JMD')
        end
      end

      context 'when email has no dots' do
        let(:user) { build(:user, email: 'john@example.com') }

        it 'returns first letter' do
          initials = component.send(:user_initials)
          expect(initials).to eq('J')
        end
      end

      context 'when email is empty' do
        let(:user) { build(:user, email: '') }

        it 'returns empty string' do
          initials = component.send(:user_initials)
          expect(initials).to eq('')
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :menu_items,
          :user_initials,
          :user
        )
      end

      it 'includes path helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :destroy_user_session_path,
          :user_path,
          :edit_user_path
        )
      end

      it 'includes method references for dynamic paths' do
        context = component.send(:template_context)
        expect(context[:user_path]).to respond_to(:call)
        expect(context[:edit_user_path]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders user initials' do
      render_inline(component)
      expect(page).to have_content('JD') # john.doe@example.com
    end

    it 'renders menu items' do
      render_inline(component)
      expect(page).to have_content('Profile')
      expect(page).to have_content('Settings')
      expect(page).to have_content('Help')
      expect(page).to have_content('Sign Out')
    end

    it 'renders with correct structure' do
      render_inline(component)
      expect(page).to have_css('.details-reset')
      expect(page).to have_css('.details-overlay')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.btn.btn-sm.btn-invisible')
    end

    it 'renders menu items with correct attributes' do
      render_inline(component)
      expect(page).to have_css('.SelectMenu-item')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different user emails correctly' do
      different_user = build(:user, email: 'jane.smith@example.com')
      different_component = described_class.new(user: different_user)
      initials = different_component.send(:user_initials)
      expect(initials).to eq('JS')
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:menu_items] }.not_to raise_error
      expect { context[:user_initials] }.not_to raise_error
      expect { context[:user] }.not_to raise_error
    end

    it 'integrates with Rails path helpers' do
      context = component.send(:template_context)

      # Test that path helpers are available and callable
      expect(context[:destroy_user_session_path]).to be_present
      expect(context[:user_path]).to respond_to(:call)
      expect(context[:edit_user_path]).to respond_to(:call)
    end

    it 'handles user object correctly' do
      context = component.send(:template_context)
      expect(context[:user]).to eq(user)
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil user gracefully' do
      nil_user_component = described_class.new(user: nil)
      expect { nil_user_component.send(:menu_items) }.not_to raise_error
      expect { nil_user_component.send(:user_initials) }.not_to raise_error
    end

    it 'handles user with nil email gracefully' do
      nil_email_user = build(:user, email: nil)
      nil_email_component = described_class.new(user: nil_email_user)
      expect { nil_email_component.send(:user_initials) }.not_to raise_error
    end

    it 'handles user with empty email gracefully' do
      empty_email_user = build(:user, email: '')
      empty_email_component = described_class.new(user: empty_email_user)
      expect { empty_email_component.send(:user_initials) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(user: user)
      expect { minimal_component.send(:menu_items) }.not_to raise_error
    end
  end

  # Menu Structure Tests
  describe 'Menu structure' do
    it 'maintains correct menu hierarchy' do
      items = component.send(:menu_items)

      # Check that items are in correct order
      expect(items[0][:label]).to eq('Profile')
      expect(items[1][:label]).to eq('Settings')
      expect(items[2][:label]).to eq('Help')
      expect(items[3]).to eq(:divider)
      expect(items[4][:label]).to eq('Sign Out')
    end

    it 'includes all required menu item attributes' do
      items = component.send(:menu_items)
      profile_item = items.find { |item| item[:label] == 'Profile' }

      expect(profile_item).to include(:label, :icon, :href)
    end

    it 'handles sign out item with correct attributes' do
      items = component.send(:menu_items)
      sign_out_item = items.find { |item| item[:label] == 'Sign Out' }

      expect(sign_out_item).to include(:label, :icon, :href, :method, :classes)
      expect(sign_out_item[:method]).to eq(:delete)
      expect(sign_out_item[:classes]).to eq('color-fg-danger')
    end
  end

  # User Initials Logic Tests
  describe 'User initials logic' do
    context 'with various email formats' do
      it 'handles single name' do
        single_name_user = build(:user, email: 'john@example.com')
        single_name_component = described_class.new(user: single_name_user)
        expect(single_name_component.send(:user_initials)).to eq('J')
      end

      it 'handles two names' do
        two_name_user = build(:user, email: 'john.doe@example.com')
        two_name_component = described_class.new(user: two_name_user)
        expect(two_name_component.send(:user_initials)).to eq('JD')
      end

      it 'handles three names' do
        three_name_user = build(:user, email: 'john.michael.doe@example.com')
        three_name_component = described_class.new(user: three_name_user)
        expect(three_name_component.send(:user_initials)).to eq('JMD')
      end

      it 'handles names with numbers' do
        number_name_user = build(:user, email: 'john123.doe@example.com')
        number_name_component = described_class.new(user: number_name_user)
        expect(number_name_component.send(:user_initials)).to eq('JD')
      end

      it 'handles names with special characters' do
        special_name_user = build(:user, email: 'john-doe@example.com')
        special_name_component = described_class.new(user: special_name_user)
        expect(special_name_component.send(:user_initials)).to eq('J')
      end
    end
  end
end
