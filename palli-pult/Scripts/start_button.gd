extends Button

func _ready():
	# Connect to a function in the same script
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
