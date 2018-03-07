class CreateRecordings < ActiveRecord::Migration[5.1]
  def change
    create_table :recordings do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :addr, null: false
      t.integer :clientid, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: true
      t.string :path, null: true
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index(:recordings, [:name, :addr, :clientid], name: 'by_name_ipaddr_and_clientid')
  end
end
