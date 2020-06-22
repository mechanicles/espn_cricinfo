# frozen_string_literal: true

require 'bunny'

class MatchScoreService
  attr_reader :match

  def initialize(match_id)
    @match = Match.find_by id: match_id
  end

  def publish
    return if match.nil?

    exchange = channel.direct('match_scores')
    exchange.publish(payload, routing_key: queue.name, persistent: true)
    connection.close
  end

  private

  def payload
    match.to_json
  end

  def connection
    @connection ||= begin
                conn = Bunny.new(ENV['CLOUDAMQP_URL'].presence, automatically_recover: false)
                conn.start
              end
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    @queue ||= channel.queue("match-#{match.id}", durable: true)
  end
end
