extends Area2D

func _physics_process(delta: float) -> void:
	global_position += Vector2(0, -1).rotated(rotation)
	
	if len(get_overlapping_bodies()) > 0:
		for i in get_overlapping_bodies():
			if "NoBullet" not in i.get_groups():
				queue_free()
				return
