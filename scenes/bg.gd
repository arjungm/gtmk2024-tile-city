extends TileMapLayer

@export var bounds: Rect2i

const ATLAS_LAYER_ID = 1
const BG_TILE_IDX = Vector2i(17, 9)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_grid_bounds(bounds: Rect2i):
	bounds = bounds
	clear()
	var start = bounds.position
	for i in bounds.size.x:
		for j in bounds.size.y:
			set_cell(start + Vector2i(i, j), ATLAS_LAYER_ID, BG_TILE_IDX)
