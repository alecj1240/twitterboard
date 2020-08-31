class TweetController < ApplicationController
  require 'twitter'

  def index
    @jobs = Tweet.where(:approved => true).order('created_at DESC')
  end
  
end
