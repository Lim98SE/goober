extends Button

@export var to = "debug_level"

func _process(delta: float) -> void:
	if is_node_ready():
		if button_pressed:
			print("Pressed!")
			disabled = true
			
			for i in get_tree().current_scene.get_node("Scene").get_children():
				if i is Button:
					i.disabled = true
					
					if i.get_child_count() > 0:
						for j in i.get_children():
							if j is Button:
								j.disabled = true
			
			get_tree().current_scene.current_level = to
			get_tree().current_scene.begin_loading(to)
