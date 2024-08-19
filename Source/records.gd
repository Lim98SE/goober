extends Control

var highscores = Score.defaults
var score_idx = 0
var scoredisplay = preload("res://Scenes/score_display.tscn")
var displays = []

func time_convert(time_in_msec: float): # https://forum.godotengine.org/t/how-to-convert-seconds-into-ddmm-ss-format/8174
	if time_in_msec == 120:
		return "No Record Set"
	
	var time_in_sec = int(time_in_msec)
	var mseconds = int(fmod(time_in_msec * 1000, 1000))
	var seconds = int(time_in_sec)%60
	var minutes = (int(time_in_sec)/60)
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d.%03d" % [minutes, seconds, mseconds]

func reload_scores():
	score_idx = 0
	highscores = Score.load_scores()
	displays.clear()
	
	for child in $ScoreScroll/ScoreCont.get_children():
		$ScoreScroll/ScoreCont.remove_child(child)
	
	for i in range(len(highscores)):
		var disp: Label = scoredisplay.instantiate()
		var score = highscores[i]
		
		disp.time_funnel = score + 1
		disp.level = i + 1
		
		disp.global_position.x = 0
		disp.global_position.y = 128 + (i * 48)
		displays.append(disp)
	
	var total = 0.0
	
	for i in highscores:
		total += i
	
	var disp: Label = scoredisplay.instantiate()
	var score = total
	
	disp.time_funnel = score + 1
	disp.level = -1
	
	disp.global_position.x = 0
	disp.global_position.y = 128 + (len(highscores) * 48)
	displays.append(disp)
	
	next_score()

func next_score() -> void:
	if score_idx >= len(displays):
		return

	$ScoreScroll/ScoreCont.add_child(displays[score_idx])
	score_idx += 1
	pass # Replace with function body.

func start_reset() -> void:
	reload_scores()
	pass # Replace with function body.
