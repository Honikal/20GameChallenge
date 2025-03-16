extends Node

#Tomamos acceso a las páginas del juego
const menu_scene = preload("res://Escenas/MainMenu.tscn");
const game_scene = preload("res://Escenas/MainGame.tscn");

#Creamos una función encargada de cambiar de escena
func _change_scene(scene_tag: String):
	var scene_to_load;
	
	match (scene_tag):
		"menu":
			scene_to_load = menu_scene;
		"game":
			scene_to_load = game_scene;
			
	if (scene_to_load != null):
		get_tree().change_scene_to_packed(scene_to_load);
