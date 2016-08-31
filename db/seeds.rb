# Create a season for this engine if it doesn't exist yet
Season.find_or_create_by(engine_name: JquestPg.name)
