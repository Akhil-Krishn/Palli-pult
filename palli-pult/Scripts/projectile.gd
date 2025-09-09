extends Node2D

var speed: float = 0.0
var slider_val:float
@export var slowest_shoot:float = 10.0
@onready var area: Area2D = $Area2D

signal hit_lizard(lizard)

func set_launch_speed(launch_speed: float,slider_value:float):
	speed = launch_speed
	slider_val = slider_value

func _ready():
	area.connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta):
	# move upward
	position.y -= speed * delta

func _on_area_entered(other_area: Area2D):
	if other_area.get_parent().is_in_group("lizard"):
		emit_signal("hit_lizard", other_area.get_parent())
		other_area.get_parent().set_zoom_rate(slider_val)
		if(abs(slider_val)<slowest_shoot):
			other_area.get_node("CollisionShape2D").queue_free()
		queue_free()
