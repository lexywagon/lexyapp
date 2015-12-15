class RemoveContentAndTextFromDocuments < ActiveRecord::Migration
  def change
    remove_column :documents, :content, :string
    remove_column :documents, :text, :string
  end
end
