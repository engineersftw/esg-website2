class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :title
      t.text   :description
      t.string :playlist_uid
      t.string :playlist_source
      t.string :image
      t.date :publish_date
      t.integer :playlist_category_id, index: true
      t.boolean :active, default: true
      t.string :website
      t.string :slug

      t.timestamps
    end

    add_index(:playlists, [:playlist_source, :playlist_uid], unique: true, name: 'by_playlist_source_and_uid')
    add_index(:playlists, :slug, unique: true, name: 'by_slug')
  end
end
