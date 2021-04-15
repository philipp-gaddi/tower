extends Node2D

var room1_res
var room1
var room2

func _ready():
	room1_res = preload("res://world/firstdungeon/rooms/seal1.tscn")
	
	room2 = room1_res.instance()
	var stuff = room2.get_node("Stuff")
	
	room2.remove_child(stuff)
	stuff.position = Vector2.ZERO
	add_child(stuff)
	print(stuff.get_parent().name)


func _on_Exit_button_up():
	get_tree().quit()

func _draw():
	draw_circle(Vector2(), 5.0, Color.red)
