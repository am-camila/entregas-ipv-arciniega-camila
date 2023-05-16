extends Node2D

export (PackedScene) var turret_scene
export (Vector2) var extents:Vector2

func _ready():
	call_deferred("_initialize")

func _initialize():
	for i in 3:
		var turret_instance = turret_scene.instance()
		
		var turret_pos:Vector2 = Vector2(rand_range(position.x, position.x + extents.x), rand_range(position.y, position.y + extents.y))
		
		turret_instance.initialize(self, turret_pos, self)
