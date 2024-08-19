extends CharacterBody2D

var stick = 0
var lastStick = 1
var accel = 20
var decel = 0.9
var max_speed = 500

var fallGravity = 10
var jumpGravity = 5
var jumpForce = -500
var jumping = true

var bufferGrow = false

var smallGravityMult = 0.7

var big = true
var last_size_state = true
var last_stick_state = 0

@onready var big_shape = $BigShape
@onready var small_shape = $SmallShape

var coyote = 0.0
var maxCoyote = 0.2
var canJump = false

var savedStickState = 1

var original_size = true

@onready var spawpoint = global_position

var canMove = false
var zoomIn = false

func reset_state():
	global_position = spawpoint
	velocity = Vector2(0, 0)
	canJump = false
	big = original_size
	stick = savedStickState
	velocity.x = max_speed * stick
	
	if !big:
		global_position.y = spawpoint.y + 8
		print(savedStickState)
		
		if stick != 0:
			lastStick = stick
		
		velocity.x = max_speed * lastStick

var dashingDuration = 0

func _physics_process(delta: float) -> void:
	coyote += delta
	
	if !big:
		dashingDuration += delta
	
	else:
		dashingDuration = 0
	
	if zoomIn:
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(3, 3), 0.01)
	
	if big:
		stick = Input.get_axis("left", "right")
	
	if stick != 0:
		lastStick = stick
	
	if last_size_state != big:
		last_size_state = big
		
		if big:
			$Sprite.play()
			$SmallShape.disabled = true
			$BigShape.disabled = false
			
			$Area2D/Small.disabled = true
			$Area2D/Big.disabled = false
			
			$Sprite.position = Vector2(0, 0)
			
			$Particles.position = Vector2(0, 15)
			decel = 0.9
			accel = 10
			
			max_speed = 400
		
		else:
			$Sprite.play_backwards()
			$SmallShape.disabled = false
			$BigShape.disabled = true
			
			$Particles.position = Vector2(0, 8)
			$Sprite.position = Vector2(0, -8)
			
			$Area2D/Small.disabled = false
			$Area2D/Big.disabled = true
			
			decel = 1
			accel = 0
			
			max_speed = 1000

			velocity.x = max_speed * lastStick
			velocity.y = -jumpForce
	
	if canMove:
		if big:
			if stick == 0:
				velocity.x *= decel
			
			else:
				velocity.x += (accel * stick) if big else (accel * 0.5 * stick)
		
		else:
			if $CheckForWallBounceLeft.is_colliding() or $CheckForWallBounceRight.is_colliding():
				stick *= -1
				lastStick *= -1
				velocity.x = max_speed * lastStick
				$Impact.play()
			
			elif abs(velocity.x) != max_speed:
				velocity.x = max_speed * lastStick
			
		if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote < maxCoyote) and canJump:
			jumping = true
			velocity.y = jumpForce
			canJump = false
			coyote = 100
			
			$Jump.play()
		
		if velocity.y >= 0 || Input.is_action_just_released("jump"):
			jumping = false
		
		if is_on_floor():
			canJump = true
			coyote = 0
		
		if Input.is_action_pressed("toggle"):
			if big:
				$Shrink.play()
			
			big = false
		
		if Input.is_action_just_released("toggle"):
			if !$CheckForCeil.is_colliding():
				big = true
				$Grow.play()
			
			else:
				bufferGrow = true
		
		if bufferGrow && !$CheckForCeil.is_colliding():
			bufferGrow = false
			big = true
			$Grow.play()
		
		velocity.y += (jumpGravity if jumping else fallGravity) * (1 if big else smallGravityMult)
		
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		
		move_and_slide()
		
		if Input.is_action_just_pressed("reset"):
			if Input.is_action_pressed("mod"):
				get_tree().current_scene.begin_loading(get_tree().current_scene.current_level)
			
			else:
				reset_state()
				$Hurt.play()

	$Particles.emitting = is_on_floor() and abs(velocity.x) > 20
	
	if $CheckForCeil.is_colliding() and $CheckForFloor.is_colliding() and !big:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, true)
	
	else:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, false)
	
	if !is_on_floor():
		$Sprite.rotation = 0
	
	else:
		if abs(get_floor_normal().x) > 0.6:
			$Sprite.rotation_degrees = 45 * sign(get_floor_normal().x)
		
		else:
			$Sprite.rotation = 0
	
	if velocity.x < 0:
		$Sprite.flip_h = true
	
	if velocity.x > 0:
		$Sprite.flip_h = false

func _on_area(area: Area2D) -> void:
	if "Dangerous" in area.get_groups():
		reset_state()
		$Hurt.play()
	
	if "Checkpoint" in area.get_groups():
		spawpoint = area.global_position
		savedStickState = lastStick
		
	if "Bounce" in area.get_groups():
		velocity.y = jumpForce * 1.35
		$Boing.play()
		
	pass # Replace with function body.
