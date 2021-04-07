class TweetController < ApplicationController
  include TweetHelper
  before_action :authenticate_user!

  # collection of all the tweets available with filters
  def index
    @filter = params[:filter]
    @category = params[:category]

    @jobs = Tweet.where(:approved => true).order('tweet_date DESC')

    if @filter == "followers"
      @followerIds = getFollowerIds(current_user.uid)
      @jobs = @jobs.where("author_id IN (?)", @followerIds)
    end

    if @filter == "following"
      @followingIds = getFollowingIds(current_user.uid)
      @jobs = @jobs.where("author_id IN (?)", @followingIds)
    end

    if !@category.nil?
      @jobs = @jobs.where(:category => @category)
      if @jobs.count == 0
        @jobs = Tweet.where(:approved => true).order('tweet_date DESC')
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

  def badge_styling(category)
    case category
    when "Programming"
      "primary"
    when "Design"
      "secondary"
    when "Copywriting"
      "success"
    when "DevOps & SysAdmin"
      "danger"
    when "Business, Management, Finance"
      "warning"
    when "Product"
      "info"
    when "Customer Support"
      "light"
    else
      "dark"
    end
  end
  helper_method :badge_styling
end
