class ApprovalController < ApplicationController
  include ApprovalHelper

  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    client = User.twitter_client(current_user)
    @mentions = client.mentions_timeline
    @jobs = []
    @mentions.each do |job|
      if job.in_reply_to_status_id.nil? && !Tweet.find_by(tweet_id: job.id)
        @jobs.push(job)
        next
      end
      if !Tweet.find_by(tweet_id: job.id) && !Tweet.find_by(tweet_id: job.in_reply_to_status_id)
        @jobs.push(job)
      end
    end
  end

  def handle
    client = User.twitter_client(current_user)
    tweetInfo = client.status(params[:tweetId])
    author = client.user(tweetInfo.uri.to_s.split('/')[3])

    case params[:commit]
    when "Approve Job"
      createTweet(tweetInfo, author, params[:category], true)
    when "Approve Thread Job"
      threadInfo = client.status(tweetInfo.in_reply_to_status_id)
      author = client.user(threadInfo.uri.to_s.split('/')[3])
      createTweet(threadInfo, author, params[:category], true)
    else
      createTweet(tweetInfo, author, params[:category], false)
    end
  end

  private

  def authorize_admin
    if current_user.email === "alec@christopherbot.co"
      return
    end
    redirect_to jobs_path, alert: "How did you know that was there? You can't go in there!"
  end
end
