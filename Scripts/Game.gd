extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var current_scene = null
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	setScene("res://Scenes/StartState.tscn")
	pass



func setScene(scene):
	#clean up the current scene
	if(current_scene != null) :
		current_scene.queue_free()
	#load the file passed in as the param "scene"
	var s = ResourceLoader.load(scene)
	#create an instance of our scene
	current_scene = s.instance()
	# add scene to root
	add_child(current_scene)
