extends Node2D

var discarded_tiles = {}

func put_tile(tile: Tile.Type):
	if not discarded_tiles.has(tile):
		discarded_tiles[tile] = 0
	discarded_tiles[tile] += 1
	update_list_display()
		
	
func update_list_display():
	var contents_status: String = ""
	for t in discarded_tiles:
		var c: int = discarded_tiles[t]
		contents_status += Tile.type_to_string(t) + ": " + str(c) + "\n"
	$DiscardContentsList.text = contents_status

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
