#!/usr/bin/env ruby 
# app.rb
require 'sinatra'
require 'curb'
require 'json'

get '/' do
  'Hello Permafrast!'
end

get '/json/:vol/:reporter/:page' do
  d = {"Context"=>{"ServiceAccountContext"=>ENV["FASTCASE_API_TOKEN"]}, "Request"=>{"Citations"=> [{"Volume"=>params["vol"].to_i, "Reporter"=>params["reporter"], "Page"=>params["page"].to_i}]}}
  res = Curl::Easy.http_post("https://services.fastcase.com/REST/ResearchServices.svc/GetPublicLink", d.to_json) do |curl|
    curl.headers["Content-Type"] = "application/json"
  end
  res.body_str.to_json
end

get '/info/:vol/:reporter/:page' do
  d = {"Context"=>{"ServiceAccountContext"=>ENV["FASTCASE_API_TOKEN"]}, "Request"=>{"Citations"=> [{"Volume"=>params["vol"].to_i, "Reporter"=>params["reporter"], "Page"=>params["page"].to_i}]}}
  res = Curl::Easy.http_post("https://services.fastcase.com/REST/ResearchServices.svc/GetPublicLink", d.to_json) do |curl|
    curl.headers["Content-Type"] = "application/json"
  end
  out = JSON.parse(res.body_str)
  erb :app, :locals => {"out"=>out}
end