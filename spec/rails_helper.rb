require 'coveralls'
Coveralls.wear_merged!('rails')
require 'spec_helper'
require 'webmock/rspec'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'stripe_mock'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include ResponseJSON
  config.before(:each) do
    fixture_file = File.open("#{fixture_path}/movie_titles.json").read
    stub_request(
      :get,
      "https://api.themoviedb.org/3/discover/movie?api_key=#{
        Rails.application.credentials.moviedb[:api_key]
      }&include_adult=false&language=en-US&page=1&sort_by=popularity.desc"
    ).to_return(status: 200, body: fixture_file, headers: {})

    # .with(
    #   headers: {
    #     'Accept' => '*/*',
    #     'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #     'Host' => 'api.themoviedb.org',
    #     'User-Agent' => 'rest-client/2.1.0 (linux-gnu x86_64) ruby/2.5.1p57'
    #   }
    # )
  end
  config.before(:each) { StripeMock.start }
  config.after(:each) { StripeMock.stop }
end
