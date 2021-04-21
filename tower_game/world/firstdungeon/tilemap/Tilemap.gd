extends TileMap

var vector_start
var vector_end

func _ready():
#	vector_start = Vector2(5,6)
#	vector_end = Vector2(10,10)
#	draw_corridor(vector_start, vector_end, 2)
#
#	draw_room(Rect2(Vector2(4,4), Vector2(7,7)))
	pass

# input map coordinates!
func draw_corridor(start:Vector2, end:Vector2, half_thickness:int = 3, only_on_free=false):
	
	var vector2_pool:PoolVector2Array = bresehnham_algorithmus(start, end)
	
	vector2_pool = thicken(vector2_pool, half_thickness)
	
	if only_on_free:
		for v in vector2_pool:
			if get_cellv(v) == INVALID_CELL:
				set_cellv(v, 0)
	else:
		for v in vector2_pool:
			set_cellv(v, 0)


func draw_room(rect:Rect2):
	
	for i in range(rect.size.x):
		
		for j in range(rect.size.y):
			
			set_cellv(rect.position + Vector2(i, j), 0)
	
#	update_bitmask_region(Vector2(-50,-50), Vector2(50,50))



#func _input(event):
#
#	if event.is_action_released("mouse_left"):
#
#		clear()
#		vector_start = world_to_map(get_global_mouse_position())
#		draw_corridor(vector_start, vector_end, 2)
#	elif event.is_action_released("mouse_right"):
#		clear()
#		vector_end = world_to_map(get_global_mouse_position())
#		draw_corridor(vector_start, vector_end, 2)

func bresehnham_algorithmus(start:Vector2, end:Vector2)->PoolVector2Array:
	
	var vector2_pool = PoolVector2Array()
	var dx = abs(end.x - start.x)
	var dy = abs(end.y - start.y)
	var size = max(dx, dy) - 1
	dy *= -1
	var D = dx + dy
	var sx = 1
	var sy = 1
	if start.x >= end.x:
		sx = -1
	if start.y >= end.y:
		sy = -1
	
	vector2_pool.append(start)
	for _i in range(size):
		
		var D2 = 2 * D
		if D2 >= dy:
			D += dy
			start.x += sx
		if D2 <= dx:
			D += dx
			start.y += sy
		vector2_pool.append(start)
	vector2_pool.append(end)
	
	return vector2_pool


func thicken(vector2_pool:PoolVector2Array, half_thickness:int)->PoolVector2Array:
	
	var vector2_pool_size = vector2_pool.size()
	var vdxy:Vector2 = vector2_pool[vector2_pool_size-1] - vector2_pool[0]
	var thicc_direction:Vector2
	
	if abs(vdxy.x) >= abs(vdxy.y):
		thicc_direction = Vector2.DOWN
	else:
		thicc_direction= Vector2.RIGHT
	
	for i in range(vector2_pool_size):
		var current_v = vector2_pool[i]
		for j in range(-half_thickness, 0):
			vector2_pool.append(current_v + j * thicc_direction)
		for j in range(1, half_thickness + 1):
			vector2_pool.append(current_v + j * thicc_direction)
	
	return vector2_pool




















