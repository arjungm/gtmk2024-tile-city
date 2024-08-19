extends TileMapLayer

const TILE_TYPE_LAYER_NAME = "tile_type"

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
