class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :presentation
end
