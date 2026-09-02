module Events
  class Importer
    def call
      billetto_client.fetch_events.each do |data|
        event = Event.find_or_initialize_by(
          billetto_id: data["id"]
        )

        event.update!(
          title: data["title"],
          description: data["description"],
          branded_url: data["branded_url"],
          image_url: data["image_link"],
          start_at: data["startdate"],
          end_at: data["enddate"],
          available: data["availability"],
          venue_name: data.dig("location", "location_name"),
          city: data.dig("location", "city"),
          organiser: data.dig("organiser", "name"),
          minimum_price_cents: data.dig("minimum_price", "amount_in_cents"),
          currency: data.dig("minimum_price", "currency"),
          category: data.dig("categorization", "category")
        )
      end
    end

    private

    def billetto_client
      Billetto::Client.new
    end
  end
end
