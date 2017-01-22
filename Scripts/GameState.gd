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

var game_round = 1
var game_state = "Start"

var red_charge = 0
var blue_charge = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Countdown/COUNT").play("count")
	set_process_input(true)
	set_fixed_process(true)
	pass

func _input(event):
	#if event.is_action_pressed("on_spacebar_hit"):
	#	print("SpaceBar")
	#	add_attempt()
	
	if event.is_action_pressed("on_z_hit"):
		print("z")
		add_charge("Red")
		
	if event.is_action_pressed("on_m_hit"):
		print("m")
		add_charge("Blue")
	pass

func add_charge(colour):
	var marker_node = get_node("./Table/Marker")
	var marker_y = abs(marker_node.get_pos().y)
	#marker_y = int(marker_y / 50)
	marker_y = 1
	if(colour == "Red"):
		red_charge = red_charge + marker_y
		if(red_charge == 100):
			red_charge = 101
	else:
		blue_charge = blue_charge + marker_y
		if(blue_charge == 100):
			blue_charge = 101
	
	pass

func _fixed_process(delta):
	
	if(game_state == "Intro"):
		get_node("Table/Marker/AnimationPlayer").play("MarkerWave")
		game_state = "Play"
	
	if(game_state == "Play"):
		if(Input.is_action_pressed("on_z_hit")):
			print("z")
			add_charge("Red")
		else:
			red_charge = red_charge - 1
			if(red_charge < 0):
				red_charge = 0
		if(Input.is_action_pressed("on_m_hit")):
			print("m")
			add_charge("Blue")
		else:
			blue_charge = blue_charge - 1
			if(blue_charge < 0):
				blue_charge = 0
			
		get_node("RedCharge").set_text(str(red_charge))
		get_node("BlueCharge").set_text(str(blue_charge))
	pass

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
	elif(blue_charge > 100):
		winner = "Red"
	elif(red_charge > blue_charge):
		winner = "Blue"
	else:
		winner = "Red"
	print(winner)
	if(winner == "Blue"):
		get_node("Bluebot1/BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BluePunch")
	else:
		get_node("Redbot/RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("Punch")
	pass

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
	
	
func _on_AnimationPlayer_finished():
	reset_game();
	game_state = "Start"
	get_node("Countdown/COUNT").play("count")
	pass # replace with function body
