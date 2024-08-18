extends Node2D

const TileHandItem = preload("res://data_types/tile_hand_item.gd")
const District = preload("res://data_types/district.gd")

signal tile_placed(tile_idx: int, tile_type: Tile.Type)

@export var grid_size = 5
var bounds = Rect2i(0, 0, grid_size, grid_size)
const BLANK_TILE_IDX = Vector2i(-1, -1)
const ERROR_TILE_IDX = Vector2i(14, 11)
const ERROR_DIST_IDX = Vector2i(15, 2)

const TILE_TYPE_LAYER_NAME = "tile_type"

const ATLAS_TEXTURE_LAYER_ID = 1

var placement_tile: TileHandItem = null
var placement_district: District = null

func get_game_map():
	for coords in $Map.get_used_cells():
		print(coords, " ", get_tile_type_in_cell(coords))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(bounds.position.x, bounds.end.x):
		for j in range(bounds.position.y, bounds.end.y):
			$Map.set_cell(Vector2i(i, j), 1, BLANK_TILE_IDX)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PreviewLayer.clear()
	if placement_tile and placement_tile.tile_type != Tile.Type.UNKNOWN:
		var preview_cell = $PreviewLayer.local_to_map(get_local_mouse_position())
		var cell = $Map.local_to_map(get_local_mouse_position())
		if bounds.has_point(preview_cell):
			if ($Map.get_cell_atlas_coords(cell) == BLANK_TILE_IDX):
				$PreviewLayer.set_cell(preview_cell, 1, tile_type_to_atlas_index(placement_tile.tile_type))
			else:
				$PreviewLayer.set_cell(preview_cell, 1, ERROR_TILE_IDX)
	elif placement_district != null:
		var origin_cell = $PreviewLayer.local_to_map(get_local_mouse_position())
		var cells = placement_district.get_rotated_offsets().map(func(offset): return origin_cell + offset)
		var placeable = placeable_in_bounds(placement_district, origin_cell, bounds)
		for cell in cells:
			if bounds.has_point(cell):
				var atlas_idx = placement_district.get_atlas_index() if placeable else ERROR_DIST_IDX
				$PreviewLayer.set_cell(cell, 1, atlas_idx)
	pass

func _input(event):
	if event is InputEventMouseButton:
		var cell = $Map.local_to_map(get_local_mouse_position())
		if !bounds.has_point(cell):
			pass
		var curr_tile_index = $Map.get_cell_atlas_coords(cell)
		if placement_tile && curr_tile_index == BLANK_TILE_IDX && event.button_index == MOUSE_BUTTON_LEFT:
			handle_tile_map_update(cell, placement_tile)
			placement_tile = null
		if placement_district && event.button_index == MOUSE_BUTTON_LEFT:
			if placeable_in_bounds(placement_district, cell, bounds):
				for off in placement_district.get_rotated_offsets():
					$DistrictLayer.set_cell(cell + off, 1, placement_district.get_atlas_index())
				placement_district = null
	
	if placement_district != null && event is InputEventKey && event.is_pressed():
		if event.keycode == 82: # "r" key TODO: change to correct input
			placement_district.rotate()

func handle_tile_map_update(target_cell: Vector2i, tile_hand_item: TileHandItem):
	var tile_type = tile_hand_item.tile_type
	var tile_idx = tile_hand_item.tile_idx
	set_tile_texture_in_cell(target_cell, tile_type)
	set_tile_type_in_cell(target_cell, tile_type)
	tile_placed.emit(tile_idx, tile_type)

func get_tile_type_in_cell(target_cell: Vector2i) -> Tile.Type:
	var cell_tile_data = $Map.get_cell_tile_data(target_cell)
	return cell_tile_data.get_custom_data(TILE_TYPE_LAYER_NAME)

func set_tile_texture_in_cell(target_cell: Vector2i, tile_type: Tile.Type):
	var tile_texture = tile_type_to_atlas_index(tile_type)
	$Map.set_cell(target_cell, ATLAS_TEXTURE_LAYER_ID, tile_texture)

func set_tile_type_in_cell(target_cell: Vector2i, tile_type: Tile.Type):
	var cell_tile_data = $Map.get_cell_tile_data(target_cell)
	cell_tile_data.set_custom_data(TILE_TYPE_LAYER_NAME, tile_type)

func _on_button_pressed() -> void:
	var shape: Array[Vector2i]
	match randi() % 3:
		0:
			shape = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2)]
		1, 2:
			shape = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0)]
	var type: District.Type = District.Type.values().pick_random()
	placement_district = District.new(shape, type)

func _on_start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type) -> void:
	placement_tile = TileHandItem.new(tile_idx, tile_type)
	placement_district = null


func tile_type_to_atlas_index(tile: Tile.Type) -> Vector2i:
	match tile:
		Tile.Type.HOUSE:
			return Vector2i(0, 4)
		Tile.Type.ROAD:
			return Vector2i(0, 6)
		Tile.Type.FARM:
			return Vector2i(0, 10)
	return BLANK_TILE_IDX

func placeable_in_bounds(district: District, cell: Vector2i, bounds: Rect2i) -> bool:
	return district.get_rotated_offsets().all(func(off): 
		var idx = cell + off
		return bounds.has_point(idx) \
			&& $DistrictLayer.get_cell_atlas_coords(idx) == Vector2i(-1, -1)
	)
