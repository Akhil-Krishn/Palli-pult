extends Node2D

var speed: float = 0.0
@onready var area: Area2D = $Area2D

signal hit_lizard(lizard)

func set_launch_speed(launch_speed: float):
	speed = launch_speed

func _ready():
	area.connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta):
	# move upward
	position.y -= speed * delta

func _on_area_entered(other_area: Area2D):
	if other_area.get_parent().is_in_group("lizard"):
		emit_signal("hit_lizard", other_area.get_parent())
		queue_free()
