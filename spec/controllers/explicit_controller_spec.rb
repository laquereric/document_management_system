require 'spec_helper'

# Require minimal Rails components
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_record/railtie'
require 'rails'

# Require gems used by the application
# require 'devise' # Removed - using custom authentication
require 'cancan'

# Explicitly require the controller we want to test
require_relative '../../app/controllers/application_controller'

RSpec.describe ApplicationController, type: :controller do
  it "can be instantiated" do
    expect(ApplicationController.new).to be_an_instance_of(ApplicationController)
  end
end
