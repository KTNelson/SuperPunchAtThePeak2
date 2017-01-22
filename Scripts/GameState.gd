extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var red_goals = { 1: [
Vector3(-170,-214,-85), 
Vector3(0,-42,85),
Vector3(170, 128,256)]}
var blue_goals = {1:[
Vector3(0,-214,-170), 
Vector3(-85,-42,0),
Vector3(85, 128,170)]}

var red_attempts = []
var blue_attempts = []

var game_round = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Table/Marker/AnimationPlayer").play("MarkerWave")
	set_process_input(true)
	set_fixed_process(true)
	pass

func _input(event):
	if event.is_action_pressed("on_spacebar_hit"):
		print("SpaceBar")
		add_attempt()
	pass

func _fixed_process(delta):
	#if(Input.is_action_pressed(("on_spacebar_hit")):
		#print("SpaceBar")
		#add_attempt()
		
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

func calc_attempt_blue(attempt_x):
	var goal_array = blue_goals[game_round]
	for hit in goal_array:
		if(attempt_x >= hit.x && attempt_x < hit.z):
			blue_attempts.append(abs(hit.y - attempt_x))
		
	pass

func calc_attempt_red(attempt_x):
	var goal_array = red_goals[game_round]
	for hit in goal_array:
		if(attempt_x >= hit.x && attempt_x < hit.z):
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
	
