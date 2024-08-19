extends Control

var time = 0
var time_funnel: float = 0

var frames_since_funnel = 0
var frames_per_funnel = 5

var funnelFinished = false
var start = false
var checkedHS = false

var highscores = []
var level_index = -1

var record = 120

@onready var root = get_tree().current_scene

func time_convert(time_in_msec: float): # https://forum.godotengine.org/t/how-to-convert-seconds-into-ddmm-ss-format/8174
	var time_in_sec = int(time_in_msec)
	var mseconds = int(fmod(time_in_msec * 1000, 1000))
	var seconds = int(time_in_sec)%60
	var minutes = (int(time_in_sec)/60)
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d.%03d" % [minutes, seconds, mseconds]

func _ready() -> void:
	time_funnel = root.time
	
	highscores = Score.load_scores()
	
	level_index = root.levels.find(root.current_level)
	
	if level_index + 1 == len(root.levels):
		$NextLevel.queue_free()

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
	
	if !funnelFinished:
		$Ding.play()
	
	funnelFinished = true

func _physics_process(delta: float) -> void:
	print(level_index)
	if start:
		if frames_since_funnel >= frames_per_funnel:
			funnel_tick()
			frames_since_funnel = 0

		frames_since_funnel += 1
	
	if funnelFinished and !checkedHS:
		checkedHS = true
		
		if highscores[level_index] < time:
			$record.text = "Best time: " + time_convert(highscores[level_index])
			$record.show()
		
		else:
			$record.show()
			Score.save_score(level_index, time)
	
	$Time.text = time_convert(time)

func _on_wait_to_start_timeout() -> void:
	start = true
	pass # Replace with function body.
