extends Node2D

var contained_tiles = {}

func refill_with(incoming_tiles: Dictionary) -> void:
	for tile in incoming_tiles:
		var count = incoming_tiles[tile]
		if not contained_tiles.has(tile):
			contained_tiles[tile] = 0
		contained_tiles[tile] += count


func draw_tile() -> Tile.Type:
	for t in contained_tiles:
		if contained_tiles[t] > 0:
			contained_tiles[t] -= 1
			return t
	return Tile.Type.UNKNOWN


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var contents_status: String = ""
	for t in contained_tiles:
		var c: int = contained_tiles[t]
		contents_status += Tile.type_to_string(t) + ": " + str(c) + "\n"
	$BagContentsList.text = contents_status
