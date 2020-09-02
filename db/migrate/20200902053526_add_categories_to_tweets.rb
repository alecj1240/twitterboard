class AddCategoriesToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :category, :string
  end
end
