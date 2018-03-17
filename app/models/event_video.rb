class EventVideo < ApplicationRecord
  belongs_to :event
  belongs_to :presentation
end
