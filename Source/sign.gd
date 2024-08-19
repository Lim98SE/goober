extends Area2D

@onready var dbubble: DialogueBox = get_tree().current_scene.get_node("Scene/TimerUI/Dialog")
@export var dialogBranch = "debugDialog"
@export var dialogData: DialogueData

func _process(delta: float) -> void:
	if len(get_overlapping_bodies()) > 0:
		for body in get_overlapping_bodies():
			if body is CharacterBody2D and "Player" in body.get_groups() and Input.is_action_just_pressed("interact") and !dbubble.is_running():
				body.canMove = false
				body.velocity = Vector2(0, 0)
				dbubble.data = dialogData
				dbubble.start(dialogBranch)
			
			if body is CharacterBody2D and "Player" in body.get_groups() and !dbubble.is_running():
				body.canMove = true

func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.get_groups():
		$AnimationPlayer.play("promptIn")
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.get_groups():
		$AnimationPlayer.play("promptOut")
	pass # Replace with function body.
