extends HBoxContainer

var farm_square_picking_active: bool = false

var preview_farm_square_min_x: int = -1
var preview_farm_square_min_y: int = -1
var preview_farm_square_depth: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if farm_square_picking_active:
		$FarmSquareMode.text = "Active"
	else:
		$FarmSquareMode.text = "Inactive"

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
