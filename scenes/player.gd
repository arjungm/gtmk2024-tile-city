extends Node2D

signal start_place_mode(tile: Tile.Type)

var starting_tiles = {
	Tile.Type.HOUSE: 15,
	Tile.Type.ROAD: 5
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


func _on_place_button_pressed() -> void:
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	# Try to place first tile TODO: support a list here
	var tile = $PlayerHand/HandListTiles.get_item_text(selected[0])
	start_place_mode.emit(Tile.string_to_type(tile))


func _on_grid_tile_placed(tile: Tile.Type) -> void:
	# TODO: better way to remove from list?
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	for s in selected:
		var text = $PlayerHand/HandListTiles.get_item_text(s)
		var type = Tile.string_to_type(text)
		if tile == type:
			$PlayerHand/HandListTiles.remove_item(s)
			return
