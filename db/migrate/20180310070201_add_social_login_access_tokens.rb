class AddSocialLoginAccessTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :access_token, :string, nil: true
    add_column :identities, :refresh_token, :string, nil: true
    add_column :identities, :token_secret, :string, nil: true
  end
end
