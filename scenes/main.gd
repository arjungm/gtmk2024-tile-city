extends Node

var get_game_map_fn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.get_num_used_cells_fn = $Grid.get_num_used_cells
	$Player.get_potential_flag_score_fn = $Grid.get_potential_flag_score
	$Player.fn_score_grid = $Grid.score_grid
	$Player.fn_house_count = get_house_count
	
	# resource loading nonsense
	

func get_house_count() -> int:
	return $Grid/Grids/Map.get_num_placed_tiles(Tile.Type.HOUSE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
