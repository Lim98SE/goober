extends Button

func _on_pressed() -> void:
	var scores = Score.load_scores()
	
	for i in range(len(scores)):
		Score.save_score(i, 120.0)

	$"..".reload_scores()
	pass # Replace with function body.
