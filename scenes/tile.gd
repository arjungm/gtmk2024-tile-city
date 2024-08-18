class_name Tile
enum Type {
	HOUSE,
	ROAD,
	FARM,
	UNKNOWN = -1
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
