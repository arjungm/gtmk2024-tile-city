extends HBoxContainer

var registered_farm_squares: Array[Rect2i] = []

# FarmSquareLayer callback to render
var farm_square_layer_render_fn = null
var farm_square_layer_clear_fn = null

const FARM_SQUARE_SIZE_SCORE_ARRAY: Array[int] = [2, 4, 8, 12, 16, 20]


func map_all_farm_square_cells(mapped_function):
	# render the farm-square in the layer map
	for fs in registered_farm_squares:
		for cx in range(fs.position.x, fs.end.x):
			for cy in range(fs.position.y, fs.end.y):
				var cell = Vector2i(cx, cy)
				mapped_function.call(cell)

func render_farm_squares():
	map_all_farm_square_cells(farm_square_layer_render_fn)
	
func clear_farm_squares():
	map_all_farm_square_cells(farm_square_layer_clear_fn)
	registered_farm_squares.clear()
		
func register_new_farm_square(bounding_box: Rect2i) -> bool:
	for cx in range(bounding_box.position.x, bounding_box.end.x):
		for cy in range(bounding_box.position.y, bounding_box.end.y):
			var cell = Vector2i(cx, cy)
			if check_cell_in_registered_farm_squares(cell):
				return false
	registered_farm_squares.append(bounding_box)
	render_farm_squares()
	return true

func check_cell_in_registered_farm_squares(cell: Vector2i):
	# Returns true if the cell is in any registered farm square.
	for fs in registered_farm_squares:
		if fs.has_point(cell):
			return true
	return false
	
func get_bonus_food_production() -> int:
	var bonus_food: int = 0
	for fs in registered_farm_squares:
		var score_idx = fs.size.x - 2
		bonus_food += FARM_SQUARE_SIZE_SCORE_ARRAY[score_idx]
	return bonus_food
