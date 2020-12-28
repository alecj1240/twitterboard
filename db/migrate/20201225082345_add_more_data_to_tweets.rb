class AddMoreDataToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :author_name, :string
    add_column :tweets, :author_profile_picture, :string
    add_column :tweets, :tweet_date, :datetime
    add_column :tweets, :tweet_media, :string
  end
end
