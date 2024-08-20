extends Node2D

var maximum_hand_size = 5

var tiles_in_hand: Array[Tile.Type] = []

var get_texture_for_tile_fn = null

func get_maximum_hand_size():
	return maximum_hand_size

func get_tile_count():
	return $HandListTiles.get_item_count()

func contains_tile_type(ttype: Tile.Type) -> bool:
	for t in tiles_in_hand:
		if ttype == t:
			return true
	return false

func get_tile_from_hand(ttype: Tile.Type) -> Dictionary:
	var out = {}
	for i in range(tiles_in_hand.size()):
		if tiles_in_hand[i] == ttype:
			out.tile_idx = i
			out.tile_text = Tile.type_to_string(ttype)
			out.tile_type = ttype
			return out
	return out

func remove_tile_type(ttype: Tile.Type):
	for i in range(tiles_in_hand.size()):
		if tiles_in_hand[i] == ttype:
			tiles_in_hand.remove_at(i)

func gain_tile(tile: Tile.Type):
	tiles_in_hand.append(tile)
	$HandListTiles.add_item(Tile.type_to_string(tile), get_texture_for_tile_fn.call(tile))

func remove_tile(tile_idx: int, tile_type: Tile.Type):
	tiles_in_hand.remove_at(tile_idx)
	$HandListTiles.remove_item(tile_idx)

func get_tile_at(tile_idx: int) -> Tile.Type:
	return tiles_in_hand[tile_idx]
	
func get_selected_items():
	return $HandListTiles.get_selected_items()
	
func reset_selection():
	$HandListTiles.deselect_all()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
