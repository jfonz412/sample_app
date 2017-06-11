class CreateMicroposts < ActiveRecord::Migration[5.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    # we expect to retrieve all microposts associated with a given user_id
    # in reverse order of creation
    # this creates a multiple key index which uses both keys at the 
    # same damn time
    add_index :microposts, [:user_id, :created_at]
  end
end
