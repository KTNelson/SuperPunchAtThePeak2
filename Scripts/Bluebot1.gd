extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func take_damage():
	get_node("BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BlueHit")
	print("Blue takes damage")
	
	pass
	
func hide_sparks():
	get_node("BluebotBody/BlueSparks1").hide()
	get_node("BluebotBody/BlueSparks2").hide()
	get_node("BluebotBody/BlueSparks3").hide()