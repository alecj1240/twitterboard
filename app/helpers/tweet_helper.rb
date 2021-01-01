module TweetHelper
    def getFollowerIds(userId)
        url = "https://api.twitter.com/2/users/:id/followers"
        id = userId
        url = url.gsub(':id', id.to_s())

        params = {
            "user.fields" => "id"
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
        response = JSON.parse(response.body)

        followerIds = []
        if !response["data"].nil?
            response["data"].each do |user|
                followersIds.push(user["id"])
            end
        end

        return followerIds
    end

    def getFollowingIds(userId)
        url = "https://api.twitter.com/2/users/:id/following"
        id = userId
        url = url.gsub(':id', id.to_s())

        params = {
            "user.fields" => "id"
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
        response = JSON.parse(response.body)

        followingIds = []
        if !response["data"].nil?
            response["data"].each do |user|
                followingIds.push(user["id"])
            end
        end

        return followingIds
    end
end
