extends RichTextLabel

var current_grid_size: int = 5
var potential_flag_score: int = current_grid_size*current_grid_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var score: String = "Current Max Score: " + str(potential_flag_score)
	score += " (Efficiency " + str(compute_percentage_goodness(current_grid_size, potential_flag_score)) + "%)"
	set_text(score)

static func compute_percentage_goodness(gs: int, score: int):
	var maximum = gs*gs
	var percent = (100.0*score)/maximum
	return floor(percent)

func _on_player_flag_scoring_changed(potential_fs: int, potential_er_pen: int, grid_size: int) -> void:
	print('dong')
	potential_flag_score = potential_fs - potential_er_pen
	current_grid_size = grid_size
