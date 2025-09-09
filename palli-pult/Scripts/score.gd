extends Label

var score:int=0

func _ready() -> void:
	self.text = "Score: " + str(score)

func _on_sambar_score_1() -> void:
	score+=1
	self.text = "Score: " + str(score)
