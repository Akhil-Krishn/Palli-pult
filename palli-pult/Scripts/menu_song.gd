extends AudioStreamPlayer2D

func _ready() -> void:
	if stream and stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		play()

func _process(delta: float) -> void:
	# Only play when game is not paused
	if get_tree().paused:
		if playing:
			stop()
	else:
		if not playing:
			play()
