class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :access_token
      t.integer :token_type, default: 1, null: false
      t.boolean :valid, default: true

      t.timestamps
    end
    add_index :access_tokens, :access_token, unique: true
  end
end
