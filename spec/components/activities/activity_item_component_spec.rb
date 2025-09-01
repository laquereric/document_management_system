require 'rails_helper'

RSpec.describe Activities::ActivityItemComponent, type: :component do
  let(:activity) { create(:activity) }

  before do
    render_inline(described_class.new(activity: activity))
  end

  describe '#template_context' do
    let(:component) { described_class.new(activity: activity) }

    it 'returns a hash with item configuration' do
      context = component.template_context
      expect(context).to have_key(:item_classes)
      expect(context).to have_key(:activity)
    end

    it 'returns a hash with action information' do
      context = component.template_context
      expect(context).to have_key(:action_icon)
      expect(context).to have_key(:action_description)
    end

    it 'includes all required context keys' do
      context = component.template_context
      expected_keys = [:item_classes, :action_icon, :action_description, :activity]
      expect(context.keys).to match_array(expected_keys)
    end
  end

  describe 'item configuration' do
    let(:component) { described_class.new(activity: activity) }

    it 'generates item classes' do
      context = component.template_context
      expect(context[:item_classes]).to include('d-flex')
      expect(context[:item_classes]).to be_a(String)
    end

    it 'includes activity object' do
      context = component.template_context
      expect(context[:activity]).to eq(activity)
    end
  end

  describe 'action information' do
    let(:component) { described_class.new(activity: activity) }

    it 'generates action icon' do
      context = component.template_context
      expect(context[:action_icon]).to be_a(String)
      expect(context[:action_icon]).to include('octicon')
    end

    it 'generates action description' do
      context = component.template_context
      expect(context[:action_description]).to be_a(String)
      expect(context[:action_description]).to include(activity.action)
    end
  end

  describe 'different activity types' do
    it 'handles different activity actions correctly' do
      activities = [
        create(:activity, action: 'created'),
        create(:activity, action: 'updated'),
        create(:activity, action: 'deleted'),
        create(:activity, action: 'status_change')
      ]

      activities.each do |activity|
        component = described_class.new(activity: activity)
        context = component.template_context
        
        expect(context[:action_icon]).to be_present
        expect(context[:action_description]).to include(activity.action)
        expect(context[:activity]).to eq(activity)
      end
    end
  end

  describe 'activity with document' do
    let(:document) { create(:document) }
    let(:activity_with_document) { create(:activity, document: document) }
    let(:component) { described_class.new(activity: activity_with_document) }

    it 'handles activities with documents correctly' do
      context = component.template_context
      expect(context[:action_description]).to include(document.title)
    end
  end

  describe 'activity without document' do
    let(:activity_without_document) { create(:activity, document: nil) }
    let(:component) { described_class.new(activity: activity_without_document) }

    it 'handles activities without documents correctly' do
      context = component.template_context
      expect(context[:action_description]).to be_present
      expect(context[:action_description]).to include(activity_without_document.action)
    end
  end
end
