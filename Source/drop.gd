extends RigidBody2D

var ticks = 0
var part_scn = preload("res://Scenes/drop_particles.tscn")

func _physics_process(delta: float) -> void:
	if linear_velocity.y == 0 and ticks > 1:
		var particles: CPUParticles2D = part_scn.instantiate()
		particles.position = position
		particles.emitting = true
		$"..".add_child(particles)
		queue_free()
	
	ticks += 1
