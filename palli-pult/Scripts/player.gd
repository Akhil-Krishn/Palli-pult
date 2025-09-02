extends Node2D

@export var ProjectileScene : PackedScene
@export var projectile_speed: float = 100.0

var slider_increase: bool = true
@onready var power_slider: HSlider = $"../UI/PowerSlider"
var is_aiming = false

func _ready():
	power_slider.hide()

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		is_aiming = true
		power_slider.show()

	if event.is_action_released("shoot") and is_aiming:
		is_aiming = false
		power_slider.hide()

		var launch_speed = power_slider.value * projectile_speed
		power_slider.value = 0

		var new_projectile = ProjectileScene.instantiate()
		get_tree().get_root().add_child(new_projectile)
		new_projectile.global_position = self.global_position
		new_projectile.set_launch_speed(launch_speed)

		new_projectile.connect("hit_lizard", Callable(self, "_on_lizard_hit"))

func _physics_process(delta):
	if is_aiming:
		if slider_increase:
			power_slider.value += 1
		else:
			power_slider.value -= 1

		if power_slider.value >= power_slider.max_value:
			slider_increase = false
		if power_slider.value <= power_slider.min_value:
			slider_increase = true

	self.global_position.x = get_global_mouse_position().x

func _on_lizard_hit(lizard):
	lizard.die()

	# panic nearby
	var radius = 150
	for other in get_tree().get_nodes_in_group("lizard"):
		if other != lizard and not other.is_dead and not other.is_panicking:
			if lizard.global_position.distance_to(other.global_position) < radius:
				var run_right = randi() % 2 == 0
				other.panic_run(run_right)
