extends Node2D

@export var transitioning_to = "menu"
@export var current_level = "debugLevel"
@export var time: float = 499.807

@export var levels = [
	"Level1",
	"Level2",
	"Level3"
]

func begin_loading(to):
	transitioning_to = to
	$TransitionPlayer.play("SlideIn")

func load_scene(path):
	var full_path = "res://Scenes/%s.tscn" % path
	
	if !FileAccess.file_exists(full_path):
		print("%s does not exist!" % full_path)
		return
	
	var loaded_scene = load(full_path)
	
	if $Scene != null:
		remove_child($Scene)
	
	add_child(loaded_scene.instantiate())
	
	$TransitionPlayer.play("SlideOut")

func transition_finished(anim_name: StringName) -> void:
	if anim_name == "SlideIn":
		load_scene(transitioning_to)
	pass # Replace with function body.
