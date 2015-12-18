class AddTrackingToReferences < ActiveRecord::Migration
  def change
    add_column :references, :tracking, :boolean, default: true
  end
end
