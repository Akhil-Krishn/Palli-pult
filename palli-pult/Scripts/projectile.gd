extends Area2D


# The projectile's initial velocity
var speed: float = 0.0

# The projectile's direction
var direction: Vector2 = Vector2.UP

# This function is called by the Player script to set the initial velocity
func set_launch_speed(s: float):
	speed = s


func _physics_process(delta: float):

	# Move the projectile up
	position += speed * delta * direction
	
	
	# Removing the projectile if it passes over the screen
	if position.y > get_viewport_rect().size.y:
		queue_free()



# This is triggered when the projectile's area overlaps with a physics body
func _on_body_entered(body: Node2D):
	queue_free() # Destroy the projectile
