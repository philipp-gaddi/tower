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
export(int, 200, 500) var distance_min = 500
export(int) var game_seed = 21061988


func _ready():
	seed(game_seed)
	
	create_room_center_coordinates2()
	
	place_rooms2()
	
	make_corridors()
	
	$Tilemap.update_bitmask_region(Vector2(-200,-200), Vector2(200,200))

func reset():
	for c in $Stuff.get_children():
		c.queue_free()
	$Tilemap.clear()


func create_room_center_coordinates2():
	
	var final_room_count = randi() % seal_room_variation + seal_room_min_count + 1
	var coordinates = []
	
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

func place_rooms2():
	
	
	var start_room = start_scene.instance()
	add_tiles_to_tileset(start_room.get_node("Tilemap").get_used_cells())
	
	var final_scenes_stack = []
	for _i in range(dungeon_room_center_coordinates.size()-1):
		final_scenes_stack.append(seal1_scene.instance())
	final_scenes_stack.append(trade_scene.instance())
	
	var room = room1_scene.instance()
	for coord_array in dungeon_room_center_coordinates:
		
		for i in range(coord_array.size()-1):
			var offset = $Tilemap.world_to_map(coord_array[i])
			add_tiles_to_tileset(room.get_node("Tilemap").get_used_cells(), offset)
		
		var final_room = final_scenes_stack.pop_front()
		var final_offset = coord_array[coord_array.size()-1]
		add_tiles_to_tileset(final_room.get_node("Tilemap").get_used_cells(),\
							$Tilemap.world_to_map(final_offset))
		
		
		for child in final_room.get_node('Stuff').get_children():
			final_room.get_node('Stuff').remove_child(child)
			child.position += final_offset
			$Stuff.add_child(child)

func make_corridors():
	
	for coord_array in dungeon_room_center_coordinates:
		var start_v = Vector2.ZERO
		for coord in coord_array:
			$Tilemap.draw_corridor(start_v, coord, 2.0, true)
			start_v = coord

func add_tiles_to_tileset(tiles, offset=Vector2.ZERO):
	for t in tiles:
		$Tilemap.set_cellv(t + offset, 0)


func _input(event):
	if event.is_action_released("ui_accept"):
		reset()
		create_room_center_coordinates2()
		place_rooms2()
		make_corridors()
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




































