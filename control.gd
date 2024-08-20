extends Control

var contained_tiles = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('texture_icon_text_list')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_node_texture(t: Tile.Type):
	var ret = null
	match t:
		Tile.Type.FARM:
			ret = $TemplateRTLFarm.duplicate()
		Tile.Type.HOUSE:
			ret = $TemplateRTLHouse.duplicate()
		Tile.Type.ROAD:
			ret = $TemplateRTLRoad.duplicate()
	ret.visible = true
	return ret

func create_node_label(str: String):
	var label = Label.new()
	label.text = str
	label.set_size(Vector2(20,20))
	return label

func create_node_hbox_texture_text(t: Tile.Type, n: int):
	var hbox = HBoxContainer.new()
	hbox.set_size(Vector2(40,20))
	hbox.add_child(create_node_texture(t))
	var str = "x" + str(n)
	hbox.add_child(create_node_label(str))
	hbox.update_minimum_size()
	return hbox
	
func clear_vbox_children():
	for child in $VBox.get_children():
		$VBox.remove_child(child)
		child.queue_free()
	
func draw_textures(tiles: Dictionary):
	clear_vbox_children()
	for t in tiles:
		$VBox.add_child(create_node_hbox_texture_text(t, tiles[t]))
