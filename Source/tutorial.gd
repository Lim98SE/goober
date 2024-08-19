extends Button

func _physics_process(delta: float) -> void:
	if button_pressed:
		DirAccess.remove_absolute("user://tutorialCert.bin")
		get_tree().current_scene.begin_loading("level0")
