# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create do |t|
  t.test_prelude = 'require "test_helper"'
end

require "standard/rake"

desc "Validate RBS type signatures"
task "rbs:validate" do
  sh "bundle exec rbs -I sig validate"
end

task default: %i[test standard rbs:validate]
