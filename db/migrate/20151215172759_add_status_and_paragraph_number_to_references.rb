class AddStatusAndParagraphNumberToReferences < ActiveRecord::Migration
  def change
    add_column :references, :status, :string, default: "pending"
    add_column :references, :paragraph_number, :integer
  end
end
