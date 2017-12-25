# frozen_string_literal: true

require 'sinatra'
require_relative 'donations'
require_relative 'helpers/asset_paths_generator'
require_relative 'page/error'
require_relative 'page/home'
require_relative 'page/success'

class DonationSystemWebapp < Sinatra::Base
  set :views, "#{settings.root}/../views"
  set :public_folder, "#{settings.root}/../public"
  set :stripe_public_key, ENV['STRIPE_PUBLIC_KEY']
  set :assets, 'https://assets.survivalinternational.org'
  set :asset_paths_generator, Helpers::AssetPathsGenerator.new(ENV['RACK_ENV'])

  get '/' do
    @page = Page::Home.new
    erb :home
  end

  post '/donations' do
    errors = Donations.donate(params)
    redirect '/success' if errors.empty?
    @page = Page::Error.new(errors)
    erb :error
  end

  get '/success' do
    @page = Page::Success.new(settings.assets)
    erb :success
  end
end
