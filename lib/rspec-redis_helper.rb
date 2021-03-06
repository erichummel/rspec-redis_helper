require "rspec-redis_helper/version"

module RSpec
  module RedisHelper

    CONFIG = { url: "redis://127.0.0.1:6379/1" }
    TEST = CONFIG # deprecated

    def redis
      @redis ||= ::Redis.new(CONFIG)
    end

    def redis2
      @redis2 ||= ::Redis.new(CONFIG)
    end

    def with_watch( redis, *args )
      redis.watch( *args )
      begin
        yield
      ensure
        redis.unwatch
      end
    end

    def with_clean_redis(&block)
      redis._client.disconnect   # auto connect after fork
      redis2._client.disconnect  # auto connect after fork
      redis.flushdb             # clean before run
      begin
        yield
      ensure
        redis.flushdb           # clean up after run
        redis.quit              # quit (close) connection
        redis2.quit             # quit (close) connection
      end
    end

  end
end
