require Rails.root.join("lib/command_bus")

Rails.configuration.command_bus = CommandBus.new
