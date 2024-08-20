extends Node2D

var discarded_tiles = {}

var get_texture_for_tile_fn = null

func put_tile(tile: Tile.Type):
	if not discarded_tiles.has(tile):
		discarded_tiles[tile] = 0
	discarded_tiles[tile] += 1
	update_item_list()

func update_item_list():
	$VboxContainer/CenterContainer/DiscardItemList.clear()
	for t in discarded_tiles:
		var c: int = discarded_tiles[t]
		$VboxContainer/CenterContainer/DiscardItemList.add_item(str(c), get_texture_for_tile_fn.call(t))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
