extends KinematicBody2D

onready var cannon = $Cannon

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

export (float) var ACCELERATION:float = 60.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (int) var jump_speed = 500
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 10

var projectile_container

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT
var h_movement_direction:int

func _ready() -> void:
	initialize()

func _process(delta):
	# Check if the player is jumping
	if Input.is_action_just_pressed("jump"):
		$AnimationBody.play("jump")

	# Otherwise, play the idle animation
	else:
		if is_on_floor() && velocity.x == 0 :
			$AnimationBody.play("idle")
		
		# Check if the player is falling
		if (velocity.y > 0):
			$AnimationBody.play("fall")

   
		
		
func initialize(projectile_container: Node = get_parent()) -> void:
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container


func _process_input() -> void:
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()

	# Jump Action
	var jump = Input.is_action_just_pressed('jump')

	if jump and is_on_floor():
		velocity.y -= jump_speed

		
		
	#horizontal speed
		# Check if the player is walking
	if Input.is_action_pressed("move_left") && is_on_floor():
		$AnimationBody.flip_h = true
		$AnimationBody.play("walk")
	
	if Input.is_action_pressed("move_right") && is_on_floor():
		$AnimationBody.flip_h = false
		$AnimationBody.play("walk")

	h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:

		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0

	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)


func _physics_process(delta) -> void:
	_process_input()
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)

func notify_hit() -> void:
	print("I'm player and imma die")
	call_deferred("_remove")

func _remove() -> void:
	set_physics_process(false)
	hide()
	collision_layer = 0

