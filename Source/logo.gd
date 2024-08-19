extends Sprite2D

@onready var original = Vector2(0, 0)
var time = 0.0
var running = false

func anim_finished():
	original = global_position
	running = true

func _physics_process(delta: float) -> void:
	if running:
		time += delta
		
	global_position.x = float(original.x + (sin(time) * 16))
