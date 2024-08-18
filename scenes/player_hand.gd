extends Node

var maximum_hand_size = 7

func get_maximum_hand_size():
	return maximum_hand_size

func get_tile_count():
	return $HandListTiles.get_item_count()
	
func gain_tile(tile: String):
	$HandListTiles.add_item(tile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
