class VimeoService
  BASE_URL = 'https://api.vimeo.com'

  def initialize(base_url = ENV['STREAMER_URL'], access_key = ENV['VIMEO_BEARER_TOKEN'])
    @base_url = base_url || BASE_URL
    @access_key = access_key
  end

  def get_video(video_id)
    response_json = make_api_call "/videos/#{video_id}"

    Presentation.new(
      video_source: 'vimeo',
      video_id: video_id,
      title: response_json[:name],
      description: response_json[:description],
      presented_at: response_json[:created_time],
      image1: response_json[:pictures][:sizes][1][:link],
      image2: response_json[:pictures][:sizes][3][:link],
      image3: response_json[:pictures][:sizes][5][:link],
      view_count: response_json[:stats][:plays],
    )
  end

  def get_uploaded_videos
    items = []

    next_page_number = 1
    until next_page_number.nil?
      params = {
          page: next_page_number,
          per_page: 50
      }
      api_response = make_api_call '/me/videos', params
      api_response[:data].each do |video_item|
        video_uri = /\/videos\/(?<video_id>\S*)/.match(video_item[:uri])

        if video_uri.nil?
          puts "Invalid URI: #{video_item[:uri]}"
          next
        end

        item = {
            video_id: video_uri[:video_id],
            title: video_item[:name],
            description: video_item[:description],
            presented_at: video_item[:created_time],
            image1: video_item[:pictures][:sizes][1][:link],
            image2: video_item[:pictures][:sizes][3][:link],
            image3: video_item[:pictures][:sizes][5][:link],
            view_count: video_item[:stats][:plays],
        }
        items << item
      end

      next_page_number = api_response[:paging][:next]
    end

    items
  end

  private

  def make_api_call(path, params={})
    conn.authorization :bearer, @access_key
    response = conn.get path, params

    JSON.parse response.body, symbolize_names: true
  end

  def conn
    @conn ||= Faraday.new(url: @base_url)
  end
end
