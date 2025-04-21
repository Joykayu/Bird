class_name Collectible

extends Node2D

@export var ingredient: Ingredient

func collect(is_dashing) -> void:
	get_node("%"+ingredient.gather_sound_path).play()
	GlobalInventory.add_ingredient(ingredient, is_dashing)
	self.hide()
	$RespawnTimer.start()


func _on_area_2d_body_entered(body):
	if body.name == "Bird" and $RespawnTimer.is_stopped():
		collect(body.is_dashing)


func _on_respawn_timer_timeout():
	self.show()
