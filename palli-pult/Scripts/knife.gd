extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

signal score_2

@onready var knife_sound = $AudioStreamPlayer2D

func _ready() -> void:
	# Set default/normal state at start
	sprite.frame = 5

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("lizard"):
		area.get_parent().queue_free()
		await play_animation()
		score_2.emit()      # emit first
		collision.queue_free()

func play_animation() -> void:
	knife_sound.play()
	# Make sure Sprite2D has hframes/vframes set correctly in Inspector!
	var frames = [
		0,1,2,3,4
	]
	for f in frames:
		sprite.frame = f
		await get_tree().create_timer(0.05).timeout
	
	# Stay on last frame (4)
	sprite.frame = 4
