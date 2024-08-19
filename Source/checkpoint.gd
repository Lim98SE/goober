extends Area2D

var enabled = 0

func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.get_groups():
		print("Player!!!")
		for i in $"..".get_children():
			if "Checkpoint" in i.get_groups() and i != self:
				i.enabled = 0
		
		if enabled != 1:
			$Sound.play()
	
		enabled = 1

func _process(delta: float) -> void:
	$Sprite2D.frame = enabled
