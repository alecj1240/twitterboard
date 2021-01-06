module ApprovalHelper
    require 'json'
    require 'typhoeus'

    def createTweet(tweetInfo, author, category, approvedStatus)
        @newTweet = Tweet.new(
            approved: approvedStatus,
            text: tweetInfo["data"]["text"],
            tweet_id: tweetInfo["data"]["id"],
            author_id: author["data"]["id"],
            author_name: author["data"]["name"],
            author_username: getUser(author["data"]["id"])["data"]["username"],
            author_profile_picture: author["data"]["profile_image_url"],
            link:  "https://twitter.com/#{tweetInfo["data"]["author_id"]}/status/#{tweetInfo["data"]["id"]}",
            favorite_count: tweetInfo["data"]["public_metrics"]["like_count"],
            reply_count: tweetInfo["data"]["public_metrics"]["reply_count"],
            retweet_count: tweetInfo["data"]["public_metrics"]["retweet_count"],
            category: category,
            tweet_date: tweetInfo["data"]["created_at"],
            tweet_media: tweetMedia(tweetInfo)
        )
        @newTweet.save!
    end

    def tweetMedia(tweet)
        str = ''
        if !tweet["includes"].nil? && !tweet["includes"]["media"].nil?
            tweet["includes"]["media"].each do |m|
                str = str + "type=#{m["type"]}&url=#{m["url"]},"
            end
        end

        return str
    end 

    def getMentions()
        url = "https://api.twitter.com/2/users/:id/mentions"
        id = 1295064321429446656
        url = url.gsub(':id',id.to_s())

        params = {
            "max_results" => 100,
            "expansions" => "referenced_tweets.id,attachments.media_keys",
            "tweet.fields" => "attachments,author_id,created_at,entities,id,text,referenced_tweets,public_metrics",
            "user.fields" => "name,id,profile_image_url,username",
            "media.fields" => "url,preview_image_url,media_key", 
        }

        options = {
            method: 'get',
            headers: {
                "Authorization" => "Bearer #{ENV["TWITTER_BEARER_TOKEN"]}"
            },
            params: params
        }
        
        request = Typhoeus::Request.new(url, options)
        response = request.run
    
        return JSON.parse(response.body)
    end

    def getTweet(tweetId)
        tweet_lookup_url = "https://api.twitter.com/2/tweets/#{tweetId}"

        params = {
          "expansions": "referenced_tweets.id,attachments.media_keys",
          "tweet.fields": "attachments,author_id,created_at,entities,id,text,referenced_tweets,public_metrics",
          "user.fields": "name,id,profile_image_url,username",
          "media.fields": "url,preview_image_url,media_key", 
        }

        options = {
            method: 'get',
            headers: {
                "Authorization" => "Bearer #{ENV["TWITTER_BEARER_TOKEN"]}"
            },
            params: params
        }

        request = Typhoeus::Request.new(tweet_lookup_url, options)
        response = request.run
    
        return JSON.parse(response.body)
    end

    def getUser(userId)
        url = "https://api.twitter.com/2/users/:id"

        url = url.gsub(':id',userId.to_s())

        params = {
          "user.fields": "name,id,profile_image_url,username"
        }

        options = {
            method: 'get',
            headers: {
                "Authorization" => "Bearer #{ENV["TWITTER_BEARER_TOKEN"]}"
            },
            params: params
        }

        request = Typhoeus::Request.new(url, options)
        response = request.run
    
        return JSON.parse(response.body)
    end
end
