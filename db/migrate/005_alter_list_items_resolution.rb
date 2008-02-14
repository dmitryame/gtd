class AlterListItemsResolution < ActiveRecord::Migration
  def self.up
    change_column :list_items, :resolution, :text, :limit => 100.kilobytes
  end

  def self.down
    change_column :list_items, :resolution, :string
  end
end
