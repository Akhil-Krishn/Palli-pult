extends Sprite2D

var frame_timer := 0.0
var frame_time := 1

func _process(delta):
	position += (get_global_mouse_position()*delta)-position
	_animate_sprite(delta)

func _animate_sprite(delta):
	frame_timer += delta
	if frame_timer >= frame_time:
		frame_timer = 0
		frame = (frame + 1) % 2  # Loop between frame 0 and 1
