class TweetController < ApplicationController
  require 'twitter'

  def index
    @filter = params[:filter]
    @jobs = Tweet.where(:approved => true).order('created_at DESC')
    if user_signed_in? && @filter == "followers"
      client = User.twitter_client(current_user)
      @followerIds = []
      client.followers.attrs[:users].each do |user|
        @followerIds.push(user[:id].to_s)
      end
      puts @followerIds
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followerIds).order('created_at DESC')
    end
    if user_signed_in? && @filter == "following"
      client = User.twitter_client(current_user)
      @followingIds = []
      client.friends.attrs[:users].each do |user|
        @followingIds.push(user[:id].to_s)
      end
      puts @followingIds
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followingIds).order('created_at DESC')
    end
  end
  
end
