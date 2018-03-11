class AddStatsToPresentations < ActiveRecord::Migration[5.1]
  def change
    add_column :presentations, :view_count, :integer, default: 0, nil: true
    add_column :presentations, :image1, :string, nil: true
    add_column :presentations, :image2, :string, nil: true
    add_column :presentations, :image3, :string, nil: true
    add_column :presentations, :status, :integer, index: true, default: 1, nil: false
  end
end
