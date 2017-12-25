# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Home page' do
  before(:all) { get '/' }

  def page
    @page ||= Nokogiri::HTML(last_response.body)
  end

  it 'loads the page' do
    expect(last_response).to be_ok
  end

  it 'loads the donation form' do
    expect(page.css('#payment-form').count).to eq(1)
  end

  it 'links to the main css' do
    expect(page.css('link[href="css/main.css"]').count).to eq(1)
  end

  it 'links to the main js' do
    expect(page.css('script[src="js/bundle.js"]').count).to eq(1)
  end

  describe 'amount section' do
    it 'displays a donation type' do
      expect(last_response.body).to include('one-off')
    end

    it 'displays a donation currency' do
      expect(last_response.body).to include('GBP')
    end

    it 'displays a donation amount' do
      expect(page.css('input#amount').count).to eq(1)
    end
  end

  describe 'gift aid section' do
    it 'displays a gift aid selector' do
      expect(page.css('input#giftaid-yes').count).to eq(1)
      expect(page.css('input#giftaid-no').count).to eq(1)
    end
  end

  describe 'payment information section' do
    it 'displays a payment type selector' do
      expect(last_response.body).to include('Credit card')
    end
  end

  it 'displays the submit button' do
    expect(page.css('#submit-button').count).to eq(1)
  end
end
