namespace :engineerssg do
  desc "Gets list of videos from the playlist"
  task update_playlist: :environment do
    puts 'Starting to pull YouTube Playlist'

    youtube_channel = Identity.order('created_at').find_by(provider: 'google_plus')
    youtube_service = YoutubeService.new(access_token: youtube_channel.access_token, refresh_token: youtube_channel.refresh_token)

    Playlist.active.where(playlist_source: 'youtube').each do |playlist|
      puts 'Retrieving Playlist Info from YouTube... for ' + playlist.playlist_uid

      playlist_info = youtube_service.fetch_playlist_details(playlist.playlist_uid)
      playlist.title = playlist_info.snippet.title
      playlist.publish_date = playlist_info.snippet.published_at
      playlist.description = playlist_info.snippet.description if playlist.description.blank?
      playlist.image = playlist_info.snippet.thumbnails.high.url
      playlist.save

      items = youtube_service.retrieve_playlist(playlist.playlist_uid)
      puts "#{items.count} items found..."

      items.each_with_index do |item, index|
        video = Presentation.find_or_initialize_by(video_source: 'youtube', video_id: item[:video_id]) do |v|
          v.status = :published
        end

        video.title = item[:title] if video.title.try(:blank?)
        video.description = item[:description] if video.description.blank?
        video.presented_at = item[:published_at]
        video.image1 = item[:image1]
        video.image2 = item[:image2]
        video.image3 = item[:image3]
        video.save

        playlist_item = PlaylistItem.find_or_initialize_by(playlist: playlist, presentation: video)
        playlist_item.sort_order = index
        playlist_item.save
      end
    end
  end

  desc 'Twitter profile images'
  task fetch_twitter_avatar: :environment do

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.bearer_token        = ENV['TWITTER_BEARER_TOKEN']
    end

    presenters = Presenter.where("twitter <> ''").all

    presenters.map(&:twitter).each_slice(100) do |presenter_slice|
      client.users(*presenter_slice).each do |user|
        presenter = presenters.find{|u| u.twitter.downcase == user.screen_name.downcase}
        avatar_image = user.profile_image_uri_https('200x200').to_s.gsub(/\_normal$/, '')

        puts "#{presenter.try(:name)} - #{user.screen_name} - #{avatar_image}"
        presenter.update(avatar_url: avatar_image) if presenter
      end
    end
  end

  desc 'Update view count'
  task fetch_video_stats: :environment do
    puts 'Retrieving YouTube Videos...'

    youtube_channel = Identity.order('created_at').find_by(provider: 'google_plus')
    youtube_service = YoutubeService.new(access_token: youtube_channel.access_token, refresh_token: youtube_channel.refresh_token)

    Presentation.where(video_source: 'youtube').find_in_batches(batch_size: 50) do |batch|
      video_ids = batch.map(&:video_id)
      youtube_videos = youtube_service.fetch_video_stats(video_ids)

      batch_update = {}
      youtube_videos.each do |video_item|
        # puts "Updating view count for #{video_item.id} with #{video_item.statistics.view_count}"

        episode = batch.select{|v| v.video_id == video_item.id }.first
        batch_update[episode.id] = { view_count: video_item.statistics.view_count }
      end

      puts 'Batch update now...'
      puts batch_update
      Presentation.update( batch_update.keys, batch_update.values )
    end

    # puts '=================================================='
    # puts 'Retrieving Vimeo Videos...'
    #
    # vimeo_batch_update = {}
    #
    # vimeo_episodes = Presentation.where(video_site: 'vimeo').all
    # puts "Updating video stats for #{vimeo_episodes.count} videos."
    #
    # vimeo_service = VimeoService.new
    # vimeo_videos = vimeo_service.get_uploaded_videos
    #
    # vimeo_videos.each do |video_item|
    #   episode = vimeo_episodes.select{ |v| v.video_id == video_item[:video_id] }.first
    #
    #   next if episode.nil?
    #
    #   vimeo_batch_update[episode.id] = {view_count: video_item[:view_count]}
    # end
    #
    # puts 'Batch update now...'
    # puts vimeo_batch_update
    # Presentation.update( vimeo_batch_update.keys, vimeo_batch_update.values )
  end
end
