class StreamerService
  def initialize(base_url=ENV['STREAMER_URL'])
    @base_url = base_url
  end

  def screenshots(name, start_time, end_time)
    query = { name: name, start_time: start_time.to_i, end_time: end_time.to_i }
    screenshots = fetch '/screenshots.php', query

    screenshots[:data][:files].map{ |f| ENV['STREAMER_URL'] + f }
  end

  private

  def fetch(path, query={})
    response = conn.get path, query
    JSON.parse response.body, symbolize_names: true
  end

  def conn
    @conn ||= Faraday.new(url: @base_url)
  end
end