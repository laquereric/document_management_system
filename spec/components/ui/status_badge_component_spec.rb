require 'rails_helper'

RSpec.describe Ui::StatusBadgeComponent, type: :component do
  let(:status) { create(:status, name: 'Active', color: '#28a745') }

  before do
    render_inline(described_class.new(status: status))
  end

  describe '#template_context' do
    let(:component) { described_class.new(status: status) }

    it 'returns a hash with badge configuration' do
      context = component.template_context
      expect(context).to have_key(:badge_classes)
      expect(context).to have_key(:badge_style)
      expect(context).to have_key(:status)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [:badge_classes, :badge_style, :status]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'badge configuration' do
    let(:component) { described_class.new(status: status) }

    it 'generates badge classes' do
      context = component.template_context
      expect(context[:badge_classes]).to include('Label')
      expect(context[:badge_classes]).to be_a(String)
    end

    it 'generates badge style with color' do
      context = component.template_context
      expect(context[:badge_style]).to include('background-color')
      expect(context[:badge_style]).to include(status.color)
      expect(context[:badge_style]).to be_a(String)
    end

    it 'includes status object' do
      context = component.template_context
      expect(context[:status]).to eq(status)
    end
  end

  describe 'different status colors' do
    it 'handles different status colors correctly' do
      statuses = [
        create(:status, name: 'Draft', color: '#6c757d'),
        create(:status, name: 'Active', color: '#28a745'),
        create(:status, name: 'Pending', color: '#ffc107'),
        create(:status, name: 'Rejected', color: '#dc3545')
      ]

      statuses.each do |status|
        component = described_class.new(status: status)
        context = component.template_context
        
        expect(context[:badge_style]).to include(status.color)
        expect(context[:status]).to eq(status)
      end
    end
  end
end
