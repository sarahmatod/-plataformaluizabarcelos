class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user_choice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
