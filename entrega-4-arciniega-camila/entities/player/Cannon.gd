extends Sprite

onready var fire_position:Position2D = $FirePosition


#Packed scene - Es un wrapper que sirve para encapsular una escena que no fue cargada todavía
export (PackedScene) var projectile_scene:PackedScene
#var projectile_scene:PackedScene = preload("res://entities/player/Projectile.tscn")

var projectile_container:Node

func fire():
	var projectile_instance:Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile_instance) #agrega el nodo hijo al arbol
	#Reubicacion del proyectil a fire_position, porque arranca por default en coordenadas locales (0,0)
	projectile_instance.set_starting_values(fire_position.global_position, (fire_position.global_position - global_position).normalized())
	projectile_instance.connect("delete_requested",self,"_on_projectile_delete_requested")
	
	print(projectile_instance)
func _on_projectile_delete_requested(projectile:Projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
