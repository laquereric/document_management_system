require 'rails_helper'

RSpec.describe Models::Activities::ActivityItemComponent, type: :component do
  let(:activity) { build(:activity, action: 'created', trackable_type: 'Document', trackable_id: 1) }
  let(:component) { described_class.new(activity: activity) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#item_classes' do
      it 'returns base item classes' do
        classes = component.send(:item_classes)
        expect(classes).to include('TimelineItem')
        expect(classes).to include('py-3')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(activity: activity, class: 'custom-item')
        classes = custom_component.send(:item_classes)
        expect(classes).to include('custom-item')
      end
    end

    describe '#avatar_classes' do
      it 'returns avatar classes' do
        classes = component.send(:avatar_classes)
        expect(classes).to include('TimelineItem-avatar')
      end
    end

    describe '#body_classes' do
      it 'returns body classes' do
        classes = component.send(:body_classes)
        expect(classes).to include('TimelineItem-body')
      end
    end

    describe '#action_icon' do
      context 'when action is created' do
        let(:activity) { build(:activity, action: 'created') }

        it 'returns plus icon' do
          icon = component.send(:action_icon)
          expect(icon).to eq('plus')
        end
      end

      context 'when action is updated' do
        let(:activity) { build(:activity, action: 'updated') }

        it 'returns pencil icon' do
          icon = component.send(:action_icon)
          expect(icon).to eq('pencil')
        end
      end

      context 'when action is deleted' do
        let(:activity) { build(:activity, action: 'deleted') }

        it 'returns trash icon' do
          icon = component.send(:action_icon)
          expect(icon).to eq('trash')
        end
      end

      context 'when action is unknown' do
        let(:activity) { build(:activity, action: 'unknown') }

        it 'returns default icon' do
          icon = component.send(:action_icon)
          expect(icon).to eq('circle')
        end
      end
    end

    describe '#action_color' do
      context 'when action is created' do
        let(:activity) { build(:activity, action: 'created') }

        it 'returns success color' do
          color = component.send(:action_color)
          expect(color).to eq('color-bg-success')
        end
      end

      context 'when action is updated' do
        let(:activity) { build(:activity, action: 'updated') }

        it 'returns attention color' do
          color = component.send(:action_color)
          expect(color).to eq('color-bg-attention')
        end
      end

      context 'when action is deleted' do
        let(:activity) { build(:activity, action: 'deleted') }

        it 'returns danger color' do
          color = component.send(:action_color)
          expect(color).to eq('color-bg-danger')
        end
      end

      context 'when action is unknown' do
        let(:activity) { build(:activity, action: 'unknown') }

        it 'returns muted color' do
          color = component.send(:action_color)
          expect(color).to eq('color-bg-muted')
        end
      end
    end

    describe '#action_description' do
      context 'when action is created' do
        let(:activity) { build(:activity, action: 'created', trackable_type: 'Document') }

        it 'returns created description' do
          description = component.send(:action_description)
          expect(description).to include('created')
          expect(description).to include('Document')
        end
      end

      context 'when action is updated' do
        let(:activity) { build(:activity, action: 'updated', trackable_type: 'Document') }

        it 'returns updated description' do
          description = component.send(:action_description)
          expect(description).to include('updated')
          expect(description).to include('Document')
        end
      end

      context 'when action is deleted' do
        let(:activity) { build(:activity, action: 'deleted', trackable_type: 'Document') }

        it 'returns deleted description' do
          description = component.send(:action_description)
          expect(description).to include('deleted')
          expect(description).to include('Document')
        end
      end

      context 'when action is unknown' do
        let(:activity) { build(:activity, action: 'unknown', trackable_type: 'Document') }

        it 'returns unknown description' do
          description = component.send(:action_description)
          expect(description).to include('unknown')
          expect(description).to include('Document')
        end
      end

      context 'when trackable_type is nil' do
        let(:activity) { build(:activity, action: 'created', trackable_type: nil) }

        it 'handles nil trackable_type gracefully' do
          description = component.send(:action_description)
          expect(description).to include('created')
          expect(description).to include('item')
        end
      end
    end

    describe '#formatted_time' do
      let(:activity) { build(:activity, created_at: Time.current) }

      it 'formats time correctly' do
        time = component.send(:formatted_time)
        expect(time).to be_a(String)
        expect(time).not_to be_empty
      end

      context 'when created_at is nil' do
        let(:activity) { build(:activity, created_at: nil) }

        it 'handles nil time gracefully' do
          time = component.send(:formatted_time)
          expect(time).to eq('Unknown time')
        end
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :item_classes,
          :avatar_classes,
          :body_classes,
          :action_icon,
          :action_color,
          :action_description,
          :formatted_time,
          :activity
        )
      end

      it 'includes Rails helpers' do
        context = component.send(:template_context)
        expect(context).to include(
          :link_to,
          :time_ago_in_words
        )
      end

      it 'includes ActiveRecord module' do
        context = component.send(:template_context)
        expect(context).to include(:ActiveRecord)
      end

      it 'includes method references for dynamic helpers' do
        context = component.send(:template_context)
        expect(context[:link_to]).to respond_to(:call)
        expect(context[:time_ago_in_words]).to respond_to(:call)
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders activity with correct structure' do
      render_inline(component)
      expect(page).to have_css('.TimelineItem')
      expect(page).to have_css('.TimelineItem-avatar')
      expect(page).to have_css('.TimelineItem-body')
    end

    it 'renders action description' do
      render_inline(component)
      expect(page).to have_content('created')
      expect(page).to have_content('Document')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.TimelineItem.py-3')
    end

    it 'renders with custom classes' do
      custom_component = described_class.new(activity: activity, class: 'custom-class')
      render_inline(custom_component)
      expect(page).to have_css('.custom-class')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different activity actions correctly' do
      different_activity = build(:activity, action: 'updated', trackable_type: 'Folder')
      different_component = described_class.new(activity: different_activity)
      icon = different_component.send(:action_icon)
      color = different_component.send(:action_color)
      description = different_component.send(:action_description)

      expect(icon).to eq('pencil')
      expect(color).to eq('color-bg-attention')
      expect(description).to include('updated')
      expect(description).to include('Folder')
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)

      # Test that all required methods are callable
      expect { context[:item_classes] }.not_to raise_error
      expect { context[:avatar_classes] }.not_to raise_error
      expect { context[:body_classes] }.not_to raise_error
      expect { context[:action_icon] }.not_to raise_error
      expect { context[:action_color] }.not_to raise_error
      expect { context[:action_description] }.not_to raise_error
      expect { context[:formatted_time] }.not_to raise_error
    end

    it 'integrates with Rails helpers' do
      context = component.send(:template_context)

      # Test that Rails helpers are available and callable
      expect(context[:link_to]).to respond_to(:call)
      expect(context[:time_ago_in_words]).to respond_to(:call)
    end

    it 'handles activity object correctly' do
      context = component.send(:template_context)
      expect(context[:activity]).to eq(activity)
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil activity gracefully' do
      nil_activity_component = described_class.new(activity: nil)
      expect { nil_activity_component.send(:item_classes) }.not_to raise_error
    end

    it 'handles activity with nil action gracefully' do
      nil_action_activity = build(:activity, action: nil)
      nil_action_component = described_class.new(activity: nil_action_activity)
      expect { nil_action_component.send(:action_icon) }.not_to raise_error
      expect { nil_action_component.send(:action_color) }.not_to raise_error
      expect { nil_action_component.send(:action_description) }.not_to raise_error
    end

    it 'handles activity with nil trackable_type gracefully' do
      nil_trackable_activity = build(:activity, trackable_type: nil)
      nil_trackable_component = described_class.new(activity: nil_trackable_activity)
      expect { nil_trackable_component.send(:action_description) }.not_to raise_error
    end

    it 'handles activity with nil created_at gracefully' do
      nil_time_activity = build(:activity, created_at: nil)
      nil_time_component = described_class.new(activity: nil_time_activity)
      expect { nil_time_component.send(:formatted_time) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(activity: activity)
      expect { minimal_component.send(:item_classes) }.not_to raise_error
    end
  end

  # Action Mapping Tests
  describe 'Action mapping' do
    context 'with different action types' do
      it 'maps created action correctly' do
        created_activity = build(:activity, action: 'created')
        created_component = described_class.new(activity: created_activity)

        expect(created_component.send(:action_icon)).to eq('plus')
        expect(created_component.send(:action_color)).to eq('color-bg-success')
      end

      it 'maps updated action correctly' do
        updated_activity = build(:activity, action: 'updated')
        updated_component = described_class.new(activity: updated_activity)

        expect(updated_component.send(:action_icon)).to eq('pencil')
        expect(updated_component.send(:action_color)).to eq('color-bg-attention')
      end

      it 'maps deleted action correctly' do
        deleted_activity = build(:activity, action: 'deleted')
        deleted_component = described_class.new(activity: deleted_activity)

        expect(deleted_component.send(:action_icon)).to eq('trash')
        expect(deleted_component.send(:action_color)).to eq('color-bg-danger')
      end

      it 'maps unknown action correctly' do
        unknown_activity = build(:activity, action: 'unknown')
        unknown_component = described_class.new(activity: unknown_activity)

        expect(unknown_component.send(:action_icon)).to eq('circle')
        expect(unknown_component.send(:action_color)).to eq('color-bg-muted')
      end
    end
  end

  # Trackable Type Tests
  describe 'Trackable type handling' do
    context 'with different trackable types' do
      it 'handles Document type' do
        document_activity = build(:activity, action: 'created', trackable_type: 'Document')
        document_component = described_class.new(activity: document_activity)
        description = document_component.send(:action_description)
        expect(description).to include('Document')
      end

      it 'handles Folder type' do
        folder_activity = build(:activity, action: 'created', trackable_type: 'Folder')
        folder_component = described_class.new(activity: folder_activity)
        description = folder_component.send(:action_description)
        expect(description).to include('Folder')
      end

      it 'handles User type' do
        user_activity = build(:activity, action: 'created', trackable_type: 'User')
        user_component = described_class.new(activity: user_activity)
        description = user_component.send(:action_description)
        expect(description).to include('User')
      end

      it 'handles nil trackable_type' do
        nil_trackable_activity = build(:activity, action: 'created', trackable_type: nil)
        nil_trackable_component = described_class.new(activity: nil_trackable_activity)
        description = nil_trackable_component.send(:action_description)
        expect(description).to include('item')
      end
    end
  end

  # CSS Classes Tests
  describe 'CSS classes' do
    it 'applies correct base classes' do
      classes = component.send(:item_classes)
      expect(classes).to include('TimelineItem', 'py-3')
    end

    it 'applies correct avatar classes' do
      classes = component.send(:avatar_classes)
      expect(classes).to include('TimelineItem-avatar')
    end

    it 'applies correct body classes' do
      classes = component.send(:body_classes)
      expect(classes).to include('TimelineItem-body')
    end

    it 'includes custom classes from system arguments' do
      custom_component = described_class.new(activity: activity, class: 'custom-class')
      classes = custom_component.send(:item_classes)
      expect(classes).to include('custom-class')
    end
  end

  # Activity Object Integration Tests
  describe 'Activity object integration' do
    it 'accesses activity action correctly' do
      context = component.send(:template_context)
      expect(context[:activity].action).to eq('created')
    end

    it 'accesses activity trackable_type correctly' do
      context = component.send(:template_context)
      expect(context[:activity].trackable_type).to eq('Document')
    end

    it 'accesses activity created_at correctly' do
      context = component.send(:template_context)
      expect(context[:activity].created_at).to be_present
    end

    it 'handles activity with different attributes' do
      custom_activity = build(:activity, action: 'updated', trackable_type: 'Folder')
      custom_component = described_class.new(activity: custom_activity)
      context = custom_component.send(:template_context)
      expect(context[:activity].action).to eq('updated')
      expect(context[:activity].trackable_type).to eq('Folder')
    end
  end
end
