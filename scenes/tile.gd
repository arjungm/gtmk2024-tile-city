class_name Tile
enum Type {
	HOUSE = 0,
	ROAD = 1,
	FARM = 2,
	UNKNOWN = -1,
}

static func type_to_string(type: Type) -> String:
	match type:
		Type.HOUSE:
			return "house"
		Type.ROAD:
			return "road"
		Type.FARM:
			return "farm"
		_:
			return "unknown"

static func string_to_type(string: String) -> Type:
	match string:
		"house":
			return Type.HOUSE
		"road":
			return Type.ROAD
		"farm":
			return Type.FARM
		_:
			return Type.UNKNOWN

static func load_texture_for_tile_type(tile_type: Tile.Type):
	var img_base_name = ""
	match tile_type:
		Tile.Type.FARM:
			img_base_name = "farm"
		Tile.Type.HOUSE:
			img_base_name = "house"
		Tile.Type.ROAD:
			img_base_name = "road"
	var path = "res://images/" + img_base_name + ".png"
	var image = Image.load_from_file(path)
	image.resize(20,20)
	var texture = ImageTexture.new().create_from_image(image)
	return texture
