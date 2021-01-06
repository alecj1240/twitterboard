class AddAuthorUsernameToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :author_username, :string
  end
end
