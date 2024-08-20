extends Node

var get_game_map_fn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_game_map_fn = $Grid.get_game_map
	$Player.get_game_map_fn = get_game_map_fn
	$Player.fn_score_grid = $Grid.score_grid
	$Player.fn_house_count = get_house_count
	
	# resource loading nonsense
	

func get_house_count() -> int:
	return $Grid/Grids/Map.get_num_placed_tiles(Tile.Type.HOUSE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
