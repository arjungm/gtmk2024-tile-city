extends Resource

enum Rotation { UP = 0, RIGHT = 90, DOWN = 180, LEFT = 270 }
enum Type { FERTILE, NEIGHBORHOOD, HIGHWAY}

func _init(tiles: Array[Vector2i], t: Type):
	offsets = tiles
	rotation = Rotation.UP
	type = t

var offsets: Array[Vector2i]
var rotation: Rotation
var type: Type

func rotate(clockwise: bool = true):
	rotation = (rotation + 90) % 360

func get_rotated_offsets() -> Array[Vector2i]:
	var rotated: Array[Vector2i]
	rotated.assign(offsets.map(func(offset): 
		match rotation:
			Rotation.RIGHT: 
				return Vector2i(offset.y, -offset.x)
			Rotation.DOWN:
				return Vector2i(-offset.x, -offset.y)
			Rotation.LEFT:
				return Vector2i(-offset.y, offset.x)
		return offset
	))
	return rotated

func get_atlas_index() -> Vector2i:
	match type:
		Type.NEIGHBORHOOD:
			return Vector2i(13, 2)
		Type.FERTILE:
			return Vector2i(16, 2)
		Type.HIGHWAY:
			return Vector2i(14, 2)
		_:
			return Vector2i(-1, -1)
