source 'https://rubygems.org'
ruby '2.1.2'
	
gem 'sinatra'
gem 'curb'
gem 'rerun'
gem 'fastcase', git: "https://github.com/TalkingQuickly/fastcase.git"
gem 'sinatra-contrib'
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'redcarpet'
gem 'github-markup'
gem 'pry'
gem 'travis-lint'
gem 'travis'
gem 'rake'

group :test, :development do
  gem 'rspec'
  gem 'capybara'
  gem 'capybara-webkit'
end
 
group :test do
  gem 'rack-test'
end

gem 'nokogiri'

group :development do
   gem 'sqlite3'
   gem 'dotenv'
end

group :production do
  gem 'pg'
  gem 'rack-ssl-enforcer'
end
