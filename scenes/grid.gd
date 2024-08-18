extends TileMapLayer

const BLANK_TILE_IDX = Vector2i(0, 6)
var placing_tile: String = ""
var preview: TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preview = get_node("PreviewLayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if placing_tile != "":
		var preview_cell = local_to_map(get_local_mouse_position())
		preview.clear()
		preview.set_cell(preview_cell, 1, tile_to_index(placing_tile))
	pass

func _input(event):
	if event is InputEventMouseButton:
		var cell = local_to_map(get_local_mouse_position())
		var curr_tile_index = get_cell_atlas_coords(cell)
		if placing_tile != "" && curr_tile_index == BLANK_TILE_IDX && event.button_index == MOUSE_BUTTON_LEFT:
			set_cell(cell, 1, tile_to_index(placing_tile))
			placing_tile = ""


func _on_start_place_mode(tile: String) -> void:
	placing_tile = tile


func tile_to_index(tile: String) -> Vector2i:
	return Vector2i(0, 3)
