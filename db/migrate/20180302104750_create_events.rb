class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description, null: true
      t.text :location, null: true
      t.string :platform_uid, null: true
      t.string :platform, null: true
      t.string :event_url, null: true
      t.string :group_uid, null: true
      t.string :group_name, null: true
      t.string :group_url, null: true
      t.string :formatted_time, null: true
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :active, default: true

      t.timestamps
    end

    add_index(:events, [:platform, :platform_uid], unique: true, name: 'by_platform_uid')
    add_index(:events, [:platform, :group_uid])
  end
end
