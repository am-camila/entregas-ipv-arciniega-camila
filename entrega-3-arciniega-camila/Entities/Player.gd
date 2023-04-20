extends Sprite

##Export allows the variable to be edited on the inspector
export var speed:float = 80
# Called every frame. 'delta' is the elapsed time since the previous frame.
#time that passed btw calls to the funcion

#_process is called every frame possible
func _process(delta):
	#
	#	var direction:int = 0
	#	if Input.is_action_pressed("move_right"):
	#		direction += 1
	#
	#	elif Input.is_action_pressed("move_left"):
	#		direction -= 1
	
	# To avoid using "if"
	var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	position.x += direction * speed * delta
