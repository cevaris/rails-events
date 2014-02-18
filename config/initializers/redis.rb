require "redis"

module RedisEvents

  RAW_EVENTS = "events:raw"
  
  class << self
    def redis
      @redis ||= Redis.new(Rq::Application.config.redis)
    end
  end

end