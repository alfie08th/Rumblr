class RenameComments < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :blog_id, :post_id
  end
end
