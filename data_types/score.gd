extends Resource


@export var income: int
@export var food: int

func _init(income: int, food: int):
	self.income = income
	self.food = food
