# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Sinatra globals' do
  it 'sets the Stripe public key' do
    expect(app.settings.stripe_public_key).not_to be_nil
  end
end
