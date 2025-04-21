class_name Collectible

extends Node2D

@export var ingredient: Ingredient

func _on_area_2d_body_entered(body):
	if body.name == "Bird":
		GlobalInventory.add_ingredient(ingredient)
