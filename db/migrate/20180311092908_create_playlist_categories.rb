class CreatePlaylistCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_categories do |t|
      t.string :title
      t.boolean :active

      t.timestamps
    end
  end
end
