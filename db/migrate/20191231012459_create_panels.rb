class CreatePanels < ActiveRecord::Migration[6.0]
  def change
    create_table :panels do |t|
      t.integer :ammount
      t.text :question
      t.text :answer
      t.references :category, index: true

      t.timestamps
    end
  end
end
