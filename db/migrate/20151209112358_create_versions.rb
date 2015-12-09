class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.references :article, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
