extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/mainScene.tscn")

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")

func _on_quit_pressed():
	get_tree().quit()
	
	





func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
