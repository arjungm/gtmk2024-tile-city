extends Node2D

signal start_place_mode(tile_idx: int, tile_text: String, tile_type: Tile.Type)

signal flag_score_changed(flag_score: int, end_round_penalty: int, grid_size: int)

signal flag_scoring_changed(potential_fs: int, potential_er_pen: int, grid_size: int)

signal game_end
# Hardcoded value -- size after 6 rounds is 26
const GAME_END_SIZE = 25

var starting_tiles = {
	Tile.Type.HOUSE: 4,
	Tile.Type.ROAD: 2,
	Tile.Type.FARM: 6
}

var flag_score: int = 0
var flag_count: int = 0
var end_round_penalty: int = 0
var current_grid_size: int = 5

@export var money: int = 10
@export var round_tracker: int = 1

const base_refill_cost: int = 3
var num_refills_used: int = 0

@export var get_num_used_cells_fn = null
@export var get_potential_flag_score_fn = null

# Grid/Map query functions
var fn_house_count = null
var fn_score_grid = null
var fn_score_bonuses = null

func get_final_score_text() -> String:
	return str("Total Expansions: ", flag_count, "\nEnd Score: ", flag_score)

func get_money():
	return money

func get_income():
	return fn_score_grid.call().income
	
func get_food():
	return fn_score_grid.call().food

func get_food_bonus():
	return fn_score_bonuses.call().food_bonus
	
func get_income_bonus():
	return fn_score_bonuses.call().income_bonus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func new_game_setup():
	$PlayerHand.clear()
	$TileBag.clear_bag()
	$TileBag.refill_with(starting_tiles)
	$DiscardZone.clear()
	for i in range($PlayerHand.get_maximum_hand_size()):
		draw_gain_tile()
	$HUD.get_money_fn = get_money
	$HUD.get_income_fn = get_income
	$HUD.get_food_fn = get_food
	
	$HUD.get_income_bonus_fn = get_income_bonus
	$HUD.get_food_bonus_fn = get_food_bonus
	flag_count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ControlButtons/RefillButton.display_cost = get_current_refill_cost()
	$ControlButtons/RefillButton.disabled = not (can_afford_refill() and can_refill_hand())
	$ControlButtons/PlaceButton.disabled = ($PlayerHand.get_tile_count() == 0)
	$ControlButtons/EndRoundButton.display_penalty = (get_num_used_cells_fn.call()+1)/2
	
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
		return fn_house_count.call() < get_food()
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
	flag_scoring_changed.emit(get_potential_flag_score_fn.call(), end_round_penalty, current_grid_size)

func handle_tile_placement(tile_type: Tile.Type):
	match tile_type:
		Tile.Type.ROAD:
			draw_gain_tile()
		_:
			pass


func _on_end_round_button_pressed() -> void:
	var gained = get_income()
	money += gained
	round_tracker += 1
	num_refills_used = 0
	put_discard_into_bag()
	var num_draws = refill_hand_from_bag()
	var notif_msg = "Gained $" + str(gained) + "\nDrew " + str(num_draws) + " tiles"
	end_round_penalty += (get_num_used_cells_fn.call()+1)/2
	$Messages.notify_generic.emit(notif_msg)
	flag_scoring_changed.emit(get_potential_flag_score_fn.call(), end_round_penalty, current_grid_size)

func _on_grid_flag_claimed(grid_size: int, used_tiles: int) -> void:
	flag_score = (grid_size*grid_size) - used_tiles - end_round_penalty
	flag_score_changed.emit(flag_score, end_round_penalty, grid_size)
	end_round_penalty = 0
	flag_scoring_changed.emit(get_potential_flag_score_fn.call(), end_round_penalty, grid_size)
	flag_count += 1
	if grid_size >= GAME_END_SIZE:
		game_end.emit()


func _on_grid_grid_size_changed(grid_size: int) -> void:
	flag_scoring_changed.emit(get_potential_flag_score_fn.call(), end_round_penalty, grid_size)
	current_grid_size = grid_size


func _on_place_farm_pressed() -> void:
	generic_place_tile(Tile.Type.FARM)

func generic_place_tile(ttype: Tile.Type):
	if $PlayerHand.contains_tile_type(ttype):
		var ret = $PlayerHand.get_tile_from_hand(ttype)
		var tile_idx = ret.tile_idx
		var tile_text = ret.tile_text
		var tile_type = ret.tile_type
		if can_place_tile(ttype):
			start_place_mode.emit(tile_idx, tile_text, tile_type)
		else:
			$Messages.notify_warning.emit($Messages.MessageTypes.INVALID_PLACEMENT_POP_FOOD)
			$PlayerHand.reset_selection()


func _on_place_house_pressed() -> void:
	generic_place_tile(Tile.Type.HOUSE)


func _on_place_road_pressed() -> void:
	generic_place_tile(Tile.Type.ROAD)


func _on_main_game_started() -> void:
	new_game_setup()
