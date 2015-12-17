class AddTrackingToReferences < ActiveRecord::Migration
  def change
    add_column :references, :tracking, :boolean
  end
end
