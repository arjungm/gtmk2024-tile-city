extends TileMapLayer

const TILE_TYPE_LAYER_NAME = "tile_type"
const STARTING_CELL = Vector2i(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_num_placed_tiles(tile_type: Tile.Type) -> int:
	var num = 0
	for cell in get_used_cells():
		if tile_type == get_tile_type_in_cell(cell):
			num += 1
	return num
	
func get_tile_type_in_cell(target_cell: Vector2i) -> Tile.Type:
	var cell_tile_data = get_cell_tile_data(target_cell)
	if cell_tile_data:
		return cell_tile_data.get_custom_data(TILE_TYPE_LAYER_NAME)
	return Tile.Type.UNKNOWN

func set_tile_type_in_cell(target_cell: Vector2i, tile_type: Tile.Type):
	var cell_tile_data = get_cell_tile_data(target_cell)
	cell_tile_data.set_custom_data(TILE_TYPE_LAYER_NAME, tile_type)

func can_place_tile_in_cell(target_cell: Vector2i, tile_type: Tile.Type) -> bool:
	# type is unused for now, maybe tiles have different restrictions later?
	var isEmpty = get_tile_type_in_cell(target_cell) == Tile.Type.UNKNOWN
	var hasAdjacent = [
		target_cell + Vector2i.LEFT,
		target_cell + Vector2i.UP,
		target_cell + Vector2i.RIGHT,
		target_cell + Vector2i.DOWN,
	].any(func(cell): return get_tile_type_in_cell(cell) != Tile.Type.UNKNOWN)
	
	return isEmpty && (hasAdjacent || target_cell == STARTING_CELL)
