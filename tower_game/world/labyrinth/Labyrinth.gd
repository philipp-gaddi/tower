extends Node2D
# algorithms from https://en.wikipedia.org/wiki/Maze_generation_algorithm

var labyrinth:Array
export(int, 3, 1000) var width = 50
export(int, 3, 1000) var height = 40
export(int) var game_seed = 21061988
export(int, 3, 30, 3) var cell_distance = 3 
export(int, 1, 30) var door_width = 2
export(int, 0, 30) var door_offset = 0

const WALLED = 0
const LEFT_BIT = 1
const UP_BIT = 2
const RIGHT_BIT = 4
const DOWN_BIT = 8
const VISITED_BIT = 16

enum neighbour { LEFT, UP, RIGHT, DOWN, NONE }

func _ready():
	seed(game_seed)
	
	# parameter check
	
	init_labyrinth()
	depth_first_randomizer()
	make_map()

func _input(event):
	
	if event.is_action_released("ui_accept"):
		
		init_labyrinth()
		depth_first_randomizer()
		make_map()
	elif event.is_action_released("ui_focus_next"):
		make_map()

func depth_first_randomizer():
	
	var stack = [Vector2(width/2, 0)]
	labyrinth[0][width/2] |= VISITED_BIT
	
	while not stack.empty():
		
		var current_cell = stack.pop_front()
		
		var unvisited_neighbour = choose_unvisited_neighbour(current_cell)
		
		if unvisited_neighbour == neighbour.NONE:
			continue
		
		stack.push_front(current_cell)
		var neighbour_cell:Vector2
		
		match(unvisited_neighbour):
			
			neighbour.LEFT:
				
				neighbour_cell = current_cell + Vector2.LEFT
				labyrinth[current_cell.y][current_cell.x] |= LEFT_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= RIGHT_BIT
				
			neighbour.UP:
				
				neighbour_cell = current_cell + Vector2.UP
				labyrinth[current_cell.y][current_cell.x] |= UP_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= DOWN_BIT
				
			neighbour.RIGHT:
				
				neighbour_cell = current_cell + Vector2.RIGHT
				labyrinth[current_cell.y][current_cell.x] |= RIGHT_BIT
				labyrinth[neighbour_cell.y][neighbour_cell.x] |= LEFT_BIT
				
			neighbour.DOWN:
				
				neighbour_cell = current_cell + Vector2.DOWN
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
	$Tilemap.clear()
	
	# draw just the cells
	for y in range(0, height * cell_distance, cell_distance):
		for x in range(0, width * cell_distance, cell_distance):
			
			for i in range(cell_distance-1):
				for j in range(cell_distance-1):
					$Tilemap.set_cell(x+j, y+i, 0)

	# remove walls, check for right and down only
	for y in range(height):
		for x in range(width):
			var current_cell = labyrinth[y][x]

			if current_cell & RIGHT_BIT:
				var tile_x = cell_distance - 1 + x * cell_distance
				var tile_y = y * cell_distance
				for i in range(door_offset, door_width+door_offset):
					$Tilemap.set_cell(tile_x, tile_y + i, 0)
			if current_cell & DOWN_BIT:
				var tile_x = x * cell_distance
				var tile_y = cell_distance - 1 + y * cell_distance
				for i in range(door_offset, door_width+door_offset):
					$Tilemap.set_cell(tile_x + i, tile_y, 0)
	
	var region = $Tilemap.get_used_rect()
	$Tilemap.update_bitmask_region(region.position, region.end)
