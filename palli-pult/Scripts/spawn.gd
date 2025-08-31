extends Node2D

# Preload the palli scene
@export var palli_scene: PackedScene = preload("res://Scenes/palli.tscn")

# Reference to the Marker2D node
@onready var spawn_point: Marker2D = $SpawnPoint

# Timer node for spawning
@onready var spawn_timer: Timer = $SpawnTimer

# Minimum and maximum spawn intervals (in seconds)
@export var min_spawn_time: float = 1.0
@export var max_spawn_time: float = 3.0

func _ready():
	randomize()  # Ensure random numbers are non-deterministic
	set_random_spawn_time()
	spawn_timer.start()

func _on_spawn_timer_timeout():
	# Spawn a new palli at the Marker2D's position
	var palli = palli_scene.instantiate()
	palli.position = spawn_point.global_position
	add_child(palli)

	# Set a new random spawn interval
	set_random_spawn_time()

func set_random_spawn_time():
	# Set the Timer's wait_time to a random value between min_spawn_time and max_spawn_time
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.start()  # Restart the timer with the new interval
