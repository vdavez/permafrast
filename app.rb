#!/usr/bin/env ruby 
# app.rb
require 'sinatra'
require './environments'
require 'curb'
require 'json'
require 'fastcase'
require 'sinatra/respond_with'
require "sinatra/activerecord"
require 'pry'

if settings.development?
  require 'dotenv'
  Dotenv.load
end

# Autoload everything in models and use cases folder
["models", "use_cases"].each do |target|
  Dir[File.dirname(__FILE__) + "/#{target}/**/*.rb"].each do |file| 
    puts "including #{file}"
    require file
  end
end

before(/.*/) do
  if request.url.match(/.json$/)
    request.accept.unshift('application/json')
    request.path_info = request.path_info.gsub(/.json$/,'')
  end
end

get '/' do
  'Hello Permafrast!'
end

get '/:vol/:reporter/:page' do
  binding.pry
  data = Cacher.new(
    volume: params["vol"],
    reporter: params["reporter"],
    page: params["page"]
  ).cache!

  respond_to do |f|
    f.json do
      [data].to_json(only:[
        :volume,
        :reporter,
        :page,
        :url,
        :full_citation
      ])
    end

    f.html do
      erb :app, :locals => {"out"=>data}
    end
  end
end

get '/:vol/:reporter/:page/redirect' do
  data = Cacher.new(
    volume: params["vol"],
    reporter: params["reporter"],
    page: params["page"]
  ).cache!

  redirect data.url
end
