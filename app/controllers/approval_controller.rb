class ApprovalController < ApplicationController
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
    if params[:commit] == "Approve Job"
      approved(params[:tweetId], params[:category])
    end

    if params[:commit] == "Deny Job"
      denied(params[:tweetId], params[:category])
    end

    if params[:commit] == "Approve Thread Job"
      thread_approved(params[:tweetId], params[:category])
    end
  end

  def approved(tweetId, category)
    @tweetId = params[:tweetId]
    client = User.twitter_client(current_user)
    tweetInfo = client.status(@tweetId)
    @newTweet = Tweet.new(
      approved: true,
      text: tweetInfo.text,
      tweet_id: @tweetId,
      author_id: client.user(tweetInfo.uri.to_s.split('/')[3]).id,
      link: tweetInfo.uri,
      favorite_count: tweetInfo.favorite_count,
      reply_count: tweetInfo.reply_count,
      retweet_count: tweetInfo.retweet_count,
      category: category
    )
    @newTweet.save!
  end 

  def thread_approved(tweetId, category)
    @tweetId = tweetId
    client = User.twitter_client(current_user)
    tweetInfo = client.status(@tweetId)
    @threadId = tweetInfo.in_reply_to_status_id
    threadInfo = client.status(@threadId)
    @newTweet = Tweet.new(
      approved: true,
      text: threadInfo.text,
      tweet_id: @threadId,
      author_id: client.user(threadInfo.uri.to_s.split('/')[3]).id,
      link: threadInfo.uri,
      favorite_count: threadInfo.favorite_count,
      reply_count: threadInfo.reply_count,
      retweet_count: threadInfo.retweet_count,
      category: category
    )
    @newTweet.save!
  end

  def denied(tweetId, category)
    @tweetId = tweetId
    client = User.twitter_client(current_user)
    tweetInfo = client.status(@tweetId)
    @newTweet = Tweet.new(
      approved: false,
      text: tweetInfo.text,
      tweet_id: @tweetId,
      author_id: client.user(tweetInfo.uri.to_s.split('/')[3]).id,
      link: tweetInfo.uri,
      favorite_count: tweetInfo.favorite_count,
      reply_count: tweetInfo.reply_count,
      retweet_count: tweetInfo.retweet_count,
      category: category
    )
    @newTweet.save!
  end

  private

  def authorize_admin
    if current_user.email === "alec@christopherbot.co"
      return
    end
    redirect_to jobs_path, alert: "How did you know that was there? You can't go in there!"
  end
end
