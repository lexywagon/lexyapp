class RemoveLegiIdFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :legi_id, :string
  end
end
