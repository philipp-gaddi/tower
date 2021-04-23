extends Node2D

var graph:Array
export(int, 10, 1000) var width = 200
export(int, 10, 1000) var height = 100

func _ready():
	
	make_labyrinth()
	depth_first_randomizer()

func depth_first_randomizer():
	
	pass

func prim_algorithm():
	
	pass

func make_labyrinth():
	
	graph = []
	var row
	for x in range(width):
		row = []
		graph.append(row)
		for y in range(height):
			row.append(0)
	
	
	
