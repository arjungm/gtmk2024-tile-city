extends Resource


@export var population: int
@export var money: int
@export var food: int

func _init(population: int, money: int, food: int):
	self.population = population
	self.money = money
	self.food = food
