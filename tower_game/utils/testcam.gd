extends Camera2D

onready var direction=Vector2()

func _input(event):
	
	if event.is_action_pressed("ui_up"):
		direction = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_key_pressed(KEY_E):
		self.zoom -= Vector2(1,1)
	elif Input.is_key_pressed(KEY_Q):
		self.zoom += Vector2(1,1)
	else:
		direction = Vector2.ZERO
	
	self.position += direction * 200
