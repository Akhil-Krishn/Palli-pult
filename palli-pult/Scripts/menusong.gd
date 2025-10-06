extends AudioStreamPlayer2D

func _process(_delta: float) -> void:
	if not get_tree().paused and not playing:
		play()
