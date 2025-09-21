extends Control

signal won

@onready var score_label = $Score
@onready var win_disp = $Victory
@onready var lose_disp = $Loose
@onready var power_slider = $PowerSlider
@onready var timer_label = $Game_Timer

@export var winning_score:int = 10

func _process(delta: float) -> void:
	if score_label.score >= winning_score:
		on_win()
		won.emit()

func on_win():
	win_disp.visible = true
	score_label.visible = false
	timer_label.visible = false
	power_slider.visible = false

func on_loose():
	lose_disp.visible = true
	score_label.visible = false
	timer_label.visible = false
	power_slider.visible = false


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_rety_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_game_timer_lost() -> void:
	on_loose()
