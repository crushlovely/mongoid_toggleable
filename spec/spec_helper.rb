require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'
require 'mongoid'
require 'mongoid_toggleable'
require 'mongoid-rspec'

def database_name
  ENV['CI'] ? "mongoid_toggleable_#{Process.pid}" : 'mongoid_toggleable_test'
end

def database_port
  ENV['BOXEN_MONGODB_PORT'] || '27017'
end

Mongoid.configure do |config|
  config.sessions = {
    :default => {
      :database => database_name,
      :hosts => ["localhost:#{database_port}"],
      :options => {
        :read => :primary
      }
    }
  }
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear if defined?(Mongoid::IdentityMap)
  end

  config.after(:suite) do
    Mongoid::Threaded.sessions[:default].drop if ENV['CI']
  end
end
