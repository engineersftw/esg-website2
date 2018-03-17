class Presentation < ApplicationRecord
  attr_accessor :recording_id
  attr_accessor :event_id

  enum status: { deleted: 0, draft: 1, processing: 2, unpublished: 8, scheduled: 9, published: 10 }

  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items

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
end
