extends Node2D

const TileHandItem = preload("res://data_types/tile_hand_item.gd")
const District = preload("res://data_types/district.gd")
const Score = preload("res://data_types/score.gd")

enum HouseLineDirection { VERTICAL, HORIZONTAL, DIAGONAL }

signal tile_placed(tile_idx: int, tile_type: Tile.Type)

@export var grid_size = 5
var bounds: Rect2i
const BLANK_TILE_IDX = Vector2i(-1, -1)
const ERROR_TILE_IDX = Vector2i(14, 11)
const ERROR_DIST_IDX = Vector2i(15, 2)

const GOAL_TILE_IDX = Vector2i(12, 8)

const ATLAS_TEXTURE_LAYER_ID = 1

var placement_tile: TileHandItem = null
var placement_district: District = null

# From Grid Parent
var get_farm_square_picking_active_fn = null

const FARM_SQUARE_ATLAS_IDX = Vector2i(9,2)
const HOUSE_SQUARE_ATLAS_IDX = Vector2i(18, 0)

var goal_cell: Vector2i = Vector2i.ZERO

func get_game_map():
	for coords in $Grids/Map.get_used_cells():
		print(coords, " ", $Grids/Map.get_tile_type_in_cell(coords))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_farm_square_picking_active_fn = $GridControlsBox/FarmSquareBox.get_farm_square_picking_active
	# Hook up farm square layer rendering
	$GridControlsBox/FarmSquareBox.farm_square_layer_render_fn = render_farm_square_layer_on_cell
	$GridControlsBox/FarmSquareBox.farm_square_layer_clear_fn = clear_farm_square_layer_on_cell
	$GridControlsBox/HouseLineBox.house_line_layer_render_fn = render_house_line_on_cell
	$GridControlsBox/HouseLineBox.house_line_layer_clear_fn = clear_house_line_on_cell
	setup_grid(grid_size)

func render_farm_square_layer_on_cell(cell: Vector2i):
	$Grids/FarmSquare.set_cell(cell, ATLAS_TEXTURE_LAYER_ID, FARM_SQUARE_ATLAS_IDX)
	
func clear_farm_square_layer_on_cell(cell: Vector2i):
	$Grids/FarmSquare.erase_cell(cell)

func render_house_line_on_cell(cell: Vector2i):
	$Grids/FarmSquare.set_cell(cell, ATLAS_TEXTURE_LAYER_ID, HOUSE_SQUARE_ATLAS_IDX)

func clear_house_line_on_cell(cell: Vector2i):
	$Grids/FarmSquare.erase_cell(cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Grids/PreviewLayer.clear()
	
	if placement_district != null:
		var origin_cell = $Grids/PreviewLayer.local_to_map($Grids.get_local_mouse_position())
		var cells = placement_district.get_rotated_offsets().map(func(offset): return origin_cell + offset)
		var placeable = placeable_in_bounds(placement_district, origin_cell, bounds)
		for cell in cells:
			if bounds.has_point(cell):
				var atlas_idx = placement_district.get_atlas_index() if placeable else ERROR_DIST_IDX
				$Grids/PreviewLayer.set_cell(cell, 1, atlas_idx)
	
	process_tile_placement()
	process_farm_square_mode()
	
func process_tile_placement():
	if placement_tile and placement_tile.tile_type != Tile.Type.UNKNOWN:
		var preview_cell = $Grids/PreviewLayer.local_to_map($Grids.get_local_mouse_position())
		var cell = $Grids/Map.local_to_map($Grids.get_local_mouse_position())
		if bounds.has_point(preview_cell):
			var placeable = $Grids/Map.can_place_tile_in_cell(cell, placement_tile.tile_type)
			var atlas_idx = tile_type_to_atlas_index(placement_tile.tile_type) if placeable else ERROR_TILE_IDX
			$Grids/PreviewLayer.set_cell(preview_cell, 1, atlas_idx)
	
func process_district_placement():
	pass

func compute_longest_overall() -> Array[Vector2i]:
	var lines: Array = []
	for i in range(bounds.position.x, bounds.end.x):
		for j in range(bounds.position.y, bounds.end.y):
			var cell = Vector2i(i, j)
			lines.append(compute_longest_line(cell, HouseLineDirection.HORIZONTAL))
			lines.append(compute_longest_line(cell, HouseLineDirection.VERTICAL))
			lines.append(compute_longest_line(cell, HouseLineDirection.DIAGONAL))
	
	var longest = lines.reduce(func(max, line): return line if line.size() > max.size() else max)
	return longest if longest && longest.size() > 2 else ([] as Array[Vector2i])

func compute_longest_line(cell: Vector2i, type: HouseLineDirection) -> Array[Vector2i]:
	var res: Array[Vector2i] = []
	if !is_house_cell(cell) || is_in_line(cell):
		return res
	
	res += [cell]
	match type:
		HouseLineDirection.VERTICAL:
			res += compute_longest_house_ray(cell, Vector2i.UP) + \
				compute_longest_house_ray(cell, Vector2i.DOWN)
		HouseLineDirection.HORIZONTAL:
			res += compute_longest_house_ray(cell, Vector2i.LEFT) + \
				compute_longest_house_ray(cell, Vector2i.RIGHT)
		HouseLineDirection.DIAGONAL:
			var upRight = compute_longest_house_ray(cell, Vector2i.UP + Vector2i.RIGHT) + \
				compute_longest_house_ray(cell, Vector2i.DOWN + Vector2i.LEFT)
			var downRight = compute_longest_house_ray(cell, Vector2i.DOWN + Vector2i.RIGHT) + \
				compute_longest_house_ray(cell, Vector2i.UP + Vector2i.LEFT)
			res += upRight if upRight.size() > downRight.size() else downRight
	
	return res
	
func compute_longest_house_ray(cell: Vector2i, direction: Vector2i) -> Array[Vector2i]:
	var new = cell + direction
	var res: Array[Vector2i] = []
	if !is_house_cell(new) || is_in_line(new):
		return res
	
	res += [new]
	return res + compute_longest_house_ray(new, direction)
	
func is_house_cell(cell: Vector2i) -> bool:
	if bounds.has_point(cell) and $Grids/Map.get_tile_type_in_cell(cell)==Tile.Type.HOUSE:
		return true
	return false

func is_in_line(cell: Vector2i) -> bool:
	return $GridControlsBox/HouseLineBox.is_cell_in_lines(cell)

func process_farm_square_mode():
	if get_farm_square_picking_active_fn.call():
		var mouse_cell: Vector2i = $Grids/PreviewLayer.local_to_map($Grids.get_local_mouse_position())
		if not is_farm_cell(mouse_cell):
			$GridControlsBox/FarmSquareBox.clear_preview_farm_square()
			return
		var depth = compute_largest_square(mouse_cell)
		var max_x = mouse_cell.x + depth
		var max_y = mouse_cell.y + depth
		var min_x = mouse_cell.x
		var min_y = mouse_cell.y
		# store the preview in the FarmSquareBox (for later registering)
		if depth > 0:
			$GridControlsBox/FarmSquareBox.register_preview_farm_square(min_x, min_y, depth)
			# render the preview of the farm square
			for x in range(min_x, max_x+1):
				for y in range(min_y, max_y+1):
					$Grids/PreviewLayer.set_cell(Vector2i(x,y), ATLAS_TEXTURE_LAYER_ID, FARM_SQUARE_ATLAS_IDX)

func compute_largest_square(start_cell: Vector2i) -> int:
	# Dumbest implementation: starting from a given cell, it checks the neighbors at 1-distance.
	# Then if all three are valid farm squares, then we know 2x2 exists. Repeat this for distance
	# incrementing by 1 when it passes the farm-square check.
	var ret_depth = 0
	var max_depth = 1
	var check_next_layer = true
	while check_next_layer:
		for x in range(start_cell.x, start_cell.x + max_depth + 1):
			var check_cell = Vector2i(x, start_cell.y+max_depth)
			if not is_farm_cell(check_cell):
				check_next_layer = false
		if not check_next_layer:
			break
		for y in range(start_cell.y, start_cell.y + max_depth + 1):
			var check_cell = Vector2i(start_cell.x+max_depth, y)
			if not is_farm_cell(check_cell):
				check_next_layer = false
		if check_next_layer:
			ret_depth = max_depth
			max_depth = max_depth + 1
	return ret_depth

func is_farm_cell(cell: Vector2i)-> bool:
	if bounds.has_point(cell) and $Grids/Map.get_tile_type_in_cell(cell)==Tile.Type.FARM:
		return true
	return false

func _input(event):
	if event is InputEventKey && event.is_pressed() && event.keycode == 82:
		handle_district_rotation()
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		var clicked_cell = $Grids/Map.local_to_map($Grids.get_local_mouse_position())
		try_confirm_tile_placement(clicked_cell)
		try_confirm_district_placement(clicked_cell)
		try_confirm_farm_square_marked()


func try_confirm_tile_placement(cell: Vector2i) -> bool:
	if bounds.has_point(cell):
		if placement_tile && $Grids/Map.can_place_tile_in_cell(cell, placement_tile.tile_type):
			handle_tile_map_update(cell, placement_tile)
			placement_tile = null
			try_confirm_house_line_marked(cell)
			return true
	return false

func try_confirm_district_placement(cell: Vector2i) -> bool:
	if placement_district and placeable_in_bounds(placement_district, cell, bounds):
		for off in placement_district.get_rotated_offsets():
			$Grids/DistrictLayer.set_cell(cell + off, ATLAS_TEXTURE_LAYER_ID, placement_district.get_atlas_index())
			placement_district = null
			return true
	return false

func try_confirm_farm_square_marked():
	# fetch the bounds for the farm from the preview layer
	if not get_farm_square_picking_active_fn.call():
		return
	var bounding_box = $GridControlsBox/FarmSquareBox.get_preview_farm_square_bounds()
	if bounding_box.depth < 1:
		return
	$GridControlsBox/FarmSquareBox.register_new_farm_square(bounding_box)
	$GridControlsBox/FarmSquareBox.reset_farm_square_picking_mode()
	
func try_confirm_house_line_marked(clicked_cell: Vector2i):
	$GridControlsBox/HouseLineBox.clear_lines()
	var line = compute_longest_overall()
	var placed = try_place_line(line)
	while placed:
		line = compute_longest_overall()
		placed = try_place_line(line)
		
func try_place_line(line: Array[Vector2i]) -> bool:
	if line.size() < 3:
		return false
	return $GridControlsBox/HouseLineBox.register_new_house_line(line)

func handle_district_rotation():
	if placement_district != null:
		placement_district.rotate()

func handle_tile_map_update(target_cell: Vector2i, tile_hand_item: TileHandItem):
	var tile_type = tile_hand_item.tile_type
	var tile_idx = tile_hand_item.tile_idx
	set_tile_texture_in_cell(target_cell, tile_type)
	$Grids/Map.set_tile_type_in_cell(target_cell, tile_type)
	tile_placed.emit(tile_idx, tile_type)
	if target_cell == goal_cell:
		setup_grid(grid_size + 3)

func set_tile_texture_in_cell(target_cell: Vector2i, tile_type: Tile.Type):
	var tile_texture = tile_type_to_atlas_index(tile_type)
	$Grids/Map.set_cell(target_cell, ATLAS_TEXTURE_LAYER_ID, tile_texture)

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
			&& $Grids/DistrictLayer.get_cell_atlas_coords(idx) == Vector2i(-1, -1)
	)
	
	
func setup_grid(size: int):
	grid_size = size
	bounds = Rect2i(0, 0, grid_size, grid_size)
	$Grids/BG.set_grid_bounds(bounds)
	
	
	var pos = randi() % size
	# Swaps which side the goal on is each expansion
	goal_cell = Vector2i(pos, size - 1) if goal_cell.y <= goal_cell.x else Vector2i(size - 1, pos)
	# No data being set so the cell is still "empty"
	$Grids/Map.set_cell(goal_cell, ATLAS_TEXTURE_LAYER_ID, GOAL_TILE_IDX)
	
	$Grids.scale = Vector2(15.0/grid_size, 15.0/grid_size)
	pass


	
func score_grid() -> Score:
	# Score food
	var food = $Grids/Map.get_num_placed_tiles(Tile.Type.FARM) + \
			$GridControlsBox/FarmSquareBox.get_bonus_food_production()
	
	# Score population
	var income = $Grids/Map.get_num_placed_tiles(Tile.Type.HOUSE) + \
				$GridControlsBox/HouseLineBox.get_bonus_income()
	
	return Score.new(income, food)
