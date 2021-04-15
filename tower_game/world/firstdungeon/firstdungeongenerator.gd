extends Node2D

var dungeon_room_center_coordinates
onready var room1_scene = preload("res://world/firstdungeon/rooms/room1.tscn")
onready var seal1_scene = preload("res://world/firstdungeon/rooms/seal1.tscn")
onready var start_scene = preload("res://world/firstdungeon/rooms/startroom.tscn")
onready var trade_scene = preload("res://world/firstdungeon/rooms/trade.tscn")

export(int, 1, 10) var seal_room_min_count = 2
export(int, 1, 10) var seal_room_variation = 3
export(int, 0, 10) var intermedian_room_max_count = 3
export(int, 100, 700) var distance_variation = 500
export(int, 200, 500) var distance_min = 200
export(int) var game_seed = 21061988


func _ready():
	seed(game_seed)
	# generate how many seals are in the dungeon
	create_room_center_coordinates2()
	
	place_rooms2()

func reset():
	for c in $Stuff.get_children():
		c.queue_free()
	$Tilemap.clear()

# depricated
func create_room_center_coordinates():
	
	# how many seal rooms are created
	var seal_count = randi() % seal_room_variation + seal_room_min_count
	
	# generate how those branches look like
	# todo vary length of the paths further
	var paths = []
	var path = ''
	for i in range(seal_count):
		if randi() % 3 > 0:
			path = str(i) + 'RS'
		else:
			path = str(i) + 'S'
		paths.append(path)
	
	
	# add Trader Path
	if randi() % 3 > 0:
		path = 'RT'
	else:
		path = 'T'
	paths.append(path)
	
	
	# Generate first coordinates around the Origin
	# algo: generate weights, interpretate them as radians, add them up, convert into carthesian coord.
	var room_numbers = []	
	for _i in range(paths.size()): #
		room_numbers.append(randi() % 51 + 50)
	
	var sum = 0.0
	for i in room_numbers:
		sum += i
	
	var room_radians = []
	var radian_sum = 0.0
	for i in room_numbers:
		radian_sum += TAU * (float(i)/sum)
		room_radians.append(radian_sum)
	
	# Polar Coordinates to Carthesian
	var path_coordinates = {}
	for i in range(paths.size()):
		var room_distance = randi() % 401 + 1000
		path_coordinates[paths[i]] = [ Vector2 (
				room_distance * cos(room_radians[i]),
				room_distance * sin(room_radians[i])
			) ]
	
	# generate Coordinates for the second level final rooms
	# algorithm
	for p in paths:
		if p.length() > 1:
			var path_coord = path_coordinates[p][0]
			var distance = randi() % 200 + 800
			var angle = PI * 0.5 * (randf() - .5) # randf() * PI/2.0 - PI/4.0
			var coordinate = path_coord + \
				(path_coord.normalized() * distance).rotated(angle)
			path_coordinates[p].append(coordinate)
	
	path_coordinates['start'] = [Vector2.ZERO]
	
	dungeon_room_center_coordinates = path_coordinates

func create_room_center_coordinates2():
	# idea, create circular paths, then remove some outer points to get varriation
	# in intermediate rooms. Generate the random distances between the room centers.
	# 
	
	var final_room_count = randi() % seal_room_variation + seal_room_min_count + 1
	var coordinates = []
	
	# now rotate the paths around the center in a balanced way
	var weights = []
	var weight_sum = 0.0
	for _i in range(final_room_count):
		var weight = randi() % 80 + 20
		weight_sum += weight
		weights.append(weight_sum)
	
	var radians = []
	for w in weights:
		radians.append(w/weight_sum * TAU)
	
	
	for i in range(final_room_count):
		
		var offset = 0.0
		var coord_array = PoolVector2Array()
		var phi = radians[i]
		
		for _j in range(randi() % intermedian_room_max_count + 1):
			
			var coord = Vector2(
				float(randi() % distance_variation + distance_min) + offset,
					0.0
			)
			
			var angle_randomzier = randf() * 0.1 + 1.0 # TODO parameterize
			coord_array.append(coord.rotated(phi * angle_randomzier))
			offset = coord.x
		
		coordinates.append(coord_array)
	
	dungeon_room_center_coordinates = coordinates

# depricated
func place_rooms():
	
	if dungeon_room_center_coordinates == null:
		return
	
	for k in dungeon_room_center_coordinates.keys():
		
		var coords = dungeon_room_center_coordinates[k]
		var room_stack = []
		
		if "T" in k:
			room_stack.append(trade_scene.instance())
		elif "start" in k:
			room_stack.append(start_scene.instance())
		else:
			room_stack.append(seal1_scene.instance())
		
		for _i in range(coords.size()-1):
			room_stack.push_front(room1_scene.instance())
		
		for c in coords:
			var room = room_stack.pop_front()
			
			var offset = $Tilemap.world_to_map(c)
			print(offset, ' ', c)
			var tile_list = room.get_node('Tilemap').get_used_cells()
			
			for t in tile_list:
				t += offset
				$Tilemap.set_cellv(t, 0)
			
			if room.get_node('Stuff') != null:
				for child in room.get_node('Stuff').get_children():
					room.get_node('Stuff').remove_child(child)
					child.position += $Tilemap.map_to_world(offset)
					$Stuff.add_child(child)
			
	
	$Tilemap.update_bitmask_region(Vector2(-100,-100), Vector2(100,100))

func place_rooms2():
	
	
	var start_room = start_scene.instance()
	var scene_stack = [start_room]
	
	for coord_array in dungeon_room_center_coordinates:
		
		pass

func _input(event):
	if event.is_action_released("ui_accept"):
		reset()
		create_room_center_coordinates2()
		place_rooms2()
		update()

func _draw():
	
	if dungeon_room_center_coordinates == null:
		return
	
	for coord_array in dungeon_room_center_coordinates:
		var start_coord = Vector2.ZERO
		for c in coord_array:
			draw_line(start_coord, c, Color.red, 3.0)
			draw_circle(c, 5.0, Color.blue)
			start_coord = c
	draw_circle(Vector2.ZERO, 5.0, Color.green)




































