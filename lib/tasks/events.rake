require 'securerandom'
require 'tweetstream'

require 'net/http'
require 'net/https'

require "redis"
require "json"


namespace :events do
  desc "Tail from the Redis Queue"
  task :tail, [:channel] => :environment do |task, args|
    channel    = args[:channel].to_s
    redis = Redis.new(Rq::Application.config.redis)

    puts "==> #{channel} <=="
    puts "Keys #{redis.keys('*')}"

    # loop do
    #   list, message = redis.blpop(channel)
    #   json = JSON.parse(message)
    #   puts json
    # end

  end

  task :create => :environment do

    creds = JSON.parse(File.read("#{Rails.root}/.credentials.json"))

    TweetStream.configure do |config|
      config.consumer_key       = creds['consumer_key']
      config.consumer_secret    = creds['consumer_secret']
      config.oauth_token        = creds['oauth_token']
      config.oauth_token_secret = creds['oauth_token_secret']
      config.auth_method        = :oauth
    end

    uri = URI.parse("http://localhost:3000/events")

    TweetStream::Client.new.sample do |status|
      # puts "#{status.text}"
      Net::HTTP.post_form(uri, {event: status.to_json})
    end
  end
end
