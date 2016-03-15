class CreatePhilosophers < ActiveRecord::Migration
  def change
    create_table :philosophers do |t|
      t.string  :name, :null => false
      t.text    :thoughts
      t.integer :number
      t.string  :session_id
      t.timestamps null: false
    end

    add_index :philosophers, :session_id, :unique => true
    add_index :philosophers, :number, :unique => true
  end
end
