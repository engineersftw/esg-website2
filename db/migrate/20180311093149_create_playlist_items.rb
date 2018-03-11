class CreatePlaylistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_items do |t|
      t.references :playlist, foreign_key: true
      t.references :presentation, foreign_key: true
      t.integer :sort_order

      t.timestamps
    end
  end
end
