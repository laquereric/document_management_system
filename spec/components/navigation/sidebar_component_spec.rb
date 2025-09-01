require 'rails_helper'

RSpec.describe Navigation::SidebarComponent, type: :component do
  let(:current_user) { build(:user, role: 'member') }
  let(:admin_user) { build(:user, role: 'admin') }
  let(:controller_name) { 'dashboard' }

  # Basic Component Tests
  describe 'Basic functionality' do
    it 'can be instantiated' do
      expect { described_class.new(current_user: current_user, controller_name: controller_name) }.not_to raise_error
    end

    it 'can be instantiated with admin user' do
      expect { described_class.new(current_user: admin_user, controller_name: controller_name) }.not_to raise_error
    end

    it 'can be instantiated with nil user' do
      expect { described_class.new(current_user: nil, controller_name: controller_name) }.not_to raise_error
    end

    it 'can be instantiated with different variants' do
      expect { described_class.new(current_user: current_user, controller_name: controller_name, variant: :collapsed) }.not_to raise_error
    end
  end

  # Ruby Logic Tests
  describe 'Ruby logic' do
    let(:component) { described_class.new(current_user: current_user, controller_name: controller_name) }

    describe '#navigation_items' do
      it 'returns empty array' do
        expect(component.send(:navigation_items)).to eq([])
      end
    end

    describe '#render_icon_path' do
      it 'returns SVG path for home icon' do
        path = component.send(:render_icon_path, 'home')
        expect(path).to include('<path')
        expect(path).to include('d=')
      end

      it 'returns SVG path for file-text icon' do
        path = component.send(:render_icon_path, 'file-text')
        expect(path).to include('<path')
        expect(path).to include('d=')
      end

      it 'returns default SVG path for unknown icon' do
        path = component.send(:render_icon_path, 'unknown')
        expect(path).to include('<path')
        expect(path).to include('d=')
      end

      it 'handles various icon types' do
        icons = ['home', 'file-text', 'file-directory', 'tag', 'pulse', 'people', 'organization', 'person', 'gear', 'group', 'list-unordered']
        icons.each do |icon|
          path = component.send(:render_icon_path, icon)
          expect(path).to include('<path')
          expect(path).to include('d=')
        end
      end
    end

    describe '#variant' do
      it 'returns default variant when not specified' do
        expect(component.send(:variant)).to eq(:default)
      end

      it 'returns specified variant' do
        collapsed_component = described_class.new(current_user: current_user, controller_name: controller_name, variant: :collapsed)
        expect(collapsed_component.send(:variant)).to eq(:collapsed)
      end
    end
  end

  # Component Initialization Tests
  describe 'Component initialization' do
    it 'sets current_user correctly' do
      component = described_class.new(current_user: current_user, controller_name: controller_name)
      expect(component.instance_variable_get(:@current_user)).to eq(current_user)
    end

    it 'sets controller_name correctly' do
      component = described_class.new(current_user: current_user, controller_name: controller_name)
      expect(component.instance_variable_get(:@controller_name)).to eq(controller_name)
    end

    it 'sets variant correctly' do
      component = described_class.new(current_user: current_user, controller_name: controller_name, variant: :collapsed)
      expect(component.instance_variable_get(:@variant)).to eq(:collapsed)
    end

    it 'handles nil current_user' do
      component = described_class.new(current_user: nil, controller_name: controller_name)
      expect(component.instance_variable_get(:@current_user)).to be_nil
    end

    it 'handles nil controller_name' do
      component = described_class.new(current_user: current_user, controller_name: nil)
      expect(component.instance_variable_get(:@controller_name)).to be_nil
    end
  end

  # User Role Tests
  describe 'User role handling' do
    it 'identifies admin users correctly' do
      admin_component = described_class.new(current_user: admin_user, controller_name: controller_name)
      expect(admin_user.admin?).to be true
    end

    it 'identifies regular users correctly' do
      regular_component = described_class.new(current_user: current_user, controller_name: controller_name)
      expect(current_user.admin?).to be false
    end

    it 'handles nil user gracefully' do
      nil_user_component = described_class.new(current_user: nil, controller_name: controller_name)
      expect(nil_user_component.instance_variable_get(:@current_user)).to be_nil
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles missing system arguments gracefully' do
      expect { described_class.new(current_user: current_user) }.not_to raise_error
    end

    it 'handles unknown variant gracefully' do
      component = described_class.new(current_user: current_user, controller_name: controller_name, variant: :unknown)
      expect(component.send(:variant)).to eq(:default)
    end
  end

  # Icon Rendering Tests
  describe 'Icon rendering' do
    let(:component) { described_class.new(current_user: current_user, controller_name: controller_name) }

    it 'renders all navigation icons correctly' do
      navigation_icons = ['home', 'file-text', 'file-directory', 'tag', 'pulse', 'people', 'organization', 'person']
      navigation_icons.each do |icon|
        path = component.send(:render_icon_path, icon)
        expect(path).to be_a(String)
        expect(path).to include('<path')
        expect(path).to include('d=')
      end
    end

    it 'renders admin icons correctly' do
      admin_icons = ['gear', 'organization', 'people', 'group', 'list-unordered', 'tag']
      admin_icons.each do |icon|
        path = component.send(:render_icon_path, icon)
        expect(path).to be_a(String)
        expect(path).to include('<path')
        expect(path).to include('d=')
      end
    end

    it 'handles unknown icons gracefully' do
      unknown_icons = ['unknown', 'invalid', 'missing']
      unknown_icons.each do |icon|
        path = component.send(:render_icon_path, icon)
        expect(path).to be_a(String)
        expect(path).to include('<path')
        expect(path).to include('d=')
      end
    end
  end

  # System Arguments Tests
  describe 'System arguments handling' do
    it 'accepts custom classes' do
      component = described_class.new(current_user: current_user, controller_name: controller_name, class: 'custom-class')
      expect(component.instance_variable_get(:@system_arguments)).to include(class: 'custom-class')
    end

    it 'accepts multiple custom classes' do
      component = described_class.new(current_user: current_user, controller_name: controller_name, class: 'class1 class2')
      expect(component.instance_variable_get(:@system_arguments)).to include(class: 'class1 class2')
    end

    it 'handles nil custom classes' do
      component = described_class.new(current_user: current_user, controller_name: controller_name, class: nil)
      expect(component.instance_variable_get(:@system_arguments)).to include(class: nil)
    end
  end
end
