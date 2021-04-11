extends Node2D

var dungeon_room_center_coordinates

func _ready():
	
	# generate how many seals are in the dungeon
	#dungeon_room_center_coordinates = create_room_center_coordinates()
	
	# paint with tilemap
	
	
	pass
	
	


func create_room_center_coordinates():
	
	var seal_count = randi() % 3 + 2
	
	# generate how those branches look like
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
	
	print(paths)
	
	# Generate first coordinates around the Origin
	# algo: generate weights, interpretate them as radians, add them up, convert into carthesian coord.
	var room_numbers = []	
	for i in range(paths.size()): #
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
		var room_distance = randi() % 401 + 600
		path_coordinates[paths[i]] = [ Vector2 (
				room_distance * cos(room_radians[i]),
				room_distance * sin(room_radians[i])
			) ]
	
	# generate Coordinates for the second level final rooms
	# algorithm
	for p in paths:
		if p.length() > 1:
			var path_coord = path_coordinates[p][0]
			var distance = randi() % 200 + 200
			var angle = PI * 0.5 * (randf() - .5) # randf() * PI/2.0 - PI/4.0
			var coordinate = path_coord + \
				(path_coord.normalized() * distance).rotated(angle)
			path_coordinates[p].append(coordinate)
	
	return path_coordinates

func _input(event):
	if event.is_action_released("ui_accept"):
		dungeon_room_center_coordinates = create_room_center_coordinates()
		update()

func _draw():
	
	if dungeon_room_center_coordinates != null:
	
		print(dungeon_room_center_coordinates)
		
		for k in dungeon_room_center_coordinates.keys():
			var origin =  Vector2.ZERO
			var color = Color.red
			if k == "T" or k == "RT":
				color = Color.blue
			for p in dungeon_room_center_coordinates[k]:
				#draw_circle(p*.4, 5.0, color)
				draw_line(origin, p*.3, color, 5.0)
				origin = p*.3
				color *= .4
		
		draw_circle(Vector2.ZERO, 5.0, Color.green)




































