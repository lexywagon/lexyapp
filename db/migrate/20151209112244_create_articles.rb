class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :number
      t.string :legi_id
      t.references :law, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
