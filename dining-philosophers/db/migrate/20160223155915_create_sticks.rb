class CreateSticks < ActiveRecord::Migration
  def change
    create_table :sticks do |t|
      t.integer :number, :null => false
      t.string :taken_by, :default => nil
      t.timestamps null: false
    end

    add_index :sticks, :number, :unique => true
  end
end
