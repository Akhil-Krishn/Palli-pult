extends Node2D

var blood_sprayed:bool = false
var zoom_rate:float = 1.0
@export var z_rate: float = 1
@export var scale_max: float = 0.275
@export var blood_scn: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var death_sfx = $AudioStreamPlayer2D
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

func set_zoom_rate(slider_val:float):
	zoom_rate = slider_val

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


func fade_out(obj:Node2D,duration:float):
	var tween = create_tween()
	tween.tween_property(obj, "modulate:a", 0.0, duration)
	await tween.finished
	queue_free()


func _fall_down(delta):
	sprite.frame = 0
	if self.scale.x < scale_max:
		fade_out(self,0.5)
		if not blood_sprayed:
			death_sfx.play()
			var blood = blood_scn.instantiate()
			blood.position = self.global_position
			self.get_parent().add_child(blood)
			blood_sprayed = true
		return
	if position.y > get_viewport_rect().size.y:
		queue_free()
	position.y += fall_speed * delta
	self.scale-= self.scale*abs(zoom_rate)*z_rate*0.0001


func turn_upward():
	direction = Vector2(1, turn_slope).normalized()

func die():
	is_dead = true
	self.get_node("Area2D").set_collision_mask_value(2,true)
	self.get_node("Area2D").set_collision_mask_value(1,false)
	self.get_node("Area2D").set_collision_layer_value(2,true)
	self.get_node("Area2D").set_collision_layer_value(1,false)
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
