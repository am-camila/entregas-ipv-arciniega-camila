extends StaticBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var raycast = $RayCast2D
onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer


export (PackedScene) var projectile_scene

var target
var projectile_container

func _ready():
	fire_timer.connect("timeout", self, "fire")
	set_physics_process(false)

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container
	animation.play("Idle")

func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		fire_timer.start()

func _physics_process(delta):
	sprite.flip_h = target.global_position.x - global_position.x < 0
	raycast.set_cast_to(raycast.to_local(target.global_position))
	if raycast.is_colliding() && raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif !fire_timer.is_stopped():
		fire_timer.stop()


func notify_hit():
	print("I'm turret and imma die")
	animation.play("dead")
	fire_timer.stop()
	yield(get_tree().create_timer(1.5),"timeout")
	call_deferred("_remove")
	
func _remove():
	get_parent().remove_child(self)
	queue_free()


func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body
		set_physics_process(true)

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		set_physics_process(false)
