class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.column :name, :string 
    end
    # create default list
    (List.create :name => "in", :id => 1).save!
    (List.create :name => "actionable", :id => 2).save!
    (List.create :name => "maybe", :id => 3).save!
    (List.create :name => "references", :id => 4).save!
    (List.create :name => "trash", :id => 5).save!
    (List.create :name => "complete", :id => 6).save!
  end

  def self.down
    drop_table :lists
  end
end
