extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready():
	score_label.text = "Score: " + str(PlayerStats.score) + "\nLevel: " + str(PlayerStats.current_level)
	PlayerStats.reset_score()
	pass

func _on_menu_button_button_down():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_retry_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
