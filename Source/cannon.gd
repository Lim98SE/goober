extends StaticBody2D

var bullet = preload("res://Scenes/cannon_bullet.tscn")
var bullets_fired = 0



func fire() -> void:
	var cBullet = bullet.instantiate()
	cBullet.global_position = global_position
	cBullet.rotation = rotation
	$"..".add_child(cBullet)
	$FireSfx.play()
	$MultiTimer.start()
	pass # Replace with function body.

func _on_multi_timer_timeout() -> void:
	if bullets_fired >= 2:
		$FireTimer.start()
		return
	
	fire()
	bullets_fired += 1
	pass # Replace with function body.


func _on_fire_timer_timeout() -> void:
	bullets_fired = 0
	fire()
	pass # Replace with function body.
