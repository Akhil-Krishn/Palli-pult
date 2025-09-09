extends AnimatedSprite2D

@export var dur: float = 2.0

func fade_out(duration:float):
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	await tween.finished
	queue_free()


func _ready() -> void:
	var animation_list = ["splash1","splash2","splash3","splash4"]
	var rand_animation = animation_list[randi_range(0,3)]
	self.play(rand_animation)
	fade_out(dur)
