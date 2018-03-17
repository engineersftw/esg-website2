class Presentation < ApplicationRecord
  attr_accessor :recording_id
  attr_accessor :event_id

  enum status: { deleted: 0, draft: 1, processing: 2, unpublished: 8, scheduled: 9, published: 10 }

  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items
  has_many :event_videos
  has_many :events, through: :event_videos

  scope :active, -> { where(published: true) }

  def has_video_link?
    video_id.present? && video_source.present?
  end

  def video_link
    if video_source == 'youtube'
      "https://youtu.be/#{video_id}"
    elsif video_source == 'vimeo'
      "https://vimeo.com/#{video_id}"
    end
  end

  def self.from_youtube(youtube_object)
    self.new(
      published: true,
      status: :published,
      video_source: 'youtube',
      video_id: youtube_object.id,
      title: youtube_object.snippet.title,
      presented_at: youtube_object.snippet.published_at,
      description: youtube_object.snippet.description,
      image1: youtube_object.snippet.thumbnails.default.url,
      image2: youtube_object.snippet.thumbnails.medium.url,
      image3: youtube_object.snippet.thumbnails.high.url
    )
  end
end
