extends Button

@onready var root = get_tree().current_scene

func just_pressed():
	if root == null:
		root = get_tree().current_scene
	
	var level_index = root.levels.find(root.current_level)
	
	var to = root.levels[level_index + 1]
	
	get_tree().current_scene.current_level = to
	root.begin_loading(to)

func _ready() -> void:
	pressed.connect(just_pressed)
