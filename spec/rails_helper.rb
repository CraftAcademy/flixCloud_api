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
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  fixture_file = File.open("#{fixture_path}/subscription_user.json").read
  stub_request(:post, "https://api.stripe.com/v1/customers").
  with(
    body: {"description"=>"Subscription for flixcloud", "email"=>"user@mail.com"},
    headers: {
    'Accept'=>'*/*',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Authorization'=>'Bearer sk_test_51HuxhoEDdj3L9cb715HzaflPkurAaXbr0fNGlrsUzlEe3C5SMUJOzXdBwuh95vOtN89bBg6ZMKjK3XoErKMi0PLC00ViDmDsi6',
    'Content-Type'=>'application/x-www-form-urlencoded',
    'User-Agent'=>'Stripe/v1 RubyBindings/5.28.0',
    'X-Stripe-Client-User-Agent'=>'{"bindings_version":"5.28.0","lang":"ruby","lang_version":"2.5.1 p57 (2018-03-29)","platform":"x86_64-darwin19","engine":"ruby","publisher":"stripe","uname":"Darwin MacBook-Air.local 19.6.0 Darwin Kernel Version 19.6.0: Mon Aug 31 22:12:52 PDT 2020; root:xnu-6153.141.2~1/RELEASE_X86_64 x86_64","hostname":"MacBook-Air.local"}'
    }).
  to_return(status: 200, body: "fixture_file", headers: {})
end
