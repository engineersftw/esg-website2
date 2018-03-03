class AccessToken < ApplicationRecord
  enum token_type: { stream_key: 1, api_key: 2 }

  belongs_to :user

  validates_presence_of :user, :title, :token_type
  validates_uniqueness_of :access_token

  def self.generate_token_string
    uuid = SecureRandom.uuid
    Base64.encode64(uuid).strip
  end
end
