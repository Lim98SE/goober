extends Node2D

func _on_audio_stream_player_finished() -> void:
	$"..".begin_loading("Level0")
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if Input.is_anything_pressed():
		$AudioStreamPlayer.stop()
		$"..".begin_loading("Level0")
