#ENV['CODECLIMATE_REPO_TOKEN'] = "beeb6dab3e0aeb52f0a2fded3d0208c054c5382ba2b562b493eb74a505a63773"
#require "codeclimate-test-reporter"
#CodeClimate::TestReporter.start

require 'active_record'
require 'active_support'
require 'rspec'
require 'rspec/rails/mocks'
include Spec::Rails::Mocks

require 'elastical'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
end

# stub Rails object
class Rails
  def self.root
    File.expand_path File.dirname(__FILE__) + "/fixtures/"
  end

  def self.env
    "test"
  end
end


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
  )

ActiveRecord::Migration.create_table :posts do |t|
  t.integer :status_code
  t.timestamps
end


class SearchIndexWorker
  def self.perform_async(index_name, model_name, size, batch_size)
  end
end


# post model for some tests
class Post < ActiveRecord::Base
  scope :live,   -> { where("status_code = ?", 1) }
end
