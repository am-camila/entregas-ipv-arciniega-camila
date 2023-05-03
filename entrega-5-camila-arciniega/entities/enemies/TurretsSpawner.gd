extends Node

export (PackedScene) var turret_scene

func _ready():
	#Enqueue call to func in spare time
	call_deferred("initialize")
	
func initialize():
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	for i in 6:
		var turret_instance = turret_scene.instance()
		
		var turret_pos: Vector2 = Vector2(rand_range(visible_rect.position.x, visible_rect.end.x + 200), rand_range(visible_rect.position.y + 30, 50))

		turret_instance.initialize(self, turret_pos, self)
