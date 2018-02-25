class AddEmailAndAvatarToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :email, :string
    add_column :identities, :avatar_url, :string
  end
end
