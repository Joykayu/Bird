extends Node


func _process(delta: float) -> void:
	GlobalInventory.recipe_crafted.connect(on_recipe_crafted)
	GlobalInventory.recipe_failed.connect(on_recipe_failed)
	
	
func on_recipe_crafted(_is_new_recipe) -> void:
	$RecipeCooked.play()
	$RecipeSuccess.play()

func on_recipe_failed() -> void:
	$RecipeCooked.play()
	$RecipeError.play()
