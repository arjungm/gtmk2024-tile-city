extends Node2D

var discarded_tiles = {}

var get_texture_for_tile_fn = null

func put_tile(tile: Tile.Type):
	if not discarded_tiles.has(tile):
		discarded_tiles[tile] = 0
	discarded_tiles[tile] += 1
	update_item_list()

func update_item_list():
	$VBoxContainer/CenterContainer/HFlowContainer/TextureIconTextList.draw_textures(discarded_tiles)
	#$VboxContainer/CenterContainer/DiscardItemList.clear()
	#for t in discarded_tiles:
		#var c: int = discarded_tiles[t]
		#var item_text = "x" + str(c) + " " + Tile.type_to_string(t)
		#$VboxContainer/CenterContainer/DiscardItemList.add_item(item_text, get_texture_for_tile_fn.call(t))

func clear():
	discarded_tiles = {}
	update_item_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
