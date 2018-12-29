class CreateBattlefields < ActiveRecord::Migration[5.2]
  def change
    create_table :battlefields do |t|
      t.bigint :seed, null: false
      t.timestamps
    end
  end
end
