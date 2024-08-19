extends Button

@onready var root = get_tree().current_scene

func just_pressed():
	if root == null:
		root = get_tree().current_scene
		
	root.begin_loading(root.current_level)

func _ready() -> void:
	pressed.connect(just_pressed)
