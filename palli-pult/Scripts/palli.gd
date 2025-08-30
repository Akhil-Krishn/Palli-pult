extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var speed: float = 180.0        # Movement stays the same
var frame_index: int = 8
var frame_timer: float = 0.0
var frame_interval: float = 0.25  # Slower animation switch
var viewport_width: float

func _ready():
	# Cache viewport width for speed
	viewport_width = get_viewport_rect().size.x

	# Dynamically set start just off left edge
	var sprite_width = sprite.texture.get_width() / sprite.hframes
	position.x = -sprite_width
	position.y = 0
	sprite.flip_h = true
	sprite.frame = frame_index

func _process(delta):
	# Move right
	position.x += speed * delta

	# Alternate frames slower
	frame_timer += delta
	if frame_timer > frame_interval:
		frame_index = 8 if frame_index == 9 else 9
		sprite.frame = frame_index
		frame_timer = 0.0

	# Exit once off right edge
	if position.x > viewport_width:
		queue_free()
