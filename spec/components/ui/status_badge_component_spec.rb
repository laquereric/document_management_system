require 'rails_helper'

RSpec.describe Ui::StatusBadgeComponent, type: :component do
  let(:status) { build(:status, name: 'Active', color: '#28a745') }
  let(:component) { described_class.new(status: status) }

  # Ruby Logic Tests
  describe 'Ruby logic' do
    describe '#badge_classes' do
      it 'returns base badge classes' do
        classes = component.send(:badge_classes)
        expect(classes).to include('Label')
        expect(classes).to include('Label--secondary')
        expect(classes).to include('mr-1')
      end

      it 'includes custom classes from system arguments' do
        custom_component = described_class.new(status: status, class: 'custom-badge')
        classes = custom_component.send(:badge_classes)
        expect(classes).to include('custom-badge')
      end
    end

    describe '#badge_style' do
      it 'returns inline style with background color' do
        style = component.send(:badge_style)
        expect(style).to include('background-color: #28a745')
      end

      it 'returns inline style with contrast color' do
        style = component.send(:badge_style)
        expect(style).to include('color:')
      end

      context 'with light background color' do
        let(:status) { build(:status, name: 'Active', color: '#ffffff') }

        it 'uses dark text color' do
          style = component.send(:badge_style)
          expect(style).to include('color: #000000')
        end
      end

      context 'with dark background color' do
        let(:status) { build(:status, name: 'Active', color: '#000000') }

        it 'uses light text color' do
          style = component.send(:badge_style)
          expect(style).to include('color: #ffffff')
        end
      end
    end

    describe '#contrast_color' do
      it 'returns black for light colors' do
        color = component.send(:contrast_color, '#ffffff')
        expect(color).to eq('#000000')
      end

      it 'returns white for dark colors' do
        color = component.send(:contrast_color, '#000000')
        expect(color).to eq('#ffffff')
      end

      it 'returns black for medium gray' do
        color = component.send(:contrast_color, '#808080')
        expect(color).to eq('#000000')
      end

      it 'returns white for dark gray' do
        color = component.send(:contrast_color, '#404040')
        expect(color).to eq('#ffffff')
      end

      it 'handles hex colors without #' do
        color = component.send(:contrast_color, 'ffffff')
        expect(color).to eq('#000000')
      end

      it 'handles various color formats' do
        expect(component.send(:contrast_color, '#ff0000')).to eq('#000000') # Red
        expect(component.send(:contrast_color, '#00ff00')).to eq('#000000') # Green
        expect(component.send(:contrast_color, '#0000ff')).to eq('#ffffff') # Blue
        expect(component.send(:contrast_color, '#ffff00')).to eq('#000000') # Yellow
      end
    end

    describe '#template_context' do
      it 'includes all required context variables' do
        context = component.send(:template_context)
        expect(context).to include(
          :badge_classes,
          :badge_style,
          :status
        )
      end
    end
  end

  # ERB Rendering Tests
  describe 'ERB rendering' do
    it 'renders without errors' do
      expect { render_inline(component) }.not_to raise_error
    end

    it 'renders status name' do
      render_inline(component)
      expect(page).to have_content('Active')
    end

    it 'renders badge with correct structure' do
      render_inline(component)
      expect(page).to have_css('.Label')
      expect(page).to have_css('.Label--secondary')
    end

    it 'applies inline styles' do
      render_inline(component)
      expect(page).to have_css('[style*="background-color: #28a745"]')
    end

    it 'applies correct CSS classes' do
      render_inline(component)
      expect(page).to have_css('.Label.Label--secondary.mr-1')
    end

    it 'renders with custom classes' do
      custom_component = described_class.new(status: status, class: 'custom-class')
      render_inline(custom_component)
      expect(page).to have_css('.custom-class')
    end
  end

  # Integrated Tests
  describe 'Integrated functionality' do
    it 'handles different status names correctly' do
      different_status = build(:status, name: 'Pending', color: '#ffc107')
      different_component = described_class.new(status: different_status)
      render_inline(different_component)
      expect(page).to have_content('Pending')
    end

    it 'handles different status colors correctly' do
      different_status = build(:status, name: 'Active', color: '#dc3545')
      different_component = described_class.new(status: different_status)
      render_inline(different_component)
      expect(page).to have_css('[style*="background-color: #dc3545"]')
    end

    it 'provides all necessary context for template rendering' do
      context = component.send(:template_context)
      
      # Test that all required methods are callable
      expect { context[:badge_classes] }.not_to raise_error
      expect { context[:badge_style] }.not_to raise_error
      expect { context[:status] }.not_to raise_error
    end

    it 'handles status object correctly' do
      context = component.send(:template_context)
      expect(context[:status]).to eq(status)
    end
  end

  # Edge Cases and Error Handling
  describe 'Edge cases and error handling' do
    it 'handles nil status gracefully' do
      nil_status_component = described_class.new(status: nil)
      expect { nil_status_component.send(:badge_classes) }.not_to raise_error
      expect { nil_status_component.send(:badge_style) }.not_to raise_error
    end

    it 'handles status with nil name gracefully' do
      nil_name_status = build(:status, name: nil, color: '#28a745')
      nil_name_component = described_class.new(status: nil_name_status)
      expect { nil_name_component.send(:badge_classes) }.not_to raise_error
    end

    it 'handles status with nil color gracefully' do
      nil_color_status = build(:status, name: 'Active', color: nil)
      nil_color_component = described_class.new(status: nil_color_status)
      expect { nil_color_component.send(:badge_style) }.not_to raise_error
    end

    it 'handles status with empty color gracefully' do
      empty_color_status = build(:status, name: 'Active', color: '')
      empty_color_component = described_class.new(status: empty_color_status)
      expect { empty_color_component.send(:badge_style) }.not_to raise_error
    end

    it 'handles missing system arguments gracefully' do
      minimal_component = described_class.new(status: status)
      expect { minimal_component.send(:badge_classes) }.not_to raise_error
    end
  end

  # Color Contrast Logic Tests
  describe 'Color contrast logic' do
    context 'with various color combinations' do
      it 'handles pure white' do
        color = component.send(:contrast_color, '#ffffff')
        expect(color).to eq('#000000')
      end

      it 'handles pure black' do
        color = component.send(:contrast_color, '#000000')
        expect(color).to eq('#ffffff')
      end

      it 'handles red' do
        color = component.send(:contrast_color, '#ff0000')
        expect(color).to eq('#000000')
      end

      it 'handles green' do
        color = component.send(:contrast_color, '#00ff00')
        expect(color).to eq('#000000')
      end

      it 'handles blue' do
        color = component.send(:contrast_color, '#0000ff')
        expect(color).to eq('#ffffff')
      end

      it 'handles yellow' do
        color = component.send(:contrast_color, '#ffff00')
        expect(color).to eq('#000000')
      end

      it 'handles cyan' do
        color = component.send(:contrast_color, '#00ffff')
        expect(color).to eq('#000000')
      end

      it 'handles magenta' do
        color = component.send(:contrast_color, '#ff00ff')
        expect(color).to eq('#000000')
      end

      it 'handles gray' do
        color = component.send(:contrast_color, '#808080')
        expect(color).to eq('#000000')
      end

      it 'handles dark gray' do
        color = component.send(:contrast_color, '#404040')
        expect(color).to eq('#ffffff')
      end
    end

    context 'with invalid color formats' do
      it 'handles nil color' do
        expect { component.send(:contrast_color, nil) }.not_to raise_error
      end

      it 'handles empty color' do
        expect { component.send(:contrast_color, '') }.not_to raise_error
      end

      it 'handles invalid hex color' do
        expect { component.send(:contrast_color, 'invalid') }.not_to raise_error
      end

      it 'handles short hex color' do
        expect { component.send(:contrast_color, '#fff') }.not_to raise_error
      end
    end
  end

  # CSS Classes Tests
  describe 'CSS classes' do
    it 'applies correct base classes' do
      classes = component.send(:badge_classes)
      expect(classes).to include('Label', 'Label--secondary', 'mr-1')
    end

    it 'includes custom classes from system arguments' do
      custom_component = described_class.new(status: status, class: 'custom-class')
      classes = custom_component.send(:badge_classes)
      expect(classes).to include('custom-class')
    end

    it 'handles multiple custom classes' do
      custom_component = described_class.new(status: status, class: 'class1 class2')
      classes = custom_component.send(:badge_classes)
      expect(classes).to include('class1', 'class2')
    end
  end

  # Status Object Integration Tests
  describe 'Status object integration' do
    it 'accesses status name correctly' do
      context = component.send(:template_context)
      expect(context[:status].name).to eq('Active')
    end

    it 'accesses status color correctly' do
      context = component.send(:template_context)
      expect(context[:status].color).to eq('#28a745')
    end

    it 'handles status with different attributes' do
      custom_status = build(:status, name: 'Custom Status', color: '#6f42c1')
      custom_component = described_class.new(status: custom_status)
      context = custom_component.send(:template_context)
      expect(context[:status].name).to eq('Custom Status')
      expect(context[:status].color).to eq('#6f42c1')
    end
  end
end
