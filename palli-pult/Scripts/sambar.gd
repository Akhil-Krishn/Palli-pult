extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var splash_sfx = $AudioStreamPlayer2D

signal score_1


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("lizard"):
		area.get_parent().queue_free()
		anim.play("splash")
		splash_sfx.play()
		score_1.emit()


func _on_animated_sprite_2d_animation_finished() -> void:
	anim.play("default")
