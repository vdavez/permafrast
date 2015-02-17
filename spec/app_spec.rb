require_relative '../app'
require 'rspec'
require 'rack/test'
require 'json'
require 'nokogiri'
require 'capybara/rspec'
require 'capybara-webkit'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.app = App
Capybara.javascript_driver = :webkit

module SpecConstants
  VOLUME        = 600
  REPORTER      = 'F.3d'
  PAGE          = 642
  URL           = "https://apps.fastcase.com/Research/Public/ExViewer.aspx?LTID=%2fGLQLe%2fDaGym1PLr4VyFrNW1GRW%2fFszkp5OJNGHvwRPnb22Q5oSdo7jrjk8wbX8Q"
  FULL_CITATION = "Comcast Corp. v. Fed. Commc'ns Comm'n, 600 F.3d 642 (D.C. Cir., 2010)"
  FETCHED_PAGE  = "Sample Page Content. This case cites to Am. Library Ass'n v. FCC, 406 F.3d 689, 692 (D.C.Cir. 2005)."
end

describe 'The App', type: :feature, :js => true do
  include Rack::Test::Methods
  
  before do
    # create a fake CallCache instance
    cc = CallCache.new
    cc.volume        = SpecConstants::VOLUME
    cc.reporter      = SpecConstants::REPORTER
    cc.page          = SpecConstants::PAGE
    cc.url           = SpecConstants::URL
    cc.full_citation = SpecConstants::FULL_CITATION
    cc.fetched_page  = SpecConstants::FETCHED_PAGE
    
    fake_response = cc
    cacher_instance = {}
    
    # mock instance of Cacher
    allow(cacher_instance).to(receive(:cache!)).and_return(fake_response)
    
    # return mocked instance of Cacher with a mock of its `new` method
    allow(Cacher).to(receive(:new)).and_return(cacher_instance)
  end

  def app
    App
  end

  it 'has a homepage' do
    get '/'
    # test http status code
    expect(last_response.status).to(eq(200))
    
    page = Nokogiri::HTML(last_response.body)
    # ensure Permafrast text is at the top of the page
    expect(page.at_css('body > div > h1:nth-child(1)').text).to(eq('Permafrast'))
  end
  
  it 'gets HTML' do
    url = "#{SpecConstants::VOLUME}/#{SpecConstants::REPORTER}/#{SpecConstants::PAGE}"
    get url, nil, {'HTTP_ACCEPT' => "text/html"}
    
    # test http status code
    expect(last_response.status).to(eq(200))
    
    page = Nokogiri::HTML(last_response.body)
    a_tag = page.at_css('a#full_citation')
    fetched_page_div = page.at_css('#fetched_page')
    
    # test fetched page content
    expect(fetched_page_div.text.strip).to(eq(SpecConstants::FETCHED_PAGE))
    
    # test link text
    expect(a_tag.text).to(eq(SpecConstants::FULL_CITATION))
    # test link href
    expect(a_tag.attributes['href'].value).to(eq(SpecConstants::URL))
  end
    
  it 'gets JSON' do
    url = "#{SpecConstants::VOLUME}/#{SpecConstants::REPORTER}/#{SpecConstants::PAGE}.json"
    get url, nil, {'HTTP_ACCEPT' => "application/json"}
    
    # test http status code
    expect(last_response.status).to(eq(200))
        
    json = JSON.parse(last_response.body)
    expected = {
      "volume"=>SpecConstants::VOLUME, 
      "reporter"=>SpecConstants::REPORTER, 
      "page"=>SpecConstants::PAGE, 
      "url"=>SpecConstants::URL, 
      "full_citation"=>SpecConstants::FULL_CITATION
    }
    
    # test the json response
    expect(json).to(include(expected))
  end
  
  it 'gets JSON with full text' do
    url = "#{SpecConstants::VOLUME}/#{SpecConstants::REPORTER}/#{SpecConstants::PAGE}.json?fulltext=true"
    get url, nil, {'HTTP_ACCEPT' => "application/json"}
    
    # test http status code
    expect(last_response.status).to(eq(200))
        
    json = JSON.parse(last_response.body)
    expected = {
      "volume"=>SpecConstants::VOLUME, 
      "reporter"=>SpecConstants::REPORTER, 
      "page"=>SpecConstants::PAGE, 
      "url"=>SpecConstants::URL, 
      "full_citation"=>SpecConstants::FULL_CITATION,
      "fetched_page"=>SpecConstants::FETCHED_PAGE
    }
    
    # test the json response
    expect(json).to(include(expected))
  end
  
  it 'turns legal citations into links' do
    
    url = "/#{SpecConstants::VOLUME}/#{SpecConstants::REPORTER}/#{SpecConstants::PAGE}"
    visit url

    # test http status code
    expect(page.status_code).to(eq(200))
            
    parsed_page = Nokogiri::HTML(page.html)
    
    citation_links = parsed_page.css('a.citation')
        
    expect(citation_links.length).to_not(eq(0))
  end
end