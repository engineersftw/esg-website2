class CreatePresentations < ActiveRecord::Migration[5.1]
  def change
    create_table :presentations do |t|
      t.string :title
      t.text :description, null: true
      t.date :presented_at, null: true
      t.boolean :published, default: true
      t.string :video_source, null: true
      t.string :video_id, null: true
      t.integer :event_id, null: true

      t.timestamps
    end

    add_index(:presentations, [:video_source, :video_id], unique: true, name: 'by_video_source_and_id')
  end
end
