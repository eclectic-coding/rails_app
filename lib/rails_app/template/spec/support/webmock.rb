# frozen_string_literal: true

require "webmock/rspec"

RSpec.configure do |config|
  config.before(:all, type: :request) do
    WebMock.allow_net_connect!
  end

  config.before(:all, type: :system) do
    WebMock.allow_net_connect!
  end

  config.after(:all, type: :request) do
    selenium_requests = %r{/((__.+__)|(hub/session.*))$}
    WebMock.allow_net_connect! allow: selenium_requests
  end
end
