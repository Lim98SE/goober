extends Label

var frames_between_tick = 3
var tick = 0
var time_funnel = 0
var time = 0
var funnelFinished = false
var level = 0

func funnel_tick():
	if time_funnel > 100:
		time += 100
		time_funnel -= 100
		$Tick.play()
		return
	
	if time_funnel > 10:
		time += 10
		time_funnel -= 10
		$Tick.play()
		return
	
	if time_funnel > 1:
		time += 1
		time_funnel -= 1
		$Tick.play()
		return
	
	if time_funnel > 0.1:
		time += 0.1
		time_funnel -= 0.1
		$Tick.play()
		return
	
	if time_funnel > 0.01:
		time += 0.01
		time_funnel -= 0.01
		$Tick.play()
		return
	
	if time_funnel > 0.001:
		time += 0.001
		time_funnel -= 0.001
		$Tick.play()
		return
	
	$Ding.play()
	$Cooldown.start()
	funnelFinished = true

func time_convert(time_in_msec: float): # https://forum.godotengine.org/t/how-to-convert-seconds-into-ddmm-ss-format/8174
	if time_in_msec == 120:
		return "No Record Set"
	
	var time_in_sec = int(time_in_msec)
	var mseconds = int(fmod(time_in_msec * 1000, 1000))
	var seconds = int(time_in_sec)%60
	var minutes = (int(time_in_sec)/60)
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d.%03d" % [minutes, seconds, mseconds]

func _ready() -> void:
	text = ""

func _physics_process(delta: float) -> void:
	if time_funnel >= 120 and !funnelFinished and not level is String:
		$Ding.play()
		$Cooldown.start()
		text = "Level %d: Not played yet" % level
		funnelFinished = true
		return
		
	if !funnelFinished:
		if level is String:
			text = "Total: %s" % [time_convert(time)]
		
		else:
			text = "Level %d: %s" % [level, time_convert(time)]
		
		if tick == frames_between_tick:
			funnel_tick()
			tick = 0
		
		tick += 1

func _on_cooldown_timeout() -> void:
	$"../../..".next_score()
	pass # Replace with function body.
