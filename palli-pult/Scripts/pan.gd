extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var sound = $AudioStreamPlayer2D

signal score_2

func _ready() -> void:
	# Set default/normal state at start
	sprite.frame = 7

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("lizard"):
		area.get_parent().queue_free()
		await play_animation()
		score_2.emit()


func play_animation() -> void:
	sound.play()
	# Make sure Sprite2D has hframes/vframes set correctly in Inspector!
	var frames = [
		0,1,2,3,4,3,5,6,7
	]
	for f in frames:
		sprite.frame = f
		await get_tree().create_timer(0.05).timeout
	
	# Reset to normal state (frame 7)
	sprite.frame = 7
