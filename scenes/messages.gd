extends Node2D

signal notify_warning(message: String)

enum MessageTypes {
	INVALID_PLACEMENT_POP_FOOD,
}

func get_message_string(msg_type: MessageTypes):
	match msg_type:
		MessageTypes.INVALID_PLACEMENT_POP_FOOD:
			return "Cannot place housing.\nNot enough food!"

func show_message(msg: String):
	$CenterContainer/MessagesLabel.text = msg
	
func clear_message():
	$CenterContainer/MessagesLabel.text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/MessagesBG.set_custom_minimum_size($CenterContainer.size)
	$CenterContainer/MessagesLabel.set_custom_minimum_size($CenterContainer.size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_notify_warning(msg_type: MessageTypes) -> void:
	print("notify")
	show_message(get_message_string(msg_type))
	$FadeTimer.start()

func _on_fade_timer_timeout() -> void:
	print("timeout")
	clear_message()
	$FadeTimer.stop()
