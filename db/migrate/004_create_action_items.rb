class CreateActionItems < ActiveRecord::Migration
  def self.up
    create_table :action_items do |t|
      t.column :description, :string,  :null => false
      t.column :list_item_id,    :integer,  :null => false
      t.column :order, :integer, :null => false
      t.column :level, :integer, :null => false
      t.column :remind_at, :datetime
      t.column :done,       :boolean,  :null => false, :default => false
      t.column :resolution, :string
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end
  end

  def self.down
    drop_table :action_items
  end
end
