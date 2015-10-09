class CreatePostTags < ActiveRecord::Migration
  def up
    create_table :post_tags do |t|
      t.integer :post_id
      t.integer :tag_id
    end
  end

  def down
    drop_table :post_tags
  end
end

