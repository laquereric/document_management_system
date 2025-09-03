#!/usr/bin/env ruby

# Simple test for Footer component
require_relative 'config/environment'

puts "Testing Footer component creation..."
begin
  component = Primer::Beta::BorderBox::Footer.new
  puts "✅ Footer component created successfully"
  puts "   Class: #{component.class.name}"
  puts "   Superclass: #{component.class.superclass.name}"

  # Test system arguments
  system_args = component.instance_variable_get(:@system_arguments)
  puts "   System arguments: #{system_args.inspect}"

  # Test footer classes method
  footer_classes = component.send(:footer_classes)
  puts "   Footer classes: '#{footer_classes}'"

  puts "\n✅ Footer component is working correctly!"

rescue => e
  puts "❌ Error creating Footer component: #{e.message}"
  puts e.backtrace.first(3)
end
