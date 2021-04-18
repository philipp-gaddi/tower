extends RigidBody2D


func _ready():
	pass


func make_room(position, size):
	self.position = position
	var rect = RectangleShape2D.new()
	rect.custom_solver_bias =.75
	rect.extents = size
	$CollisionShape2D.shape = rect
