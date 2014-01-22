# ENV['CODECLIMATE_REPO_TOKEN'] = "551514de28251b0f6281a204446c3ffdbdda092590b76e531b7d224c11194769"
# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start

require 'active_support'
require 'rspec'
require 'rspec/rails/mocks'
include Spec::Rails::Mocks

require 'elastical'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
end
