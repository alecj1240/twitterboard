
class TweetController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :authorize_admin, only: :approve
  require 'twitter'

  def index
    @jobs = Tweet.where(:approved => true)
  end

  def approve
    client = User.twitter_client(current_user)
    @mentions = client.mentions_timeline
    @jobs = []
    @mentions.each do |job|
      if !Tweet.find_by(tweet_id: job.id) && !Tweet.find_by(tweet_id: job.in_reply_to_status_id)
        @jobs.push(job)
      end
    end
  end

  def approved
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
      retweet_count: tweetInfo.retweet_count
    )
    @newTweet.save!
  end 

  def thread_approved
    @tweetId = params[:tweetId]
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
      retweet_count: threadInfo.retweet_count
    )
    @newTweet.save!
  end

  def denied
    @tweetId = params[:tweetId]
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
      retweet_count: tweetInfo.retweet_count
    )
    @newTweet.save!
  end

  private

  def authorize_admin
    if current_user.email === "alec@christopherbot.co"
      return
    end
    redirect_to root_path, alert: "Naughty naughty! You can't go in there!"
  end
  
end
