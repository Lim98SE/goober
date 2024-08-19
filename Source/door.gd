extends Area2D

@export var id = 0
@onready var root = get_tree().current_scene.get_node("Scene/Objects")

var link: Area2D

func _ready() -> void:
	for i in root.get_children():
		if i is Area2D:
			if "Door" in i.get_groups():
				if i.id == id and i != self:
					link = i
					print(link)
					break

func _process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i is CharacterBody2D:
			if "Player" in i.get_groups() and Input.is_action_just_pressed("interact"):
				i.global_position = link.global_position
				break
