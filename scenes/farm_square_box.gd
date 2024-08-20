extends HBoxContainer

var farm_square_picking_active: bool = false

var preview_farm_square_min_x: int = -1
var preview_farm_square_min_y: int = -1
var preview_farm_square_depth: int = -1

var registered_farm_squares: Array[Dictionary] = []

# FarmSquareLayer callback to render
var farm_square_layer_render_fn = null
var farm_square_layer_clear_fn = null

const FARM_SQUARE_SIZE_SCORE_ARRAY: Array[int] = [2, 4, 8, 12]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if farm_square_picking_active:
		$FarmSquareMode.text = "Active"
	else:
		$FarmSquareMode.text = "Inactive"

func map_all_farm_square_cells(mapped_function):
	# render the farm-square in the layer map
	for fs in registered_farm_squares:
		for cx in range(fs.min_x, fs.max_x + 1):
			for cy in range(fs.min_y, fs.max_y + 1):
				var cell = Vector2i(cx, cy)
				mapped_function.call(cell)

func render_farm_squares():
	map_all_farm_square_cells(farm_square_layer_render_fn)
	
func clear_farm_squares():
	map_all_farm_square_cells(farm_square_layer_clear_fn)
		
func register_new_farm_square(bounding_box: Dictionary) -> bool:
	for cx in range(bounding_box.min_x, bounding_box.max_x + 1):
		for cy in range(bounding_box.min_y, bounding_box.max_y + 1):
			var cell = Vector2i(cx, cy)
			if check_cell_in_registered_farm_squares(cell):
				return false
	registered_farm_squares.append(bounding_box)
	render_farm_squares()
	return true

func check_cell_in_registered_farm_squares(cell: Vector2i):
	# Returns true if the cell is in any registered farm square.
	for fs in registered_farm_squares:
		if check_cell_in_farm_square(cell, fs):
			return true
	return false

func check_cell_in_farm_square(cell: Vector2i, farm_square: Dictionary):
	# Returns true if the cell is contained in the square.
	return (farm_square.min_x <= cell.x and cell.x <= farm_square.max_x and farm_square.min_y <= cell.y and cell.y <= farm_square.max_y)

func register_preview_farm_square(min_x: int, min_y: int, depth: int):
	preview_farm_square_min_x = min_x
	preview_farm_square_min_y = min_y
	preview_farm_square_depth = depth
	
func clear_preview_farm_square():
	preview_farm_square_min_x = -1
	preview_farm_square_min_y = -1
	preview_farm_square_depth = -1
	
func get_preview_farm_square_bounds():
	var out = {}
	out.min_x = preview_farm_square_min_x
	out.min_y = preview_farm_square_min_y
	out.max_x = preview_farm_square_min_x + preview_farm_square_depth
	out.max_y = preview_farm_square_min_y + preview_farm_square_depth
	out.depth = preview_farm_square_depth
	return out
	
func reset_farm_square_picking_mode():
	preview_farm_square_min_x = -1
	preview_farm_square_min_y = -1
	preview_farm_square_depth = -1
	$FarmSquareButton.toggled.emit(false)
	$FarmSquareButton.button_pressed = false

func _on_farm_square_button_toggled(toggled_on: bool) -> void:
	farm_square_picking_active = toggled_on

func get_farm_square_picking_active():
	return farm_square_picking_active
	
func get_bonus_food_production() -> int:
	var bonus_food: int = 0
	for fs in registered_farm_squares:
		var score_idx = fs.depth - 1
		bonus_food += FARM_SQUARE_SIZE_SCORE_ARRAY[score_idx]
	return bonus_food


func _on_farm_square_reset_pressed() -> void:
	clear_farm_squares()
	registered_farm_squares.clear()
