namespace :events do
  desc "Import Billetto events"

  task import: :environment do
    Events::Importer.new.call

    puts "Billetto events imported successfully"
  rescue Billetto::Error => e
    puts "Import failed: #{e.message}"
  end
end
