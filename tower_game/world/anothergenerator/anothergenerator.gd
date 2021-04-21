extends Node2D
# based on youtube videos
# https://www.youtube.com/watch?v=G2_SGhmdYFo&ab_channel=KidsCanCode
# https://www.youtube.com/watch?v=U9B39sDIupc
# https://www.youtube.com/watch?v=o3fwlk1NI-w
var room_scene = preload("res://world/anothergenerator/rooms/room.tscn")
var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var game_seed = 21061988
var hspread = 400
var cull = .5
var path:AStar2D # Astar path finding object


func _ready():
	
	
	seed(game_seed)
	make_rooms()


func _process(delta):
	
	update()

func _input(event):
	if event.is_action_released("ui_accept"):
		for c in $Rooms.get_children():
			c.queue_free()
		
		path.clear()
		make_rooms()
	if event.is_action_released("ui_focus_next"):
		make_map()

func make_rooms():
	
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var room = room_scene.instance()
		var w = randi() % max_size + min_size
		var h = randi() % max_size + min_size
		room.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(room)
	
	# wait for the movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	
	#cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC # no more processing?
			room_positions.append(room.position)
	
	yield(get_tree(), "idle_frame")
	
	# generate MST
	path = find_mst(room_positions)

func make_map():
	# create tilemap from the generated rooms and maps
	$TileMap.clear()
	
	# Fill Tilemap with walls, then carve empty rooms
	var full_rect = Rect2()
	var room_rect = null
	var size = 0
	for room in $Rooms.get_children():
		size = room.get_node('CollisionShape2D').shape.extents
		room_rect = Rect2(room.position - size, size * 2)
		full_rect = full_rect.merge(room_rect)
	var topleft = $TileMap.world_to_map(full_rect.position)
	var bottomright = $TileMap.world_to_map(full_rect.end) + Vector2(1,1)
	
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			$TileMap.set_cell(x, y, 0)
	
	# Carve rooms
	var pos = null
	var upper_left = null
	var bottom_right = null
	var corridors = []
	for room in $Rooms.get_children():
		size = (room.get_node("CollisionShape2D").shape.extents / tile_size).floor()
		pos = $TileMap.world_to_map(room.position)
		upper_left = (room.position / tile_size).floor() - size
		for x in range(2, size.x * 2 -1):
			for y in range(2, size.y * 2 -1):
				$TileMap.set_cell(upper_left.x + x, upper_left.y + y, 1)
		
		# Carve corridor
		var p = path.get_closest_point(room.position)
		var start
		var end
		for c in path.get_point_connections(p):
			if not c in corridors:
				start = $TileMap.world_to_map(path.get_point_position(p))
				end = $TileMap.world_to_map(path.get_point_position(c))
				carve_path(start, end)
		corridors.append(p)
	
	

func carve_path(start, end):
	
	var x_step = sign(end.x - start.x)
	var y_step = sign(end.y - start.y)
	
	var y_vertical = start.y
	var x_horizontal = end.x
	
	if randi() % 2 > 0:
		y_vertical = end.y
		x_horizontal = start.x
	
	for x in range(start.x, end.x, x_step):
		$TileMap.set_cell(x, y_vertical + y_step, 1)
		$TileMap.set_cell(x, y_vertical, 1)
#		$TileMap.set_cell(x, y_vertical+1, 1)
	for y in range(start.y, end.y, y_step):
		$TileMap.set_cell(x_horizontal + x_step, y, 1)
		$TileMap.set_cell(x_horizontal, y, 1)
#		$TileMap.set_cell(x_horizontal+1, y, 1)

func find_mst(nodes:Array):
	# Prims Algorithm
	var _path = AStar2D.new()
	_path.add_point(
		_path.get_available_point_id(),
		nodes.pop_front()
	)
	
	# repeat until no more nodes remain
	while nodes:
		
		var min_dist = INF
		var min_position = null
		var current_point = null 
		var current_pos = null
		var distance = NAN
		
		for point in _path.get_points():
			current_pos = _path.get_point_position(point)
			for pos in nodes:
				distance = current_pos.distance_squared_to(pos)
				if distance < min_dist:
					min_dist = distance
					min_position = pos
					current_point = point
		
		var n = _path.get_available_point_id()
		_path.add_point(n, min_position)
		_path.connect_points(current_point, n)
		nodes.erase(min_position)
	
	return _path

func _draw():
	
	for room in $Rooms.get_children():
		var size = room.get_node('CollisionShape2D').shape.extents
		var position = room.position
		draw_rect(Rect2(position - size, size * 2), Color.red, false)
	
	if path:
		for p in path.get_points():
			var p_position = path.get_point_position(p)
			for c in path.get_point_connections(p):
				var c_position = path.get_point_position(c)
				draw_line(p_position, c_position, Color.green)
