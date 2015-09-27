ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include Devise::TestHelpers

  def random_string(length)
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten

    (0...length).map { o[rand(o.length)] }.join
  end

  def authenticate
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in thinkers(:admin)
  end
end
