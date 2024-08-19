extends CanvasLayer

var time: float = 0
var started = false
var last = -1
var stopped = false
var paused = false
var best = 0
var bestFadedOut = false
var tutorial = false
var checked_tutorial = false

func _ready() -> void:
	if !tutorial:
		show()

func time_convert(time_in_msec: float): # https://forum.godotengine.org/t/how-to-convert-seconds-into-ddmm-ss-format/8174
	var time_in_sec = int(time_in_msec)
	var mseconds = int(fmod(time_in_msec * 1000, 1000))
	var seconds = int(time_in_sec)%60
	var minutes = (int(time_in_sec)/60)
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d.%03d" % [minutes, seconds, mseconds]

func _process(delta: float) -> void:
	if checked_tutorial: return
	if tutorial:
		for i in get_children():
			if i is DialogueBox or i is ColorRect:
				continue
			
			if i.has_method("hide"):
				i.hide()
				
		checked_tutorial = true
		get_tree().current_scene.get_node("Scene/Player").canMove = true
		return
		
	if started and !stopped and !paused:
		time += delta
	
	elif !started:
		if last != int($CountdownTimer.time_left + 1):
			last = int($CountdownTimer.time_left + 1)
			$Count.play()
			
		$Countdown.text = str(int($CountdownTimer.time_left + 1))
		
		if $CountdownTimer.time_left == 0:
			started = true
			$Countdown.queue_free()
			$Go.play()
	
	elif stopped:
		get_tree().current_scene.time = time
	
	if paused:
		get_tree().current_scene.get_node("Scene/Player").canMove = false
		
		for ch in $PauseMenu.get_children():
			if ch is Button:
				ch.disabled = false
	
	elif !paused and !$Dialog.is_running() and started and !stopped:
		get_tree().current_scene.get_node("Scene/Player").canMove = true
		
		for ch in $PauseMenu.get_children():
			if ch is Button:
				ch.disabled = true
	
	if Input.is_action_just_pressed("pause") and !$Dialog.is_running() and started and !stopped:
		paused = !paused
		
		if paused:
			$OverlayAnim.play("overlayIn")
			$PauseAnim.play("pauseIn")
		
		else:
			$OverlayAnim.play("overlayOut")
			$PauseAnim.play("pauseOut")
	
	$Timer.text = time_convert(time)
	
	if best != 120:
		$Best.text = "Best: %s" % time_convert(best)
	
		if !$BestOut.is_playing() and time > best and !bestFadedOut:
			bestFadedOut = true
			$BestOut.play("out")
	
	else:
		$Best.hide()

func _on_dialog_dialogue_started(id: String) -> void:
	$OverlayAnim.play("overlayIn")
	paused = true
	pass # Replace with function body.

func _on_dialog_dialogue_ended() -> void:
	$OverlayAnim.play("overlayOut")
	paused = false
	pass # Replace with function body.

func unpause():
	$OverlayAnim.play("overlayOut")
	$PauseAnim.play("pauseOut")
