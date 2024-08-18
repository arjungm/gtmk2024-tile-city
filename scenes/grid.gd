extends TileMapLayer

signal tile_placed(tile: Tile.Type)

@export var grid_size = 5
var bounds = Rect2i(0, 0, grid_size, grid_size)
const BLANK_TILE_IDX = Vector2i(15, 11)
const ERROR_TILE_IDX = Vector2i(14, 11)
var placing_tile: Tile.Type = Tile.Type.UNKNOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(bounds.position.x, bounds.end.x):
		for j in range(bounds.position.y, bounds.end.y):
			set_cell(Vector2i(i, j), 1, BLANK_TILE_IDX)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PreviewLayer.clear()
	if placing_tile != Tile.Type.UNKNOWN:
		var preview_cell = $PreviewLayer.local_to_map(get_local_mouse_position())
		var cell = local_to_map(get_local_mouse_position())
		if bounds.has_point(preview_cell):
			if (get_cell_atlas_coords(cell) == BLANK_TILE_IDX):
				$PreviewLayer.set_cell(preview_cell, 1, tile_to_index(placing_tile))
			else:
				$PreviewLayer.set_cell(preview_cell, 1, ERROR_TILE_IDX)
	pass

func _input(event):
	if event is InputEventMouseButton:
		var cell = local_to_map(get_local_mouse_position())
		if !bounds.has_point(cell):
			pass
		var curr_tile_index = get_cell_atlas_coords(cell)
		if placing_tile != null && curr_tile_index == BLANK_TILE_IDX && event.button_index == MOUSE_BUTTON_LEFT:
			set_cell(cell, 1, tile_to_index(placing_tile))
			tile_placed.emit(placing_tile)
			placing_tile = Tile.Type.UNKNOWN


func _on_start_place_mode(tile: Tile.Type) -> void:
	placing_tile = tile


func tile_to_index(tile: Tile.Type) -> Vector2i:
	match tile:
		Tile.Type.HOUSE:
			return Vector2i(0, 3)
		Tile.Type.ROAD:
			return Vector2i(3, 6)
	return BLANK_TILE_IDX
