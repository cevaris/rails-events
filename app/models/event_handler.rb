class EventHandler
  def fire(event)
    RedisEvents.redis.rpush(RedisEvents::RAW_EVENTS, event)
  end
end