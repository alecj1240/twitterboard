class TweetController < ApplicationController
  require 'twitter'
  include TweetHelper

  # collection of all the tweets available with filters
  def index
    @filter = params[:filter]
    category = params[:category]
    @jobs = Tweet.where(:approved => true).order('created_at DESC')

    if user_signed_in? && @filter == "followers"
      @followerIds = getFollowerIds(current_user.uid)
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followerIds).order('created_at DESC')
    end

    if user_signed_in? && @filter == "following"
      @followingIds = getFollowingIds(current_user.uid)
      @jobs = Tweet.where(:approved => true).where("author_id IN (?)", @followingIds).order('created_at DESC')
    end

    if !category.nil?
      @jobs = Tweet.where(:approved => true).where(:category => category).order('created_at DESC')
      if @jobs.count == 0
        @jobs = Tweet.where(:approved => true).order('created_at DESC')
      end 
    end
  end

  # collection of your tweets
  def personal
    @jobs = Tweet.where(:approved => true).where(:author_id => current_user.uid).order('created_at DESC')
  end

  def open_tweet
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
