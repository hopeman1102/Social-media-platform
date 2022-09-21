# frozen_string_literal: true

redis = Redis.new(url: 'redis://127.0.0.1',
                        port: 6379,
                        db: 0)