extends Label

var potential_flag_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var score: String = "Next Flag Score: " + str(potential_flag_score)
	set_text(score)


func _on_player_flag_scoring_changed(potential_fs: int, potential_er_pen: int) -> void:
	print('dong')
	potential_flag_score = potential_fs
