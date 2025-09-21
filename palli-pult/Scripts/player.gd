extends Node2D

@export var ProjectileScene : PackedScene
@export var projectile_speed: float = 100.0
@export var t_projectile_speed: float = 28.0
@export var b_projectile_speed: float = 5.0
@export var camera_zoom_rate:float = 0.0

@export var mouse_limit_right:float = 200
@export var mouse_limit_left:float = -200

var top_speed_projectile
var bottom_speed_projectile

@onready var anim = $AnimatedSprite2D
@onready var camera = $"../Camera2D"

var slider_increase: bool = true
@onready var power_slider: HSlider = $"../UI/PowerSlider"
var is_aiming = false

var win = false
var reset_camera = false

func _ready():
	power_slider.hide()
	top_speed_projectile = t_projectile_speed * projectile_speed
	bottom_speed_projectile = b_projectile_speed * projectile_speed

func _unhandled_input(event):
	if not win:
		if event.is_action_pressed("shoot"):
			is_aiming = true
			anim.play("aim")
			power_slider.show()

		if event.is_action_released("shoot") and is_aiming:
			is_aiming = false
			reset_camera = true
			anim.play("shoot")
			power_slider.hide()

			var launch_speed = power_slider.value * projectile_speed
			
			if launch_speed>top_speed_projectile:
				launch_speed = top_speed_projectile
			if launch_speed<bottom_speed_projectile:
				launch_speed = bottom_speed_projectile


			var new_projectile = ProjectileScene.instantiate()
			get_tree().get_root().add_child(new_projectile)
			new_projectile.global_position = self.global_position
			new_projectile.set_launch_speed(launch_speed, power_slider.value)
			power_slider.value = 0
			new_projectile.connect("hit_lizard", Callable(self, "_on_lizard_hit"))

func _physics_process(delta):
	if reset_camera:
		if camera.zoom > Vector2(1,1):
			camera.zoom -= Vector2(1,1)*camera_zoom_rate*0.001*3
		else:
			reset_camera = false
	
	if not win:
		if is_aiming:
			if slider_increase:
				power_slider.value += 1
				camera.zoom += Vector2(1,1)*camera_zoom_rate*0.001
			else:
				power_slider.value -= 1
				if camera.zoom > Vector2(1,1):
					camera.zoom -= Vector2(1,1)*camera_zoom_rate*0.001

			if power_slider.value >= power_slider.max_value:
				slider_increase = false
			if power_slider.value <= power_slider.min_value:
				slider_increase = true

		if get_global_mouse_position().x > mouse_limit_right:
			get_global_mouse_position().x = mouse_limit_right
		
		if get_global_mouse_position().x < mouse_limit_left:
			get_global_mouse_position().x = mouse_limit_left
			 
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

func _on_animated_sprite_2d_animation_finished() -> void:
	anim.play("default")


func _on_ui_won() -> void:
	win = true
