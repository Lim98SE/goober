extends Button

@onready var root = $"../.."

func _on_pressed() -> void:
	root.paused = false
	root.unpause()
	pass # Replace with function body.
