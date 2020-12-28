module ApprovalHelper
    
    def createTweet(tweetInfo, author, category, approvedStatus)
        @newTweet = Tweet.new(
            approved: approvedStatus,
            text: tweetInfo.text,
            tweet_id: tweetInfo.id,
            author_id: author.id,
            author_name: author.name,
            author_profile_picture: author.profile_image_url,
            link: tweetInfo.uri,
            favorite_count: tweetInfo.favorite_count,
            reply_count: tweetInfo.reply_count,
            retweet_count: tweetInfo.retweet_count,
            category: category,
            tweet_date: tweetInfo.created_at,
            tweet_media: tweetMedia(tweetInfo)
        )
        @newTweet.save!
    end

    def tweetMedia(tweet)
        str = ''
        if tweet.media?
            tweet.media.each do |m|
                str = str + m.media_url + ','
            end
        end

        return str
    end 
end
