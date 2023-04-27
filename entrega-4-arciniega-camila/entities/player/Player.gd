extends Sprite

#onready - se carga la variable cuando se llama el callback "ready"
onready var cannon:Sprite = $Cannon

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0 
export (float) var FRICTION_WEIGHT:float = 0.1

export var speed = 200 #Pixeles

var projectile_container:Node

#Almacena la velocidad acumulada. Aumenta la vel cuando se está dando una dirección. Cuando no hay dir, empieza a frenar
var velocity:Vector2 = Vector2.ZERO
#Setea requerimiento para poder instanciar escena player. 
#Se llama en Main, al cual se le delega el instanciamiento de hijos para que no se aplique la matriz de transformación (global) del nodo.
func set_projectile_container(container:Node):
		cannon.projectile_container = container
		projectile_container = container
		print("Player- projectile container :", projectile_container)

#func _ready():
#	cannon = $Cannon

func _physics_process(delta):
	# Forma básica
#	var direction:int = 0
#	if Input.is_action_pressed("move_left"):
#		direction = -1
#	elif Input.is_action_pressed("move_right"):
#		direction = 1
	
	#position.x += direction * speed * delta
	
	# Manera optimizada
	#var direction_optimized:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))

	var mouse_position:Vector2 =get_global_mouse_position()
	#var origin:Vector2 = global_position
	#Vector que apunta de position(origen) al mouse vector(objetivo).
	#normalize() reduce la magnitud del vector para poder compararlo facilmente con otro vector normalizado
	#var direction_vector:Vector2 = (mouse_position - origin).normalized()
	
	cannon.look_at(mouse_position)
	
	if Input.is_action_just_pressed("fire"):
		cannon.fire()
		

	
######  player movement  ######
#MRUV
	var h_movement_dir:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_dir != 0:
		#clamp: determina una func min y una max
		velocity.x = clamp(velocity.x + (h_movement_dir * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		#interpolacion lineal entre dos valores. (De un punto a otro cuál es el punto entre los dos en el que se está)
		# de la velocidad actual a 0, dado un peso, se reduce la velocidad.
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0

	position += velocity * delta

