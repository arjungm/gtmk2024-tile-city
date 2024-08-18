extends Resource

enum Rotation { UP = 0, RIGHT = 90, DOWN = 180, LEFT = 270 }

func _init(tiles: Array[Vector2i]):
	offsets = tiles
	rotation = Rotation.UP

var offsets: Array[Vector2i]
var rotation: Rotation

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
