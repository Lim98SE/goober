extends Control

func _process(delta: float) -> void:
	for i in get_children():
		if Input.is_action_pressed(i.name):
			i.modulate = Color("#FFFFFFFF")
		
		else:
			i.modulate = Color("#FFFFFF80")
