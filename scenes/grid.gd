extends TileMapLayer

const TileHandItem = preload("res://data_types/tile_hand_item.gd")

signal tile_placed(tile_idx: int, tile_type: Tile.Type)

@export var grid_size = 5
var bounds = Rect2i(0, 0, grid_size, grid_size)
const BLANK_TILE_IDX = Vector2i(15, 11)
const ERROR_TILE_IDX = Vector2i(14, 11)

var placement_tile: TileHandItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(bounds.position.x, bounds.end.x):
		for j in range(bounds.position.y, bounds.end.y):
			set_cell(Vector2i(i, j), 1, BLANK_TILE_IDX)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PreviewLayer.clear()
	if placement_tile and placement_tile.tile_type != Tile.Type.UNKNOWN:
		var preview_cell = $PreviewLayer.local_to_map(get_local_mouse_position())
		var cell = local_to_map(get_local_mouse_position())
		if bounds.has_point(preview_cell):
			if (get_cell_atlas_coords(cell) == BLANK_TILE_IDX):
				$PreviewLayer.set_cell(preview_cell, 1, tile_type_to_atlas_index(placement_tile.tile_type))
			else:
				$PreviewLayer.set_cell(preview_cell, 1, ERROR_TILE_IDX)
	pass

func _input(event):
	if event is InputEventMouseButton:
		var cell = local_to_map(get_local_mouse_position())
		if !bounds.has_point(cell):
			pass
		var curr_tile_index = get_cell_atlas_coords(cell)
		if placement_tile && curr_tile_index == BLANK_TILE_IDX && event.button_index == MOUSE_BUTTON_LEFT:
			set_cell(cell, 1, tile_type_to_atlas_index(placement_tile.tile_type))
			tile_placed.emit(placement_tile.tile_idx, placement_tile.tile_type)
			print("place ", placement_tile.tile_type)
			placement_tile = null


func _on_start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type) -> void:
	placement_tile = TileHandItem.new(tile_idx, tile_type)


func tile_type_to_atlas_index(tile: Tile.Type) -> Vector2i:
	match tile:
		Tile.Type.HOUSE:
			return Vector2i(0, 4)
		Tile.Type.ROAD:
			return Vector2i(0, 6)
		Tile.Type.FARM:
			return Vector2i(0, 10)
	return BLANK_TILE_IDX
