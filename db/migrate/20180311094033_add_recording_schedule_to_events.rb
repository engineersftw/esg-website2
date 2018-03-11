class AddRecordingScheduleToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :scheduled_for_recording, :boolean, default: false
    add_column :events, :esg_volunteer1, :string, nil: true
    add_column :events, :esg_volunteer2, :string, nil: true
    add_column :events, :esg_set, :string, nil: true
    add_column :events, :schedule_status, :integer, default: 1

    add_index(:events, :scheduled_for_recording)
  end
end
