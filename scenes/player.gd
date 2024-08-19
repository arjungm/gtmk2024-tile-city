extends Node2D

signal start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type)

var starting_tiles = {
	Tile.Type.HOUSE: 1,
	Tile.Type.ROAD: 1,
	Tile.Type.FARM: 8
}

@export var money: int = 0

@export var get_game_map_fn = null

# Grid/Map query functions
var fn_get_num_placed_tiles = null
var fn_get_bonus_food = null

func get_money():
	return money

func get_population():
	return fn_get_num_placed_tiles.call(Tile.Type.HOUSE)
	
func get_food():
	return fn_get_num_placed_tiles.call(Tile.Type.FARM) + fn_get_bonus_food.call()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileBag.refill_with(starting_tiles)
	$HUD.get_money_fn = get_money
	$HUD.get_population_fn = get_population
	$HUD.get_food_fn = get_food

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_refill_button_pressed() -> void:
	var num_remaining_tiles = $PlayerHand.get_maximum_hand_size() - $PlayerHand.get_tile_count()
	for i in range(num_remaining_tiles):
		draw_gain_tile()

func draw_gain_tile():
	var drawn_tile = $TileBag.draw_tile()
	if drawn_tile == Tile.Type.UNKNOWN:
		return
	$PlayerHand.gain_tile(drawn_tile)

func _on_discard_button_pressed() -> void:
	var selected = $PlayerHand/HandListTiles.get_selected_items()
	selected.reverse()
	for sel_idx in selected:
		var tile: Tile.Type = $PlayerHand.get_tile_at(sel_idx)
		$DiscardZone.put_tile(tile)
		$PlayerHand.remove_tile(sel_idx, tile)

func can_place_tile(tile_type: Tile.Type) -> bool:
	if tile_type == Tile.Type.HOUSE:
		return get_population() < get_food()
	return true

func _on_place_button_pressed() -> void:
	var selected = $PlayerHand.get_selected_items()
	# Try to place first tile TODO: support a list here
	if selected.size() > 0:
		var tile_idx = selected[0]
		var tile_text = $PlayerHand/HandListTiles.get_item_text(tile_idx)
		var tile_type = $PlayerHand.get_tile_at(tile_idx)
		if can_place_tile(tile_type):
			start_place_mode.emit(tile_idx, tile_text, tile_type)
		else:
			$Messages.notify_warning.emit($Messages.MessageTypes.INVALID_PLACEMENT_POP_FOOD)
			$PlayerHand.reset_selection()


func _on_grid_tile_placed(tile_idx: int, tile_type: Tile.Type) -> void:
	$PlayerHand.remove_tile(tile_idx, tile_type)
	$DiscardZone.put_tile(tile_type)
	handle_tile_placement(tile_type)

func handle_tile_placement(tile_type: Tile.Type):
	match tile_type:
		Tile.Type.ROAD:
			draw_gain_tile()
		_:
			pass
	

func _on_end_round_button_pressed() -> void:
	update_tile_simulation() # Replace with function body.

func update_tile_simulation():
	get_game_map_fn.call()
