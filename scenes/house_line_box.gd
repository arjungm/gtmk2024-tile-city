extends HBoxContainer

var current_picking_mode = HousePickingMode.Type.INACTIVE

var registered_house_lines: Array = []

var house_line_layer_render_fn = null

func get_current_picking_mode():
	return current_picking_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reset_house_line_picking_mode():
	current_picking_mode = HousePickingMode.Type.INACTIVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mode_text = "Inactive"
	match(current_picking_mode):
		HousePickingMode.Type.VERTICAL: mode_text = "Vertical"
		HousePickingMode.Type.HORIZONTAL: mode_text = "Horizontal"
		HousePickingMode.Type.DIAGONAL: mode_text = "Diagonal"
		_: mode_text = "Inactive"
	$HouseLineMode.text = mode_text
	
	for line in registered_house_lines:
		for cell in line:
			house_line_layer_render_fn.call(cell)


func _on_house_line_button_pressed() -> void:
	var enum_max_int = int(HousePickingMode.Type.INACTIVE)+1
	var next_picking_mode: HousePickingMode.Type = (int(current_picking_mode)+1) % enum_max_int
	print(next_picking_mode)
	current_picking_mode = next_picking_mode
	
func register_new_house_line(new_line: Array[Vector2i]) -> bool:
	for line in registered_house_lines:
		if new_line.any(line.has):
			return false
	
	registered_house_lines.append(new_line)
	return true
