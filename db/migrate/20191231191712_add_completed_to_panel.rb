class AddCompletedToPanel < ActiveRecord::Migration[6.0]
  def change
    add_column :panels, :completed, :boolean
  end
end
