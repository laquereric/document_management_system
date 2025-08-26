# Simple test controller to demonstrate components
require 'ostruct'

class ComponentTestController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index] if Rails.env.development?
  
  def index
    # This would normally come from the database
    @sample_documents = [
      OpenStruct.new(
        id: 1,
        title: "Project Requirements Document",
        content: "This is a comprehensive document outlining the project requirements.",
        author: OpenStruct.new(email: "john.doe@example.com"),
        folder: OpenStruct.new(path: "Projects / Documentation", id: 1),
        status: OpenStruct.new(name: "review"),
        tags: [OpenStruct.new(name: "Important"), OpenStruct.new(name: "Draft")],
        updated_at: 2.hours.ago,
        file: OpenStruct.new(attached?: true, content_type: "application/pdf", byte_size: 1024000)
      ),
      OpenStruct.new(
        id: 2,
        title: "API Documentation",
        content: "Technical documentation for the REST API endpoints.",
        author: OpenStruct.new(email: "jane.smith@example.com"),
        folder: OpenStruct.new(path: "Documentation / API", id: 2),
        status: OpenStruct.new(name: "approved"),
        tags: [OpenStruct.new(name: "Technical")],
        updated_at: 1.day.ago,
        file: OpenStruct.new(attached?: false)
      )
    ]
  end
end
