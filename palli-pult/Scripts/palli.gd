extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
var speed: float = 180.0
var direction: Vector2 = Vector2.RIGHT
var is_dead: bool = false
var is_panicking: bool = false
var fall_speed: float = 300.0   # falling speed

var frame_index: int = 8
var frame_timer: float = 0.0
var frame_interval: float = 0.18
var viewport_width: float

# panic animation
var panic_frames: Array = []
var panic_frame_index: int = 0
var panic_intro_done: bool = false
var panic_hold_frame: int = -1
var panic_hold_flip: bool = false   # flip state for hold frame

@export var turn_point: Vector2 = Vector2(300, 0)
@export var turn_slope: float = 0.20

func _ready():
	viewport_width = get_viewport_rect().size.x
	sprite.flip_h = true
	sprite.frame = frame_index
	add_to_group("lizard")

func _process(delta):
	if is_dead:
		_fall_down(delta)
	elif is_panicking:
		_run_panic(delta)
	else:
		_walk_normal(delta)

func _walk_normal(delta):
	position += direction * speed * delta

	if position.x >= turn_point.x and direction == Vector2.RIGHT:
		turn_upward()

	frame_timer += delta
	if frame_timer > frame_interval:
		frame_index = 8 if frame_index == 9 else 9
		sprite.frame = frame_index
		frame_timer = 0.0

	if position.x > viewport_width:
		queue_free()

func _fall_down(delta):
	position.y += fall_speed * delta
	sprite.frame = 0
	if position.y > get_viewport_rect().size.y:
		queue_free()

func turn_upward():
	direction = Vector2(1, turn_slope).normalized()

func die():
	is_dead = true
	is_panicking = false

# --- PANIC RUN ---
func panic_run(to_right: bool):
	if is_dead: return
	is_panicking = true
	is_dead = false

	if to_right:
		direction = Vector2(1, 0)
		# intro frames = flipped 7, flipped 6
		panic_frames = [
			{"frame": 7, "flip": true},
			{"frame": 6, "flip": true}
		]
		# HOLD forever at frame 1
		panic_hold_frame = 1
		panic_hold_flip = false
	else:
		direction = Vector2(-1, 0)
		# intro frames = flipped 7, flipped 6, 2, 3, 4
		panic_frames = [
			{"frame": 7, "flip": true},
			{"frame": 6, "flip": true},
			{"frame": 2, "flip": false},
			{"frame": 3, "flip": false},
			{"frame": 4, "flip": false}
		]
		# HOLD forever at frame 5
		panic_hold_frame = 5
		panic_hold_flip = false

	panic_frame_index = 0
	panic_intro_done = false
	_apply_panic_frame(panic_frames[0])
	frame_timer = 0.0

func _run_panic(delta):
	position += direction * (speed * 2.0) * delta

	frame_timer += delta
	if frame_timer > frame_interval:
		frame_timer = 0.0
		if not panic_intro_done:
			panic_frame_index += 1
			if panic_frame_index < panic_frames.size():
				_apply_panic_frame(panic_frames[panic_frame_index])
			else:
				# intro finished → hold forever
				panic_intro_done = true
				sprite.frame = panic_hold_frame
				sprite.flip_h = panic_hold_flip
		else:
			# holding → stay
			sprite.frame = panic_hold_frame
			sprite.flip_h = panic_hold_flip

	# free once fully off screen
	var half_width = sprite.texture.get_width() * sprite.scale.x * 0.5
	if global_position.x + half_width < 0 or global_position.x - half_width > viewport_width:
		queue_free()

func _apply_panic_frame(frame_info: Dictionary):
	sprite.frame = frame_info["frame"]
	sprite.flip_h = frame_info["flip"]
