extends CanvasLayer

@onready var restartbutton = $RestartButton

func _ready():
	# This ensures that the button grabs focus after everything is ready.
	restartbutton.call_deferred("grab_focus")

signal restart

func _on_restart_button_pressed():
	restart.emit()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
