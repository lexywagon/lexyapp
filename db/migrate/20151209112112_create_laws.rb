class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
      t.string :name
      t.string :legi_cid

      t.timestamps null: false
    end
  end
end
