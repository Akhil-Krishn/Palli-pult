extends Node2D

@export var palli_scene: PackedScene
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var spawn_timer: Timer = $SpawnTimer

# Spawn timing controls
@export var min_spawn_time: float = 0.8
@export var max_spawn_time: float = 3.5
@export var min_limit: float = 0.7   # lowest allowed min spawn time
@export var max_limit: float = 1.8   # lowest allowed max spawn time

# Scaling (difficulty increases over time)
@export var difficulty_ramp: float = 0.97   # slow ramp
var time_passed: float = 0.0

# Noise for natural randomness
var noise := FastNoiseLite.new()

func _ready():
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.3
	set_random_spawn_time()
	spawn_timer.start()

func _process(delta):
	time_passed += delta

func _on_spawn_timer_timeout():
	var n = noise.get_noise_1d(time_passed * 0.2)  # -1 to 1
	var spawn_chance = (n + 1.0) / 2.0             # 0..1

	if spawn_chance > 0.3:
		# group size: keep smaller most times
		var group_size: int
		if spawn_chance < 0.7:
			group_size = 1
		elif spawn_chance < 0.9:
			group_size = 2
		else:
			group_size = 3   # max out at 3, never huge waves

		for i in range(group_size):
			var palli = palli_scene.instantiate()
			palli.position = spawn_point.global_position + Vector2(randf_range(-20, 20), 0)
			add_child(palli)
			if i < group_size - 1:
				await get_tree().create_timer(randf_range(0.1, 0.25)).timeout

	# Gradually tighten spawn intervals, but clamp to safe limits
	min_spawn_time = max(min_limit, min_spawn_time * difficulty_ramp)
	max_spawn_time = max(max_limit, max_spawn_time * difficulty_ramp)

	set_random_spawn_time()

func set_random_spawn_time():
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.start()
