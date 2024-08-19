extends Sprite2D
var drop_scn = preload("res://Scenes/drop.tscn")

func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(2, 5)
	add_child(drop_scn.instantiate())
	$Timer.start()
	$Drip.play()
	pass # Replace with function body.

func _process(delta: float) -> void:
	for child in get_children():
		if child is CPUParticles2D:
			if !child.emitting:
				child.queue_free()
