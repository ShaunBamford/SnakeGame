extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	print("MUSIC STARTING")
	


	

# Plays music forever
func _on_finished():
	$".".play()
	print("REPLAYING MUSIC")
