extends HBoxContainer

enum HousePickingMode {
	VERTICAL,
	HORIZONTAL,
	DIAGONAL,
	INACTIVE
}

var current_picking_mode: HousePickingMode = HousePickingMode.INACTIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mode_text = "Inactive"
	match(current_picking_mode):
		HousePickingMode.VERTICAL: mode_text = "Vertical"
		HousePickingMode.HORIZONTAL: mode_text = "Horizontal"
		HousePickingMode.DIAGONAL: mode_text = "Diagonal"
		_: mode_text = "Inactive"
	$HouseLineMode.text = mode_text
	


func _on_house_line_button_pressed() -> void:
	var enum_max_int = int(HousePickingMode.INACTIVE)+1
	var next_picking_mode: HousePickingMode = (int(current_picking_mode)+1) % enum_max_int
	print(next_picking_mode)
	current_picking_mode = next_picking_mode
