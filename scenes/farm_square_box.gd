extends HBoxContainer

var farm_square_picking_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if farm_square_picking_active:
		$FarmSquareMode.text = "Active"
	else:
		$FarmSquareMode.text = "Inactive"


func _on_farm_square_button_toggled(toggled_on: bool) -> void:
	farm_square_picking_active = toggled_on

func get_farm_square_picking_active():
	return farm_square_picking_active
