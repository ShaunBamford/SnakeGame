extends Node2D

# controller support
# Called when the node enters the scene tree for the first time.
func _ready():
	$back.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
# goes back to main menu when pressed
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
