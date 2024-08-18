extends Node2D

var get_money_fn = null
var get_population_fn = null
var get_food_fn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var contents_status: String = ""
	contents_status += "Money: " + str(get_money_fn.call()) +"\n"
	contents_status += "Population: " + str(get_population_fn.call()) + "\n"
	contents_status += "Food: " + str(get_food_fn.call()) +"\n"
	$HUDContents.text = contents_status
