class AddLegiIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :legi_id, :string
  end
end
