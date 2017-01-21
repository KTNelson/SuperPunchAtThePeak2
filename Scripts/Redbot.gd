extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func takeDamage():
	get_node("RedbotBody/RedbotShoulder/RedbotForeArm/RedbotFist/AnimationPlayer").play("RedHit")
	print("Red takes damage")
	
	pass