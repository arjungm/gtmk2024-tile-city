extends Node2D

var get_money_fn = null
var get_income_fn = null
var get_food_fn = null

var get_income_bonus_fn = null
var get_food_bonus_fn = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_item_list()

func update_item_list():
	$VBoxContainer2/CenterContainer/HudInfoList.clear()
	var money_status = "Money: $" + str(get_money_fn.call())
	var income_status = "Base Income: $" + str(get_income_fn.call()-get_income_bonus_fn.call())
	var income_bonus_status = "Bonus Income: +$" + str(get_income_bonus_fn.call())
	var income_total = "Total Income: $" + str(get_income_fn.call()-get_income_bonus_fn.call())
	var food_status = "Base Food: " + str(get_food_fn.call()-get_food_bonus_fn.call())
	var food_bonus_status = "Bonus Food: " + str(get_food_bonus_fn.call())
	var food_total_status = "Total Food: " + str(get_food_fn.call())
	var remaining_food = get_food_fn.call() - get_income_fn.call() + get_income_bonus_fn.call()
	var rem_food_status = "Remaining Food: " + str(remaining_food)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(money_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(income_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(income_bonus_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(income_total)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(food_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(food_bonus_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(food_total_status)
	$VBoxContainer2/CenterContainer/HudInfoList.add_item(rem_food_status)
