require "bunny"

class MatchScoreService
  attr_reader :match

  def initialize(match_id)
    @match = Match.find_by match_id
  end

  def publish
    channel.default_exchange.publish(payload, routing_key: queue.name)
    connection.close
  end

  def payload
    @match.to_json
  end

  private

  def payload
    @match.to_json
  end

  def connection
    @conn ||= begin
                conn = Bunny.new
                conn.start
              end
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    @queue ||= channel.queue("match-#{match.id}")
  end
end
