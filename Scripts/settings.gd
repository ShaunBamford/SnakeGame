extends Control

@onready var resolutions_option_button = $Panel/OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	add_resolutions()
	update_button_values()
	
var resolutions = {
	"400x420": Vector2i(400, 420),
	"800x840": Vector2i(800, 840),
	"1000x1050": Vector2i(1000,1050),
	"1200x1260": Vector2i(1200, 1260),
	"1600x1680": Vector2i(1600, 1680)
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_resolutions():
	for r in resolutions:
		resolutions_option_button.add_item(r)
	


func update_button_values():
	var window_size = str(get_window().size.x, "x", get_window().size.y, "y")
	var resolutions_index = resolutions.keys().find(window_size)
	resolutions_option_button.selected = resolutions_index


func _on_option_button_item_selected(index):
	var key = resolutions_option_button.get_item_text(index)
	get_window().set_size(resolutions[key])
	centre_window()
	
func centre_window():
	var screen_centre = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_centre - window_size / 2)



	


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
