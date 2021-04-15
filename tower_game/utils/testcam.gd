extends Camera2D

onready var direction=Vector2()

func _process(_delta):
	
	self.position += direction * 30


func _input(event):
	
	if event.is_action_pressed("ui_up"):
		direction = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif event.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif event.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
	
#	self.position += direction * 100
