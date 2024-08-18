extends Node2D

signal start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type)

var starting_tiles = {
	Tile.Type.HOUSE: 7,
	Tile.Type.ROAD: 7
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
		if drawn_tile == Tile.Type.UNKNOWN:
			continue
		$PlayerHand.gain_tile(drawn_tile)


func _on_discard_button_pressed() -> void:
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	selected.reverse()
	for sel_idx in selected:
		var tile: Tile.Type = $PlayerHand.get_tile_at(sel_idx)
		$DiscardZone.put_tile(tile)
		$PlayerHand.remove_tile(sel_idx, tile)


func _on_place_button_pressed() -> void:
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	# Try to place first tile TODO: support a list here
	if selected.size() > 0:
		var tile_idx = selected[0]
		var tile_text = $PlayerHand/HandListTiles.get_item_text(tile_idx)
		var tile_type = $PlayerHand.get_tile_at(tile_idx)
		start_place_mode.emit(tile_idx, tile_text, tile_type)


func _on_grid_tile_placed(tile_idx: int, tile_type: Tile.Type) -> void:
	$PlayerHand.remove_tile(tile_idx, tile_type)
