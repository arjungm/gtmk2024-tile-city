extends HBoxContainer

var registered_house_lines: Array = []

var house_line_layer_render_fn = null
var house_line_layer_clear_fn = null

func _process(delta: float) -> void:
	for line in registered_house_lines:
		for cell in line:
			house_line_layer_render_fn.call(cell)

func register_new_house_line(new_line: Array[Vector2i]) -> bool:
	for line in registered_house_lines:
		if new_line.any(line.has):
			return false
	
	registered_house_lines.append(new_line)
	return true
	
func is_cell_in_lines(cell: Vector2i) -> bool:
	return registered_house_lines.any(func(line): return line.has(cell))
 
func _on_house_line_reset_pressed() -> void:
	clear_lines()
	
func clear_lines():
	for line in registered_house_lines:
		for cell in line:
			house_line_layer_clear_fn.call(cell)
	registered_house_lines.clear() 

func get_bonus_income() -> int:
	var bonus_income: int = 0
	for lines in registered_house_lines:
		bonus_income += bonus_for_length(lines.size())
	return bonus_income

func bonus_for_length(n: int) -> int:
	return 2 ** (n - 3)
