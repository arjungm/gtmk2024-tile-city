extends Node

var starting_tiles = {
	"house": 15,
	"road": 5
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileBag.refill_with(starting_tiles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_refill_button_pressed() -> void:
	var num_remaining_tiles = $PlayerHand.get_maximum_hand_size() - $PlayerHand.get_tile_count()
	for i in range(num_remaining_tiles):
		var drawn_tile = $TileBag.draw_tile()
		if drawn_tile == $TileBag.NO_TILE_KEY:
			continue
		$PlayerHand.gain_tile(drawn_tile)
	$TileBag.print_state()


func _on_discard_button_pressed() -> void:
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	selected.reverse()
	for s in selected:
		var tile = $PlayerHand/HandListTiles.get_item_text(s)
		$DiscardZone.put_tile(tile)
		$PlayerHand/HandListTiles.remove_item(s)
	
