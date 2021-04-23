extends Node2D
# algorithms from https://en.wikipedia.org/wiki/Maze_generation_algorithm

var labyrinth:Array
export(int, 10, 1000) var width = 200
export(int, 10, 1000) var height = 100
export(int) var game_seed = 21061988

const WALLED = 0
const LEFT_BIT = 1
const UP_BIT = 2
const RIGHT_BIT = 4
const DOWN_BIT = 8
const VISITED_BIT = 16


func _ready():
	seed(game_seed)
	
	init_labyrinth()
	depth_first_randomizer()
	make_map()

func depth_first_randomizer():
	
	var stack = [Vector2(1, height/2)]
	
	while not stack.empty():
		
		var current_cell = stack.pop_front()
		current_cell |= VISITED_BIT
		
		var unvisited_neighbours = choose_unvisited_neighbour(current_cell)
		
		pass

func choose_unvisited_neighbour(cell:Vector2):
	
	pass

func prim_algorithm():
	
	pass

func init_labyrinth():
	
	labyrinth = []
	var row:Array = [UP_BIT | LEFT_BIT | VISITED_BIT]
	for x in range(1, width-1):
		row.append(UP_BIT | VISITED_BIT)
	row.append(UP_BIT | RIGHT_BIT | VISITED_BIT)
	labyrinth.append(row)
	
	for y in range(1, height-1):
		row = [LEFT_BIT | VISITED_BIT]
		for x in range(1, width-1):
			row.append(WALLED)
		row.append(RIGHT_BIT | VISITED_BIT)
		labyrinth.append(row)
	
	row = [DOWN_BIT | LEFT_BIT | VISITED_BIT]
	for x in range(1, width-1):
		row.append(DOWN_BIT | VISITED_BIT)
	row.append(DOWN_BIT | RIGHT_BIT | VISITED_BIT)
	labyrinth.append(row)

func make_map():
	
	
	pass
