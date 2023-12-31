extends Node

export var mob_scene : PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	
	mob_spawn_location.offset = randf() * 360;
	
	var player_position = $Player.transform
	
	mob.initialize(mob_spawn_location.global_transform.origin, player_position.origin)
	
	add_child(mob)
	
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_mob_squashed")
	


func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

