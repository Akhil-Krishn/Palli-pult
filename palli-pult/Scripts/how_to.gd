extends Button

var info_popup_scene: PackedScene = preload("res://Scenes/info.tscn")

func _on_pressed() -> void:
	# Create a fresh instance each time
	var popup_instance = info_popup_scene.instantiate() as Control
	get_tree().current_scene.add_child(popup_instance)

	# Connect close button
	var close_button = popup_instance.get_node("Panel/CloseButton") as Button
	close_button.pressed.connect(popup_instance.queue_free)  # removes the popup completely
