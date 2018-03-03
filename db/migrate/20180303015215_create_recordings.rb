class CreateRecordings < ActiveRecord::Migration[5.1]
  def change
    create_table :recordings do |t|
      t.references :user, foreign_key: true
      t.string :video_path, null: false
      t.string :original_name, null: true
      t.string :ip_addr, null: true
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
