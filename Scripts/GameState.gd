extends Node2D

# class member variables go here, for example:
var red_goals = { 1: [
Vector3(-170,-128,-85), 
Vector3(0,42,85),
Vector3(170, 214,256)]}
var blue_goals = {1:[
Vector3(0,-214,-170), 
Vector3(-85,-42,0),
Vector3(85, 128,170)]}

var red_attempts = []
var blue_attempts = []

var game_round = 1
var game_state = "Start"

var red_charge = 50
var blue_charge = 50
var sp_node = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Countdown/COUNT").play("count")
	get_node("RedChargeBar").set_value(red_charge)
	get_node("BlueChargeBar").set_value(blue_charge)
	set_process_input(true)
	set_fixed_process(true)
	
	pass

func add_charge(colour, marker_y):
	if(colour == "Red"):
		red_charge = red_charge + marker_y
		if(red_charge >= 100):
			red_charge = 101
		elif(red_charge < 0):
			red_charge = 0
	else:
		blue_charge = blue_charge + marker_y
		if(blue_charge >= 100):
			blue_charge = 101
		elif(blue_charge < 0):
			blue_charge = 0
	pass

func play_sound(sound):
	var sp_node = get_node("SPlayer")
	if(sound == "a"):
		sp_node.play("Powerup")
	elif(sound == "b"):
		sp_node.play("Explosion4")
	pass
	
	
func _fixed_process(delta):
	if(game_state == "Intro"):
		get_node("Table/Marker/AnimationPlayer").play("MarkerWave")
		game_state = "Play"
	
	if(game_state == "Game_Reset"):
		get_node("Countdown/COUNT").play("count")
		game_state = "Restarting"
	
	if(game_state == "Play"):
		get_node("RedCharge").set_text(str(red_charge))
		get_node("RedChargeBar").set_value(red_charge)
		get_node("BlueChargeBar").set_value(blue_charge)
		get_node("BlueCharge").set_text(str(blue_charge))	
		pass

func _input(event):
	if(event.is_action_pressed("on_spacebar_hit") && game_state == "Play"):
		var marker_node = get_node("./Table/Marker")
		var marker_y = marker_node.get_pos().y
		if  (marker_y < 0):
			add_charge("Red", 3)
			add_charge("Blue", -3)
			get_node("Redbot/RedbotBody/ShakePlayer").play("Shake")
			play_sound("a")
		else:
			add_charge("Blue", 3)
			add_charge("Red", -3)
			get_node("Bluebot1/BluebotBody/ShakePlayer").play("Shake")
			play_sound("b")

func calculate_charge_winner():
	print("Calculate Charge Winner")
	var winner = ""
	if(red_charge > 100):
		winner = "Blue"
	elif(blue_charge > 100):
		winner = "Red"
	elif(red_charge > blue_charge):
		winner = "Red"
	else:
		winner = "Blue"
	print(winner)
	if(winner == "Blue"):
		get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BluePunch")
	else:
		get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("Punch")
	pass


func get_score(colour):
	var attempts = []
	if(colour == "Red"):
		attempts = red_attempts
	else:
		attempts = blue_attempts
	var total_score = 0
	for attempt in attempts:
		total_score = attempt + total_score
	return total_score / red_goals[game_round].size()

func _on_COUNT_finished():
	game_state = "Intro"
	
func reset_game():
	red_attempts = []
	blue_attempts = []
	red_charge = 50
	blue_charge = 50
	
	
func _on_AnimationPlayer_finished():
	reset_game();
	if(game_state != "Restarting"):
		game_state = "Game_Reset"
	pass # replace with function body
