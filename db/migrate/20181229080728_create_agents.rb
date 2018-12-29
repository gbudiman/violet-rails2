class CreateAgents < ActiveRecord::Migration[5.2]
  def change
    create_table :agents do |t|
      t.string :uuid, null: false
      t.jsonb :initial_state, null: false
      t.jsonb :current_state, null: false
      t.belongs_to :battlefield, index: true
      t.timestamps
    end

    add_index :agents, [:battlefield_id, :uuid], unique: true
  end
end
