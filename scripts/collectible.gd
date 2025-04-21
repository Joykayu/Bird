class_name Collectible

extends Node2D

@export var ingredient: Ingredient

func collect() -> void:
	GlobalInventory.add_ingredient(ingredient)
	self.hide()
	$RespawnTimer.start()


func _on_area_2d_body_entered(body):
	if body.name == "Bird" and $RespawnTimer.is_stopped():
		collect()

func _on_respawn_timer_timeout():
	self.show()
