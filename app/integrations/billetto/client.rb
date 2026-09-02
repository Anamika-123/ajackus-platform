module Billetto
  class Client
    BASE_URL = "https://billetto.dk"
    PUBLIC_EVENTS_PATH = "/api/v3/public/events"

    attr_reader :api_key

    def initialize
      @api_key = Rails.application.credentials.dig(
        :billetto, :api_key
      )
    end

    def fetch_events
      result = fetch_page(PUBLIC_EVENTS_PATH)
      events = result["data"]

      while result["has_more"] && result["next_url"].present?
        next_result = fetch_page(result["next_url"])

        events.concat(next_result["data"])

        result["has_more"] = next_result["has_more"]
        result["next_url"] = next_result["next_url"]
      end
      events
    rescue Faraday::Error, JSON::ParserError => e
      raise Error, "Failed to fetch events: #{e.message}"
    end

    private

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers["content-type"] = "application/json"
        faraday.headers["Api-Keypair"] = api_key
      end
    end

    def fetch_page(path)
      response = connection.get(path)
      raise Error, "Failed to fetch events (HTTP #{response.status})" unless response.success?

      result = JSON.parse(response.body)
      raise Error, "Billetto returned an invalid response" unless result.is_a?(Hash) && result["data"].is_a?(Array)

      result
    end
  end
end
