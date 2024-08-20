extends Button

@onready var on = get_tree().current_scene.instrumental

func _ready() -> void:
	button_down.connect(toggle)

func _physics_process(delta: float) -> void:
	if on:
		text = "Music: Inst"
	
	else:
		text = "Music: Lyrics"

func toggle():
	get_tree().current_scene.instrumental = !get_tree().current_scene.instrumental
	on = get_tree().current_scene.instrumental
