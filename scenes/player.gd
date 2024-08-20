extends Node2D

signal start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type)

var starting_tiles = {
	Tile.Type.HOUSE: 4,
	Tile.Type.ROAD: 2,
	Tile.Type.FARM: 6
}

@export var money: int = 10
@export var round_tracker: int = 1

const base_refill_cost: int = 3
var num_refills_used: int = 0

@export var get_game_map_fn = null

# Grid/Map query functions
var fn_score_grid = null

func get_money():
	return money

func get_population():
	return fn_score_grid.call().population
	
func get_food():
	return fn_score_grid.call().food

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TileBag.refill_with(starting_tiles)
	for i in range($PlayerHand.get_maximum_hand_size()):
		draw_gain_tile()
	$HUD.get_money_fn = get_money
	$HUD.get_population_fn = get_population
	$HUD.get_food_fn = get_food

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ControlButtons/RefillButton.display_cost = get_current_refill_cost()
	$ControlButtons/RefillButton.disabled = not (can_afford_refill() and can_refill_hand())
	$ControlButtons/PlaceButton.disabled = ($PlayerHand.get_tile_count() == 0)
	$ControlButtons/EndRoundButton.display_round = round_tracker
	
func can_afford_refill():
	return money >= get_current_refill_cost()
	
func get_current_refill_cost():
	return base_refill_cost + (num_refills_used * (num_refills_used+1)/2)
	
func can_refill_hand():
	return $PlayerHand.get_tile_count() < $PlayerHand.maximum_hand_size

func _on_refill_button_pressed() -> void:
	if not can_afford_refill():
		return
	# money updates
	money -= get_current_refill_cost()
	num_refills_used += 1
	refill_hand_from_bag()
	
func refill_hand_from_bag():
	var num_desired_tiles = $PlayerHand.get_maximum_hand_size() - $PlayerHand.get_tile_count()
	var num_bag_tiles = $TileBag.get_num_tiles_in_bag()
	var num_to_draw = min(num_bag_tiles, num_desired_tiles)
	
	for i in range(num_to_draw):
		draw_gain_tile()
	
	if num_bag_tiles < num_desired_tiles:
		# refill and redraw
		put_discard_into_bag()
		num_to_draw = num_desired_tiles - num_to_draw
		for i in range(num_to_draw):
			draw_gain_tile()
	
	return num_desired_tiles

func put_discard_into_bag():
	$TileBag.refill_with($DiscardZone.discarded_tiles)
	$DiscardZone.discarded_tiles.clear()

func draw_gain_tile():
	var drawn_tile = $TileBag.get_random_tile()
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
	# TODO: compute the money gain from income
	var gained = 10
	money += gained
	round_tracker += 1
	num_refills_used = 0
	put_discard_into_bag()
	var num_draws = refill_hand_from_bag()
	var notif_msg = "Gained $" + str(gained) + "\nDrew " + str(num_draws) + " tiles"
	$Messages.notify_generic.emit(notif_msg)
