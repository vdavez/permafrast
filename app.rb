#!/usr/bin/env ruby 
# app.rb
require 'sinatra'
require './environments'
require 'curb'
require 'json'
require 'fastcase'
require 'sinatra/respond_with'
require "sinatra/activerecord"

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
  data = ::Fastcase::Client.new(
    ENV["FASTCASE_API_TOKEN"]
  ).public_link(
    volume: params["vol"],
    reporter: params["reporter"],
    page: params["page"]
  )

  respond_to do |f|
    f.json {data}
    f.html { erb :app, :locals => {"out"=>JSON.parse(data)} }
  end
end
