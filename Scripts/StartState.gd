extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	
	pass

func _input(event):
	if event.is_action_pressed("start_screen_start"):
		var game_node = get_node("./../")
		game_node.setScene("res://Scenes/GameState.tscn")


func _on_Button_pressed():
	var game_node = get_node("./../")
	game_node.setScene("res://Scenes/GameState.tscn")
	pass # replace with function body
