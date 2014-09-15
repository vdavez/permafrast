require 'nokogiri'

class Cacher
  def initialize(options={volume: nil, reporter: nil, page: page})
    @volume = options[:volume]
    @reporter = options[:reporter]
    @page = options[:page]
  end

  attr_accessor :volume, :reporter, :page, :cached_entry
  
  def self.cache_with_params!(params)
    Cacher.new(
      volume: params["vol"],
      reporter: params["reporter"],
      page: params["page"]
    ).cache!
  end

  def cache!
    if cached_record && cached_record.fetched_page.present?
      cached_record
    else
      store_record(get_record)
      cached_entry.fetched_page = document_content
      cached_entry.save
      cached_entry
    end
  end

  private

  def cached_record
    @cached_record ||= CallCache.where(
        volume: volume,
        reporter: reporter,
        page: page
    ).first
  end

  def get_record
    @get_record ||= JSON.parse(::Fastcase::Client.new(
      ENV["FASTCASE_API_TOKEN"]
    ).public_link(
      volume: volume,
      reporter: reporter,
      page: page
    ))
  end

  def store_record(record)
    @cached_entry ||= CallCache.create(
      volume: volume,
      reporter: reporter,
      page: page,
      url: get_record["GetPublicLinkResult"]["Result"][0]["Url"],
      full_citation:  get_record["GetPublicLinkResult"]["Result"][0]["FullCitation"]
    )
  end

  def document_content
    @document_content ||= ::ContentFetcher.new(url: cached_entry.url).extract
  end
end
