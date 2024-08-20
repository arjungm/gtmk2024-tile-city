extends RichTextLabel

var flag_score_history: Array[int]
var end_round_penalty_history: Array[int]
var grid_size_history: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func compute_percentage_goodness(gs: int, score: int):
	var maximum = gs*gs
	var percent = (100.0*score)/maximum
	return floor(percent)

func generate_flag_score_history():
	var N = flag_score_history.size()
	var contents = ""
	for idx in flag_score_history.size():
		var gs = grid_size_history[-idx-1]
		var fs = flag_score_history[-idx-1]
		var erp = end_round_penalty_history[idx]
		var score_line = str(N-idx)
		var percent_good = compute_percentage_goodness(gs, fs)
		score_line += " "
		score_line += "[img=20x20]res://images/flag_tile.png[/img]"
		score_line += " Score "
		score_line += str(fs)
		score_line += " (Efficiency "
		score_line += str(percent_good)
		score_line += "%)\n"
		print(score_line)
		contents += score_line
	set_text(contents)


func _on_player_flag_score_changed(flag_score: int, end_round_penalty: int, grid_size: int) -> void:
	flag_score_history.append(flag_score)
	end_round_penalty_history.append(end_round_penalty)
	grid_size_history.append(grid_size)
	generate_flag_score_history()
