extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var psize = get_parent_area_size()
	set_size(psize)
	set_custom_minimum_size(psize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
