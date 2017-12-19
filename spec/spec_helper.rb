# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'emittance/resque'

require 'active_record'

Dir[File.dirname(__FILE__) + "/fixtures/**/*.rb"].each { |f| require f }
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include BackgroundJobs

  config.around(:each) do |example|
    run_jobs_inline do
      example.run
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
