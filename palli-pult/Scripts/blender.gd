extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D   # make sure node exists

signal score_1

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("lizard"):
		area.get_parent().queue_free()
		await play_animation()
		score_1.emit()

func play_animation() -> void:
	# Play sound effect once at the start
	if sfx.stream:
		sfx.play()

	# Make sure Sprite2D has hframes/vframes set correctly in Inspector!
	var frames = [
		0,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,0,
		9,10,11,12,13,14,15,16,17,16,17,18,11,10,9,0
	]
	for f in frames:
		sprite.frame = f
		await get_tree().create_timer(0.05).timeout
	
	# Reset to first frame
	sprite.frame = 0
