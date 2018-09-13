require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files = Dir["lib/**/*.rb"]
end

desc "Run tests"
task default: [:spec]

desc "Document the Library"
task doc: [:yard]

desc "List out API Routes"
task(:routes) do
  require 'naas/client'
  require 'terminal-table'

  directory         = Naas::Client.directory
  route_definitions = Naas::Client.routes

  row_display = ->(row,index) do
    [(index + 1), row.name, row.href, row.rel]
  end

  title    = "%s (%s)" % [directory.title, route_definitions.count]
  headings = ['#', 'Route Name', 'URL', 'Rel']
  rows     = route_definitions.each_with_index.map { |r,i| row_display.call(r,i) }

  table = Terminal::Table.new(title: title, headings: headings, rows: rows)
  puts "\n"
  puts table.to_s
  puts "\n"
end
