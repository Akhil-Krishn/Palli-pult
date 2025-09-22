extends Label

signal lost

@export var time_left: int = 30

func _ready() -> void:
	self.text = "Time: " +str(time_left)

func _on_timer_timeout() -> void:
	time_left -= 1
	self.text = "Time: " +str(time_left)

func _process(delta: float) -> void:
	if time_left <= 0:
		lost.emit()
