class AccessToken < ApplicationRecord
  enum token_type: { stream_key: 1, api_key: 2 }

  belongs_to :user

  validates_presence_of :user, :token_type
  validates_uniqueness_of :access_token
end
