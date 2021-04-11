extends Node2D


# todo set collision group, mask, or use groups


func _on_Area2D_body_entered(body):
	
	
	$Timer.start(5)


func _on_Area2D_body_exited(body):
	
	
	$Timer.stop()


func _on_Timer_timeout():
	
	print("seal sealed")
	
	# animation
	
	
	queue_free()

