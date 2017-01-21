extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func takeDamage():
	get_node("BluebotBody/BluebotShoulder/BluebotForeArm/BluebotFist/AnimationPlayer").play("BlueHit")
	print("Blue takes damage")
	
	pass