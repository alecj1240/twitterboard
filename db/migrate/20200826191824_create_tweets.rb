class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.text :text
      t.integer :favorite_count
      t.integer :reply_count
      t.integer :retweet_count
      t.string :tweet_id
      t.string :author_id
      t.boolean :approved
      t.string :link

      t.timestamps
    end
  end
end
