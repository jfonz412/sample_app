class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    #not generated, added manually (listing 14.1) for effecient searching (but less effecient updating)
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    #enforces uniqueness on follower/followed pairs so a user can't follow the same person twice
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
