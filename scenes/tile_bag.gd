extends Node2D

var contained_tiles = {}

var get_texture_for_tile_fn = null

func get_num_tiles_in_bag():
	var sum = 0
	for t in contained_tiles:
		sum += contained_tiles[t]
	return sum

func refill_with(incoming_tiles: Dictionary) -> void:
	for tile in incoming_tiles:
		var count = incoming_tiles[tile]
		if not contained_tiles.has(tile):
			contained_tiles[tile] = 0
		contained_tiles[tile] += count
	update_item_list()

func get_tile_array() -> Array[Tile.Type]:
	var tile_array: Array[Tile.Type] = []
	var keys = contained_tiles.keys()
	for k in keys:
		for i in range(contained_tiles[k]):
			tile_array.append(k)
	return tile_array


func get_random_tile() -> Tile.Type:
	var tile_array = get_tile_array()
	if tile_array.size() == 0:
		return Tile.Type.UNKNOWN
	var rand_idx = randi() % tile_array.size()
	var tile_type = tile_array[rand_idx]
	contained_tiles[tile_type] -= 1
	update_item_list()
	return tile_array[rand_idx]


func draw_tile() -> Tile.Type:
	for t in contained_tiles:
		if contained_tiles[t] > 0:
			contained_tiles[t] -= 1
			return t
			update_item_list()
	return Tile.Type.UNKNOWN


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_item_list():
	$VBoxContainer/CenterContainer/BagItemList.clear()
	for t in contained_tiles:
		var c: int = contained_tiles[t]
		$VBoxContainer/CenterContainer/BagItemList.add_item(str(c), get_texture_for_tile_fn.call(t))
