# Create default statuses
statuses = [
  { name: 'Draft', description: 'Document is in draft state', color: '#6c757d' },
  { name: 'Pending', description: 'Document is pending review', color: '#ffc107' },
  { name: 'Approved', description: 'Document has been approved', color: '#28a745' },
  { name: 'Rejected', description: 'Document has been rejected', color: '#dc3545' },
  { name: 'Published', description: 'Document is published', color: '#007bff' }
]

statuses.each do |status_attrs|
  Status.find_or_create_by(name: status_attrs[:name]) do |status|
    status.description = status_attrs[:description]
    status.color = status_attrs[:color]
  end
end

# Create default scenarios
scenarios = [
  { name: 'Standard Document', description: 'Standard document workflow' },
  { name: 'Policy Document', description: 'Policy document requiring approval' },
  { name: 'Technical Specification', description: 'Technical specification document' },
  { name: 'User Manual', description: 'User manual or documentation' },
  { name: 'Report', description: 'Report or analysis document' }
]

scenarios.each do |scenario_attrs|
  Scenario.find_or_create_by(name: scenario_attrs[:name]) do |scenario|
    scenario.description = scenario_attrs[:description]
  end
end

# Create default tags
tags = [
  { name: 'Important', color: '#dc3545' },
  { name: 'Urgent', color: '#ffc107' },
  { name: 'Technical', color: '#007bff' },
  { name: 'Policy', color: '#6f42c1' },
  { name: 'Public', color: '#28a745' },
  { name: 'Internal', color: '#fd7e14' }
]

tags.each do |tag_attrs|
  Tag.find_or_create_by(name: tag_attrs[:name]) do |tag|
    tag.color = tag_attrs[:color]
  end
end

# Create sample organization
org = Organization.find_or_create_by(name: 'Sample Organization') do |organization|
  organization.description = 'A sample organization for demonstration'
end

# Create admin user
admin = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.name = 'System Administrator'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'admin'
  user.organization = org
end

# Create sample team
team = Team.find_or_create_by(name: 'Development Team') do |t|
  t.description = 'Software development team'
  t.organization = org
  t.leader = admin
end

# Create sample folder
folder = Folder.find_or_create_by(name: 'Project Documents') do |f|
  f.description = 'Main project documentation folder'
  f.team = team
end

# Create sample document
if Document.count == 0
  doc = Document.create!(
    title: 'Welcome Document',
    content: 'This is a sample document to demonstrate the system.',
    url: 'https://example.com/welcome',
    folder: folder,
    author: admin,
    status: Status.find_by(name: 'Draft'),
    scenario: Scenario.find_by(name: 'Standard Document')
  )

  # Add tags to document
  doc.tags << Tag.find_by(name: 'Important')
  doc.tags << Tag.find_by(name: 'Public')
end

puts "Seed data created successfully!"
puts "Admin user: admin@example.com / password123"
