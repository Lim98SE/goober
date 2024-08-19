extends Area2D

@export var out = false
@export var id = 0
@onready var root = get_tree().current_scene.get_node("Scene/Objects")

var link: Area2D

func _ready() -> void:
	for i in root.get_children():
		if i is Area2D:
			if "Portal" in i.get_groups():
				if i.id == id and i.out == !out:
					link = i
					print(link)
					break
	
	$Sprite2D.frame = int(out)

func on_player(body: Node2D) -> void:
	if body is CharacterBody2D and "Player" in body.get_groups():
		if !out:
			body.global_position = link.global_position
			$use.play()
	pass # Replace with function body.
