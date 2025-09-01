extends Node2D

 #The projectile scene 
@export var ProjectileScene : PackedScene

@export var projectile_speed: float = 100.0

var slider_increase: bool = true

# A reference to the slider UI node
@onready var power_slider = $"../UI/PowerSlider"

var is_aiming = false

func _ready():
	# Hide the slider initially.
	power_slider.hide()


func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		is_aiming = true
		power_slider.show()


	if event.is_action_released("shoot") and is_aiming:
		is_aiming = false
		power_slider.hide()
		
		var launch_speed = power_slider.value * projectile_speed
		
		power_slider.value = 0 #reset slider value
		
		var new_projectile = ProjectileScene.instantiate()
		
		# Add the projectile to the main scene tree
		get_tree().get_root().add_child(new_projectile)
		
		# Position the projectile at the player's position
		new_projectile.global_position = self.global_position
		
		#set projectile speed
		new_projectile.set_launch_speed(launch_speed)



func _physics_process(delta):
	# If aiming, increase/decrease the slider value 
	if is_aiming:
		
		if slider_increase:
			power_slider.value+=1
		else:
			power_slider.value-=1
			
		if power_slider.value >= power_slider.max_value:
			slider_increase = false
		if power_slider.value <= power_slider.min_value:
			slider_increase = true
	
	#player/shooting item follows the mouse
	self.global_position.x = get_global_mouse_position().x
