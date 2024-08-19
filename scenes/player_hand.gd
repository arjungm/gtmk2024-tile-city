extends Node2D

var maximum_hand_size = 10

var tiles_in_hand: Array[Tile.Type] = []

func get_maximum_hand_size():
	return maximum_hand_size

func get_tile_count():
	return $HandListTiles.get_item_count()
	
func gain_tile(tile: Tile.Type):
	tiles_in_hand.append(tile)
	$HandListTiles.add_item(Tile.type_to_string(tile))

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
