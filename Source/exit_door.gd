extends Area2D

var playerReadyToExit = false
@export var tutorial = false
var playerFound = false

func detected(body: Node2D) -> void:
	if "Player" in body.get_groups() and !playerReadyToExit:
		$AnimatedSprite2D.play()
		playerFound = true
	pass # Replace with function body.

func detected_exit(body: Node2D) -> void:
	if "Player" in body.get_groups() and !playerReadyToExit:
		playerFound = false
		$AnimatedSprite2D.play_backwards()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if "Player" in body.get_groups():
			body.canMove = false
			
			if !playerReadyToExit:
				body.global_position.x = global_position.x
				body.big = true
				body.zoomIn = true
				body.get_node("Camera2D").global_position = global_position
				playerReadyToExit = true
				$AnimatedSprite2D.play_backwards()
				get_tree().current_scene.get_node("Scene/TimerUI").stopped = true
			
func anim_finished() -> void:
	if tutorial and playerFound:
		playerReadyToExit = true
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and "Player" in body.get_groups():
		if tutorial:
			var f = FileAccess.open("user://tutorialCert.bin", FileAccess.WRITE)
			f.close()
			get_tree().current_scene.begin_loading("menu")
	pass # Replace with function body.
