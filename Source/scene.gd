extends Node2D

@onready var player = $Player
@onready var root = get_tree().current_scene

var finish_music_started = false

var highscores = [120, 120, 120]
var target_score = 0

@export var tutorialMode = false
var certified = false

func _ready() -> void:
	$Level.z_index = 1000
	if !tutorialMode:
		highscores = Score.load_scores()
		var level_index = root.levels.find(root.current_level)
		target_score = highscores[level_index]
		$TimerUI.best = target_score
	
	else:
		$TimerUI.tutorial = true
		
		if FileAccess.file_exists("user://tutorialCert.bin"):
			certified = true

func _process(delta: float) -> void:
	if certified:
		get_tree().current_scene.load_scene("menu")
		process_mode = PROCESS_MODE_DISABLED
		return
		
	if tutorialMode and Input.is_action_just_pressed("pause"):
		var file = FileAccess.open("user://tutorialCert.bin", FileAccess.WRITE)
		file.close()
		get_tree().current_scene.begin_loading("menu")
		
	if $TimerUI.started and not $Music.playing and not $TimerUI.stopped:
		$Player.canMove = true
		$Music.play()
	
	if $TimerUI.stopped and !finish_music_started:
		$Music.stop()
		$CompleteCooldown.start()
		finish_music_started = true
		$CompleteCooldown.timeout.connect(cooldown_finished)
		$MenuCooldown.timeout.connect(menu_finished)
		$Finished.finished.connect(_on_finished_finished)
		print("Started cooldown")

func cooldown_finished() -> void:
	$Finished.play()
	pass # Replace with function body.

func menu_finished() -> void:
	get_tree().current_scene.begin_loading("results")
	pass # Replace with function body.

func _on_finished_finished() -> void:
	$MenuCooldown.start()
	pass # Replace with function body.
