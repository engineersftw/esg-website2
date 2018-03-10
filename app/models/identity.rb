class Identity < ApplicationRecord
  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)

    identity.email = auth.info.email
    identity.avatar_url = auth.info.image
    identity.access_token = auth.credentials.token
    identity.token_secret = auth.credentials.secret if auth.credentials.try(:secret)
    identity.refresh_token = auth.credentials.refresh_token if auth.credentials.try(:refresh_token)
    identity.save

    identity
  end
end
