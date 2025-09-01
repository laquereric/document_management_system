require 'rails_helper'

RSpec.describe Navigation::SidebarComponent, type: :component do
  let(:current_user) { create(:user) }
  let(:controller_name) { 'dashboard' }
  let(:variant) { :default }

  before do
    render_inline(described_class.new(
      controller_name: controller_name,
      current_user: current_user,
      variant: variant
    ))
  end

  describe '#template_context' do
    let(:component) { described_class.new(
      controller_name: controller_name,
      current_user: current_user,
      variant: variant
    ) }

    it 'returns a hash with user navigation items' do
      context = component.template_context
      expect(context).to have_key(:user_navigation_items)
      expect(context[:user_navigation_items]).to be_an(Array)
    end

    it 'returns a hash with admin navigation items' do
      context = component.template_context
      expect(context).to have_key(:admin_navigation_items)
      expect(context[:admin_navigation_items]).to be_an(Array)
    end

    it 'returns a hash with render_icon_path method' do
      context = component.template_context
      expect(context).to have_key(:render_icon_path)
      expect(context[:render_icon_path]).to respond_to(:call)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [:user_navigation_items, :admin_navigation_items, :render_icon_path]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'user navigation items' do
    let(:component) { described_class.new(
      controller_name: controller_name,
      current_user: current_user,
      variant: variant
    ) }

    it 'includes dashboard link' do
      items = component.template_context[:user_navigation_items]
      dashboard_item = items.find { |item| item[:path] == '/dashboard' }
      expect(dashboard_item).to be_present
      expect(dashboard_item[:label]).to eq('Dashboard')
    end

    it 'includes documents link' do
      items = component.template_context[:user_navigation_items]
      documents_item = items.find { |item| item[:path] == '/documents' }
      expect(documents_item).to be_present
      expect(documents_item[:label]).to eq('Documents')
    end

    it 'includes activities link' do
      items = component.template_context[:user_navigation_items]
      activities_item = items.find { |item| item[:path].include?('/activities') }
      expect(activities_item).to be_present
      expect(activities_item[:label]).to eq('Activity Log')
    end
  end

  describe 'admin navigation items' do
    let(:current_user) { create(:user, :admin) }
    let(:component) { described_class.new(
      controller_name: controller_name,
      current_user: current_user,
      variant: variant
    ) }

    it 'includes admin navigation items for admin users' do
      items = component.template_context[:admin_navigation_items]
      expect(items).to be_an(Array)
      expect(items).not_to be_empty
    end

    it 'does not include admin navigation items for non-admin users' do
      regular_user = create(:user)
      component = described_class.new(
        controller_name: controller_name,
        current_user: regular_user,
        variant: variant
      )
      items = component.template_context[:admin_navigation_items]
      expect(items).to be_empty
    end
  end

  describe 'render_icon_path method' do
    let(:component) { described_class.new(
      controller_name: controller_name,
      current_user: current_user,
      variant: variant
    ) }

    it 'returns SVG path for valid icon' do
      render_method = component.template_context[:render_icon_path]
      svg_path = render_method.call('home')
      expect(svg_path).to include('<path')
      expect(svg_path).to include('</path>')
    end

    it 'returns default icon for invalid icon' do
      render_method = component.template_context[:render_icon_path]
      svg_path = render_method.call('invalid_icon')
      expect(svg_path).to include('<path')
      expect(svg_path).to include('</path>')
    end
  end
end
