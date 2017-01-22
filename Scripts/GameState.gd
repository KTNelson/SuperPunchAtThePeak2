extends Node2D

# class member variables go here, for example:

var game_round = 1
var game_state = "Start"

var red_charge = 50
var blue_charge = 50
var sp_node = null

var red_round_wins = 0
var blue_round_wins = 0
var winner = "White"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Countdown/COUNT").play("count")
	get_node("RedChargeBar").set_value(red_charge)
	get_node("BlueChargeBar").set_value(blue_charge)
	get_node("StreamPlayer").play()
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
	if(event.is_action_pressed("on_spacebar_hit") && game_state == "New_Game_Request"):
		reset_game()
		get_node("PlayAgain").hide()
		reset_arms()
		game_state = "Game_Reset"
	

func reset_arms():
	var blue_shoulder_node = get_node("Bluebot1/BluebotBody/BluebotShoulder");
	blue_shoulder_node.set_rot(0)
	var blue_forearm_node = get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm");
	blue_forearm_node.set_pos(Vector2(-11,51))
	var red_shoulder_node = get_node("Redbot/RedbotBody/RedbotShoulder");
	red_shoulder_node.set_rot(0);
	var red_forearm_node = get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm");
	red_forearm_node.set_pos(Vector2(-1,30))

func calculate_charge_winner():
	print("Calculate Charge Winner")
	var winner = ""
	if(red_charge > 100):
		winner = "Blue"
		blue_round_wins += 1
	elif(blue_charge > 100):
		winner = "Red"
		red_round_wins += 1
	elif(red_charge > blue_charge):
		winner = "Red"
		red_round_wins += 1
	else:
		winner = "Blue"
		blue_round_wins += 1
		
	print(winner)
	if(winner == "Blue"):
		get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BluePunch")
	else:
		get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("Punch")
	
	if(red_round_wins == 2):
		show_win("Red")
	elif(blue_round_wins == 2):
		show_win("Blue")

func show_win(colour):
	print("show win!")
	game_state = "Winning"
	winner = colour

func _on_COUNT_finished():
	game_state = "Intro"
	
func reset_game():
	red_charge = 50
	blue_charge = 50
	
	
func _on_AnimationPlayer_finished():
	if(game_state != "Restarting" && game_state != "Winning" && game_state != "New_Game_Request" && game_state != "Win Anims"):
		print("setting game state to game_reset")
		game_state = "Game_Reset"
		reset_game()
	elif(game_state == "Winning"):
		print("running winning anims")
		game_state = "Win Anims"
		if(winner == "Red"):
			get_node("Redbot/RedbotBody/RedbotShoulder/Winning").play("Win")
		elif(winner == "Blue"):
			get_node("Bluebot1/BluebotBody/BluebotShoulder/Winning").play("Win")

func _on_Winning_finished():
	print("Winning finished")
	game_state = "New_Game_Request"
	red_round_wins = 0;
	blue_round_wins = 0;
	get_node("PlayAgain").show()
	
