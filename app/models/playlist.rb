class Playlist < ApplicationRecord
  has_many :playlist_items
  has_many :presentations, through: :playlist_items
  belongs_to :playlist_category

  scope :active, -> { where(active: true) }
end
