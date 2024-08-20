extends RichTextLabel

var flag_score_history: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_flag_score_history():
	var contents = ""
	for fs in flag_score_history:
		var score_line = ""
		score_line += " "
		score_line += "[img=20x20]res://images/flag_tile.png[/img]"
		score_line += " "
		score_line += str(fs)
		score_line += "\n"
		print(score_line)
		contents += score_line
	set_text(contents)


func _on_player_flag_score_changed(flag_score: int, flag_count: int) -> void:
	flag_score_history.append(flag_score)
	generate_flag_score_history()
