extends Resource

@export var tile_idx: int
@export var tile_type: Tile.Type

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_idx = 0, p_type = Tile.Type.UNKNOWN):
	tile_idx = p_idx
	tile_type = p_type
	print("my type ", tile_type)
