extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

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

var red_round_wins = 0
var blue_round_wins = 0
var winner = "White"

var game_round = 1
var game_state = "Start"

var red_charge = 50
var blue_charge = 50

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
		else:
			add_charge("Blue", 3)
			add_charge("Red", -3)
			get_node("Bluebot1/BluebotBody/ShakePlayer").play("Shake")

	if(event.is_action_pressed("on_spacebar_hit") && game_state == "New_Game_Request"):
		reset_game()
		get_node("PlayAgain").hide()
		game_state = "Game_Reset"

func add_attempt():
	#get marker y
	var marker_node = get_node("./Table/Marker")
	var marker_y = marker_node.get_pos().y
	var attempt_x = marker_node.get_pos().x
	if  (marker_y < 0):
		print("Hit Red")
		get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("Punch")
		calc_attempt_red(attempt_x)
	else:
		print("Hit Blue")
		get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BluePunch")
		calc_attempt_blue(attempt_x)
	
func calculate_winner():
	print("Calculate Winner")
	var red_score = get_score("Red")
	print("Red Score:" + str(red_score))
	var blue_score = get_score("Blue")
	print("Blue Score:" + str(blue_score))
	if(red_score < blue_score):
		print("Red")
		get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BlueHit")
		return "Red"
	else:
		print("Blue")
		get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("RedHit")
		return "Blue"
	pass
	
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
	print("winner is: " + winner)
	print("Blue has " + str(blue_round_wins) + " wins")
	print("Red has " + str(red_round_wins) + " wins")
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


func calc_attempt_blue(attempt_x):
	var goal_array = blue_goals[game_round]
	for hit in goal_array:
		if(attempt_x >= hit.x && attempt_x < hit.z):
			print(str(abs(hit.y - attempt_x)))
			blue_attempts.append(abs(hit.y - attempt_x))
		
	pass

func calc_attempt_red(attempt_x):
	var goal_array = red_goals[game_round]
	for hit in goal_array:
		if(attempt_x >= hit.x && attempt_x < hit.z):
			print(str(abs(hit.y - attempt_x)))
			red_attempts.append(abs(hit.y - attempt_x))
		

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
	game_round = 1
	
	
func _on_AnimationPlayer_finished():
	reset_game();
	if(game_state != "Restarting" && game_state != "Winning" && game_state != "New_Game_Request" && game_state != "Win Anims"):
		print("setting game state to game_reset")
		game_state = "Game_Reset"
	elif(game_state == "Winning"):
		print("running winning anims")
		game_state = "Win Anims"
		if(winner == "Red"):
			get_node("Redbot/RedbotBody/RedbotShoulder/Winning").play("Win")
		elif(winner == "Blue"):
			get_node("Bluebot1/BluebotBody/BluebotShoulder/Winning").play("Win")
		
	pass # replace with function body


func _on_Winning_finished():
	("Winning finished")
	game_state = "New_Game_Request"
	red_round_wins = 0;
	blue_round_wins = 0;
	get_node("PlayAgain").show()
