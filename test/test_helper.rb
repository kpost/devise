ENV["RAILS_ENV"] = "test"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym

$:.unshift File.dirname(__FILE__)
puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"

require "rails_app/config/environment"
require "rails/test_help"
require "orm/#{DEVISE_ORM}"

I18n.load_path << File.expand_path("../support/locale/en.yml", __FILE__)

require 'mocha/setup'
require 'webrat'
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

OmniAuth.config.logger = Logger.new('/dev/null')

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:my_tests_are_order_dependent!)
  # Devise test suite is order dependent, and we need to ensure that same order
  # in Rails 4.2.0.
  ActiveSupport::TestCase.my_tests_are_order_dependent!
end

# For generators
require "rails/generators/test_case"
require "generators/devise/install_generator"
require "generators/devise/views_generator"
