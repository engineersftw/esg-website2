require 'google/apis/youtube_v3'

class YoutubeService
  def initialize(
      access_token:,
      refresh_token: nil,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET']
  )
    @access_token = access_token
    @refresh_token = refresh_token
    @client_id = client_id
    @client_secret = client_secret
  end

  def get_video(video_id)
    api_response = api_client.list_videos('snippet,status', id: video_id)
    video_item = api_response.items.first

    video_item
  end

  private

  def api_client
    @service ||= Google::Apis::YoutubeV3::YouTubeService.new.tap do |service|
      service.authorization = authorization
    end
  end

  def authorization
    @authorization ||= GoogleAuthService.new.client(access_token: @access_token, refresh_token: @refresh_token).tap do |client|
      client.refresh!
    end
  end
end