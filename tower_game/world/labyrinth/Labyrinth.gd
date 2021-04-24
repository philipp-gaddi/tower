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

enum neighbour { LEFT, UP, RIGHT, DOWN, NONE }

func _ready():
	seed(game_seed)
	
	init_labyrinth()
	depth_first_randomizer()
	make_map()

func depth_first_randomizer():
	
	var stack = [Vector2(width/2, 0)]
	labyrinth[0][width/2] |= VISITED_BIT
	
	while not stack.empty():
		
		var current_cell = stack.pop_front()
		
		var unvisited_neighbour = choose_unvisited_neighbour(current_cell)
		
		if unvisited_neighbour == neighbour.NONE:
			print('xxx')
			continue
		
		stack.push_front(current_cell)
		var neighbour_cell:Vector2
		
		match(unvisited_neighbour):
			
			neighbour.LEFT:
				
				neighbour_cell = current_cell + Vector2.LEFT
				labyrinth[current_cell.y][current_cell.x] |= LEFT_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= RIGHT_BIT
				
			neighbour.UP:
				
				neighbour_cell = current_cell + Vector2.DOWN
				labyrinth[current_cell.y][current_cell.x] |= UP_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= DOWN_BIT
				
			neighbour.RIGHT:
				
				neighbour_cell = current_cell + Vector2.RIGHT
				labyrinth[current_cell.y][current_cell.x] |= RIGHT_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= LEFT_BIT
				
			neighbour.DOWN:
				
				neighbour_cell = current_cell + Vector2.UP
				labyrinth[current_cell.y][current_cell.x] |= DOWN_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= UP_BIT
		
		labyrinth[neighbour_cell.y][neighbour_cell.x] |= VISITED_BIT
		stack.push_front(neighbour_cell)

 
func choose_unvisited_neighbour(cell:Vector2):
	# getting the position of the neighbours cells if they weren't visited yet
	var neighbours = []
	
	if cell.y > 0 and not labyrinth[cell.y-1][cell.x] & VISITED_BIT:
		neighbours.append(neighbour.UP)
	
	if cell.y < height-1 and not labyrinth[cell.y+1][cell.x] & VISITED_BIT:
		neighbours.append(neighbour.DOWN)
	
	if cell.x > 0 and not labyrinth[cell.y][cell.x-1] & VISITED_BIT:
		neighbours.append(neighbour.LEFT)
	
	if cell.x < width-1 and not labyrinth[cell.y][cell.x+1] & VISITED_BIT:
		neighbours.append(neighbour.RIGHT)
	
	if not neighbours.empty():
		return neighbours[randi() % neighbours.size()]
	else:
		print('here')
		return neighbour.NONE


func init_labyrinth():
	labyrinth = []
	var row:Array
	
	for y in range(height):
		row = []
		for x in range(width):
			row.append(WALLED)
		labyrinth.append(row)

func make_map():
	
	for y in range(height):
		for x in range(width):
			var current_cell = labyrinth[y][x]
			
			
	
