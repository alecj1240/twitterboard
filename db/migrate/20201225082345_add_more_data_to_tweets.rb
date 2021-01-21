class AddMoreDataToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :author_name, :string
    add_column :tweets, :author_username, :string
    add_column :tweets, :author_profile_picture, :string
    add_column :tweets, :tweet_date, :datetime
    add_column :tweets, :tweet_media, :string
    add_column :tweets, :url_data, :json, default: {}
  end
end
