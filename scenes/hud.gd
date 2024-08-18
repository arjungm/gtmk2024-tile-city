extends Node2D

var get_money_fn = null
var get_population_fn = null
var get_food_fn = null

func update_contents(text: String):
	$VBoxContainer/HUDContents.text = text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var contents_status: String = ""
	contents_status += "Money: " + str(get_money_fn.call()) +"\n"
	contents_status += "Population: " + str(get_population_fn.call()) + "\n"
	contents_status += "Food: " + str(get_food_fn.call()) +"\n"
	update_contents(contents_status)
