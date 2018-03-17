class CreateEventVideos < ActiveRecord::Migration[5.1]
  def change
    create_table :event_videos do |t|
      t.references :event, foreign_key: true
      t.references :presentation, foreign_key: true
      t.integer :sort_order, default: 0

      t.timestamps
    end
  end
end
