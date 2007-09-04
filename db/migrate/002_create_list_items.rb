class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.column :description, :string
      t.column :user_id,    :integer,  :null      => false
      t.column :list_type_id,    :integer,  :null => false
      t.column :position, :integer, :null       => false
      t.column :remind_at,   :datetime
      t.column :done,       :boolean,  :null => false, :default => false
      t.column :resolution, :string
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime, :null => false
    end
  end

  def self.down
    drop_table :list_items
  end
end
