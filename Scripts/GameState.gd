extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var timer = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	set_fixed_process(true)
	pass


func _fixed_process(delta):
	timer += 1
	
	if(timer > 100):
		var game_node = get_node("./../")
		#game_node.setScene("res://Scenes/GoodEndState.tscn")
	pass

