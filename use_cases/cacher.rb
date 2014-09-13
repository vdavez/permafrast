class Cacher
  def initialize(options={volume: nil, reporter: nil, page: page})
    @volume = options[:volume]
    @reporter = options[:reporter]
    @page = options[:page]
  end

  attr_accessor :volume, :reporter, :page

  def cache!
    if cached_record
      cached_record
    else
      store_record(get_record)
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
    CallCache.create(
      volume: volume,
      reporter: reporter,
      page: page,
      url: get_record["GetPublicLinkResult"]["Result"][0]["Url"],
      full_citation:  get_record["GetPublicLinkResult"]["Result"][0]["FullCitation"]
    )
  end
end
