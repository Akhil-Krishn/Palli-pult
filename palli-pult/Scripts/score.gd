extends Label

var score:int=0

func _ready() -> void:
	self.text = "Score: " + str(score)

func _on_sambar_score_1() -> void:
	score+=3
	self.text = "Score: " + str(score)

func _on_blender_score_2() -> void:
	score+=1
	self.text = "Score: " + str(score)

func _on_pan_score_2() -> void:
	score+=2
	self.text = "Score: " + str(score)

func _on_knife_score_2() -> void:
	score+=1
	self.text = "Score: " + str(score)
