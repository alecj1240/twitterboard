class TweetController < ApplicationController
  require 'twitter'

  # collection of all the tweets available with filters
  def index
    @filter = params[:filter]
    @category = params[:category]
    @jobs = Tweet.where(:approved => true).order('created_at DESC')

    if user_signed_in? && @filter == "followers"
      client = User.twitter_client(current_user)
      @followerIds = []
      client.followers.attrs[:users].each do |user|
        @followerIds.push(user[:id].to_s)
      end
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followerIds).order('created_at DESC')
    end

    if user_signed_in? && @filter == "following"
      client = User.twitter_client(current_user)
      @followingIds = []
      client.friends.attrs[:users].each do |user|
        @followingIds.push(user[:id].to_s)
      end
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followingIds).order('created_at DESC')
      #puts client.status(1091809187535958018).media.first.media_url
    end

    if !@category.nil?
      @jobs = Tweet.where(:approved => true).where(:category => @category).order('created_at DESC')
      if @jobs.count == 0
        @jobs = Tweet.where(:approved => true).order('created_at DESC')
      end 
    end
  end

  # collection of your tweets
  def personal
    @jobs = Tweet.where(:approved => true).where(:author_id => current_user.uid).order('created_at DESC')
  end
  
end
