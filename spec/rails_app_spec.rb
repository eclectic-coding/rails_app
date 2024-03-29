# frozen_string_literal: true

RSpec.describe RailsApp do
  it "has a version number" do
    expect(RailsApp::VERSION).not_to be nil
  end
end
