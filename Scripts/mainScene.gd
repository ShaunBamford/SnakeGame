extends Node

@export var snake_scene : PackedScene
@onready var eating = $eat 
@onready var die = $die 
@onready var move = $move
#game variables
var score : int
var game_started : bool = false
var highscore : int = 0

const SAVE_FILE_PATH = "user://savedata.save"

#grid variables
var cells : int = 20
var cell_size : int = 50

#food variables
var food_pos : Vector2
var regen_food : bool = true

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variables
var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move: bool

#audio variables


# Called when game starts
func _ready():
	new_game()
	
func new_game():
	load_game()
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	$GameOverMenu.hide()
	# Update the score to the highscore if it's greater than the current score
	if highscore > score:
		score = 0
	$Hud.get_node("ScoreLabel").text = str(score)
	$Hud.get_node("HighScoreLabel").text = str(highscore)
	move_direction = up
	can_move = true
	generate_snake()
	move_food()
	
# generates snake
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start_pos, create tail segments vertically down
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))
		
func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_snake()
	
func move_snake():
	if can_move:
		#update movement from keypresses
		if Input.is_action_just_pressed("ui_down") and move_direction != up:
			$move.play()
			move_direction = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("ui_up") and move_direction != down:
			$move.play()
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("ui_left") and move_direction != right:
			$move.play()
			move_direction = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("ui_right") and move_direction != left:
			$move.play()
			move_direction = right
			can_move = false
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$MoveTimer.start()


func _on_move_timer_timeout():
	#allow snake movement
	can_move = true
	#use the snake's previous position to move the segments
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		#move all the segments along by one
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	
	# check if snake has gone out of bounds, if so end game.
func check_out_of_bounds():
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells - 1:
		end_game()
	# check if snake has ate snake, if so end game.		
func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
			
func check_food_eaten():
	#if snake eats the food, add a segment and move the food
	if snake_data[0] == food_pos:
		eating.play()
		score += 1
		if score >= highscore:
			highscore = score
		$Hud.get_node("ScoreLabel").text = str(score)
		$Hud.get_node("HighScoreLabel").text = str(highscore)
		add_segment(old_data[-1])
		move_food()

# moves food when food been ate
func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Food.position = (food_pos * cell_size)+ Vector2(0, cell_size)
	regen_food = true
# ends game and displays a game over screen
func end_game():
	save_game()	
	if score >= highscore:
		highscore = score
	can_move = false
	$die.play()
	$GameOverMenu.show()
	$MoveTimer.stop()
	game_started = false
	

# when play again pressed, restart game
func _on_game_over_menu_restart():
	new_game()
	
	
func save():
	var save_dict = {
		"highscore" : highscore
	}
	return save_dict
	
func save_game():
	var save_game = FileAccess.open("user://data.save", FileAccess.WRITE)
	var jsonString = JSON.stringify(save())
	
	save_game.store_line(jsonString)
	
func load_game():
	if not FileAccess.file_exists("user://data.save"):
		return
		
	var save_game = FileAccess.open("user://data.save", FileAccess.READ)
	var jsonString = save_game.get_as_text() # This gets the entire file text.
	var json = JSON.new()
	var parse_result = json.parse(jsonString)
	
	if parse_result == OK:
		var node_data = json.get_data()
		highscore = node_data["highscore"]
		highscore = int(highscore) # Access the highscore from the dictionary.
		print("Highscore: ", highscore)
		$Hud.get_node("HighScoreLabel").text = str(highscore)
	else:
		print("Failed to parse JSON.")
