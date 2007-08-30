class CreateListTypes < ActiveRecord::Migration
  def self.up
    create_table :list_types do |t|
      t.column :name, :string 
    end
    # create default list
    (ListType.create :name => "in", :id => 1).save!
    (ListType.create :name => "actionable", :id => 2).save!
    (ListType.create :name => "maybe", :id => 3).save!
    (ListType.create :name => "references", :id => 4).save!
    (ListType.create :name => "trash", :id => 5).save!
    (ListType.create :name => "complete", :id => 6).save!
  end

  def self.down
    drop_table :list_types
  end
end
