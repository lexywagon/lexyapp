class AddMetadataToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :start_date, :date
    add_column :versions, :end_date, :date
    add_column :versions, :state, :string
  end
end
