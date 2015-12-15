class AddParagraphsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :paragraphs, :text, array:true, default: []
  end
end
