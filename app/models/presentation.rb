class Presentation < ApplicationRecord
  enum status: { deleted: 0, draft: 1, processing: 2, unpublished: 8, scheduled: 9, published: 10 }

  has_many :playlist_items, dependent: :destroy
  has_many :playlists, through: :playlist_items
end
