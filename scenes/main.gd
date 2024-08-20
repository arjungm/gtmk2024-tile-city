extends Node

var get_game_map_fn = null

@export var tile_type_to_texture_map = {}

signal game_started()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("main")
	$Player.get_num_used_cells_fn = $Grid.get_num_used_cells
	$Player.get_potential_flag_score_fn = $Grid.get_potential_flag_score
	$Player.fn_score_grid = $Grid.score_grid
	$Player.fn_score_bonuses = $Grid.score_info_bonuses
	$Player.fn_house_count = get_house_count
	
	# resource loading nonsense
	tile_type_to_texture_map[Tile.Type.FARM] = load_texture_for_tile_type(Tile.Type.FARM)
	tile_type_to_texture_map[Tile.Type.HOUSE] = load_texture_for_tile_type(Tile.Type.HOUSE)
	tile_type_to_texture_map[Tile.Type.ROAD] = load_texture_for_tile_type(Tile.Type.ROAD)
	
	# provide to hand
	$Player/PlayerHand.get_texture_for_tile_fn = get_texture_for_tile_type
	$Player/DiscardZone.get_texture_for_tile_fn = get_texture_for_tile_type
	$Player/TileBag.get_texture_for_tile_fn = get_texture_for_tile_type
	
	game_started.emit()

func get_texture_for_tile_type(tile_type: Tile.Type):
	return tile_type_to_texture_map[tile_type].duplicate()
	
func load_texture_for_tile_type(tile_type: Tile.Type):
	var img_base_name = ""
	match tile_type:
		Tile.Type.FARM:
			img_base_name = "farm"
		Tile.Type.HOUSE:
			img_base_name = "house"
		Tile.Type.ROAD:
			img_base_name = "road"
	var path = "res://images/" + img_base_name + ".png"
	var image = Image.load_from_file(path)
	image.resize(20,20)
	var texture = ImageTexture.create_from_image(image)
	return texture

func get_house_count() -> int:
	return $Grid/Grids/Map.get_num_placed_tiles(Tile.Type.HOUSE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
