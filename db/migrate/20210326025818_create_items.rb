class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :photo
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
