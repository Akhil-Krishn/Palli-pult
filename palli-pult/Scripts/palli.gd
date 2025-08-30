extends CharacterBody2D

@export var speed: float = 300.0


func _physics_process(delta: float) -> void:
	
	velocity = Vector2.RIGHT*speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity += -get_gravity() * delta * 30
	
	move_and_slide()
