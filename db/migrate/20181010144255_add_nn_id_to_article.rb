class AddNnIdToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :HN_Id, :integer
  end
end
