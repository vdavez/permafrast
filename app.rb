#!/usr/bin/env ruby 
# app.rb
require 'sinatra'
require 'curb'
require 'json'
require 'fastcase'

get '/' do
  'Hello Permafrast!'
end

get '/json/:vol/:reporter/:page' do
  ::Fastcase::Client.new(
    ENV["FASTCASE_API_TOKEN"]
  ).public_link(
    volume: params["vol"],
    reporter: params["reporter"],
    page: params["page"]
  ).to_json
end

get '/info/:vol/:reporter/:page' do
  out = JSON.parse(
    ::Fastcase::Client.new(
      ENV["FASTCASE_API_TOKEN"]
    ).public_link(
      volume: params["vol"],
      reporter: params["reporter"],
      page: params["page"]
    )
  )
  erb :app, :locals => {"out"=>out}
end
