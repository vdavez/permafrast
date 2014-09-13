# encoding: UTF-8

require 'open-uri'

class ContentFetcher
  def initialize(options={url: nil})
    @url = options[:url]
  end

  attr_accessor :url, :doc

  def extract
    doc.css("#theDocument").first.to_s
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(open(url), 'UTF-8')
  end
end
