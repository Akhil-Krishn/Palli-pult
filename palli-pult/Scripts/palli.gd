extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var speed: float = 180.0        # Movement speed
var frame_index: int = 8
var frame_timer: float = 0.0
var frame_interval: float = 0.25  # Slower animation switch
var viewport_width: float

# Define the point where the lizard should turn upward
@export var turn_point: Vector2 = Vector2(300, 0)  # Adjust this to your desired point
@export var turn_slope: float = 0.20       # Y slope for upward movement (-0.26 = gentle upward)

var direction: Vector2 = Vector2.RIGHT  # Initial direction (moving right)

func _ready():
	# Cache viewport width
	viewport_width = get_viewport_rect().size.x

	# Only set position if not placed manually
	if position == Vector2.ZERO:
		var sprite_width = sprite.texture.get_width() / sprite.hframes
		position.x = -sprite_width
		position.y = 0

	# Flip sprite and set initial frame
	sprite.flip_h = true
	sprite.frame = frame_index

func _process(delta):
	# Move in current direction
	position += direction * speed * delta

	# Check if lizard has reached the turn point (only once)
	if position.x >= turn_point.x and direction == Vector2.RIGHT:
		turn_upward()

	# Alternate animation frames slowly
	frame_timer += delta
	if frame_timer > frame_interval:
		frame_index = 8 if frame_index == 9 else 9
		sprite.frame = frame_index
		frame_timer = 0.0

	# Exit once off right edge
	if position.x > viewport_width:
		queue_free()

func turn_upward():
	# Switch to a fixed upward slope
	direction = Vector2(1, turn_slope).normalized()
