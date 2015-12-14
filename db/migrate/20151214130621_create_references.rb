class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :article, index: true, foreign_key: true
      t.references :document, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
