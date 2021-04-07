class ApprovalController < ApplicationController
  include ApprovalHelper

  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    mentions = getMentions()
    @jobs = []
    mentions["data"].each do |job|
      in_reply_to_id = nil
      in_reply_to_id = job["referenced_tweets"][0]["id"] if !job["referenced_tweets"].nil?

      if in_reply_to_id.nil? && !Tweet.find_by(tweet_id: job["id"])
        @jobs.push(job)
        next
      end
      if !Tweet.find_by(tweet_id: job["id"]) && !Tweet.find_by(tweet_id: in_reply_to_id)
        @jobs.push(job)
      end
    end
  end

  def handle
    tweetInfo = getTweet(params[:tweetId])
    author = getUser(tweetInfo["data"]["author_id"])

    case params[:commit]
    when "Approve Job"
      createTweet(tweetInfo, author, params[:category], true)
    when "Approve Thread Job"
      threadInfo = getTweet(tweetInfo["data"]["referenced_tweets"][0]["id"])
      author = getUser(threadInfo["data"]["author_id"])
      createTweet(threadInfo, author, params[:category], true)
    else
      createTweet(tweetInfo, author, params[:category], false)
    end
  end

  private

  def authorize_admin
    if current_user.uid === ENV["ADMIN_ID"]
      return
    end
    redirect_to jobs_path, alert: "How did you know that was there? You can't go in there!"
  end
end
